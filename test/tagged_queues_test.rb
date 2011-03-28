require 'test_helper'

class TaggedQueuesTest < Test::Unit::TestCase
  class Worker < Resque::Worker
    public :has_tags?
  end

  def add_queues(*queues)
    queues.each { |queue| Resque.redis.sadd(:queues, queue) }
  end

  test 'check default behaviour' do
    add_queues('builds')
    assert_equal ['builds'], Resque.queues
    assert_equal ['builds'], Worker.new('builds').queues
  end

  test 'has_tags? returns true if the queue does not have any tags' do
    assert Worker.new('builds[1.8.7,1.9.2]').has_tags?('builds')
  end

  test 'has_tags? returns true if all required tags are available' do
    assert Worker.new('builds[1.8.7,1.9.2]').has_tags?('builds[1.8.7,1.9.2]')
  end

  test 'has_tags? returns true if more than the required tags are available' do
    assert Worker.new('builds[1.8.7,1.9.2,ree,jruby]').has_tags?('builds[1.8.7,1.9.2]')
  end

  test 'has_tags? returns false if less than the required tags are available' do
    assert !Worker.new('builds[1.8.7]').has_tags?('builds[1.8.7,1.9.2]')
  end

  test 'has_tags? returns false if no tags are available' do
    assert !Worker.new('builds').has_tags?('builds[1.8.7,1.9.2]')
  end

  test 'queues selects an existing redis queue for that all required tags are available' do
    add_queues('builds[1.8.7,1.9.2]')
    assert_equal ['builds[1.8.7,1.9.2]'], Worker.new('builds[1.8.7,1.9.2]').queues
  end

  test 'queues selects existing redis queues for that all more than the required tags are available' do
    add_queues('builds[1.8.7]', 'builds[1.9.2]')
    assert_equal ['builds[1.8.7]', 'builds[1.9.2]'], Worker.new('builds[1.8.7,1.9.2]').queues
  end

  test 'queues selects an existing redis queue for that no tags are required' do
    add_queues('builds')
    assert_equal ['builds'], Worker.new('builds[1.8.7,1.9.2]').queues
  end

  test 'queues does not select an existing redis queue that is not supported (w/ tags availabe)' do
    add_queues('notsupported')
    assert_equal [], Worker.new('builds[1.8.7,1.9.2]').queues
  end

  test 'queues does not select an existing redis queue that is not supported (w/ no tags availabe)' do
    add_queues('notsupported')
    assert_equal [], Worker.new('builds').queues
  end

  test 'queues does not select an existing redis queue for that some tags are not available' do
    add_queues('builds[1.8.7,1.9.2]')
    assert_equal [], Worker.new('builds[1.8.7]').queues
  end

  test 'queues does not select an existing redis queue if no tags are available' do
    add_queues('builds[1.8.7,1.9.2]')
    assert_equal [], Worker.new('builds').queues
  end
end
