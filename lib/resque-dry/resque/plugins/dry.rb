module Resque
  module Plugins
    # If you want only one instance of your job queued consecutively at a time,
    # extend it with this module.
    #
    # For example:
    #
    # require 'resque/plugins/dry'
    #
    # class UpdateNetworkGraph
    #   extend Resque::Plugins::DRY
    #
    #   def self.perform(repo_id)
    #     heavy_lifting
    #   end
    # end
    #
    # No other UpdateNetworkGraph jobs will be placed consecutively on the queue,
    # this plugin will check Redis to see if any others are queued
    # with the same arguments before queueing. If so, the enqueue will be aborted.
    #
    module DRY
      def stringify_args(values)
        values.map do |v|
          case v
          when Array
            stringify_args v
          when Hash
            v.inject({}) do |hash, pair|
              hash.merge! Hash[pair.first.to_s, pair.second]
            end
          else
            v.to_s
          end
        end
      end
      
      def before_enqueue_check_for_last_job_duplicates(*args)
        queue_size = Resque.size(@queue) or 0
        
        # Return if nothing in queue
        return if queue_size.zero?
        
        i = 0
        while i <= queue_size
          i += 1
          # Pick last job from current queue
          last_job = Resque.peek @queue, queue_size - i
          
          # Skip job if it belongs to other class
          next unless self.name == last_job['class']
          
          # Convert symbols to strings to match arguments returned from Resque#peek
          args = stringify_args args
          
          # Skip the job when arguments are equal
          return false if args == last_job['args']
          
          # Ready to go!
          break
        end
      end
    end
  end
end