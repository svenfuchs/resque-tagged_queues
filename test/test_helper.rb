require 'test/unit'
require 'bundler/setup'

require 'ruby-debug'
require 'test_declarative'
require 'test_helpers/mock_redis'

require 'resque'
require 'resque/tagged_queues'

class Test::Unit::TestCase
  attr_reader :redis

  def setup
    Resque.redis = MockRedis.new
  end

  def teardown
    Resque.redis.flushall
  end
end

