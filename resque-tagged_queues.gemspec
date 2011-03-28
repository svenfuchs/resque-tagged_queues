# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'resque_tagged_queues/version'

Gem::Specification.new do |s|
  s.name         = "resque-tagged-queues"
  s.version      = ResqueTaggedQueues::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/resque-tagged_queues"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir.glob("{lib/**/*,test/**/*,[A-Z]*}")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'resque'

  s.add_development_dependency 'test_declarative'
  s.add_development_dependency 'ruby-debug'
  s.add_development_dependency 'system_timer'
end
