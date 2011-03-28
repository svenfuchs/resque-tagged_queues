module Resque
  module TaggedQueues
    def self.included(base)
      base.class_eval do
        alias :intialize_without_tagging :initialize
        alias :initialize :initialize_with_tagging

        alias :queues_without_tagging :queues
        alias :queues :queues_with_tagging
      end
    end

    attr_reader :tags

    def initialize_with_tagging(*args)
      intialize_without_tagging(*args)
      @tags = parse_queues(@queues)
    end

    def queues_with_tagging
      Resque.queues.select { |queue| has_tags?(queue) }.sort
    end

    protected

      def has_tags?(queue)
        name, required  = *parse_queue(queue)
        available = tags[name] || []
        tags.keys.include?(name) and required & available == required
      end

      def parse_queues(queues)
        queues.inject({}) do |result, queue|
          name, tags = *parse_queue(queue)
          tags ? result.merge(name => tags) : result
        end
      end

      def parse_queue(queue)
        queue =~ /([^\]]*)\[([^\]]*)\]$/ ? [$1, $2.split(',')] : [queue, []]
      end

      Resque::Worker.send(:include, self)
  end
end

