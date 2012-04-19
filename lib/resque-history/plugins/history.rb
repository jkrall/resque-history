module Resque
  module Plugins
    module History

      MAX_HISTORY_SIZE = 500
      HISTORY_SET_NAME = "resque_history"

      def maximum_history_size
        @max_history ||= MAX_HISTORY_SIZE
      end

      def after_perform_history(*args)
        Resque.redis.lpush(HISTORY_SET_NAME, {"class"=>"#{self}",
                                              "args"=>args,
                                              "time"=>Time.now.strftime("%Y-%m-%d %H:%M")
        }.to_json)

        Resque.redis.ltrim(HISTORY_SET_NAME, 0, maximum_history_size)
      end

    end
  end
end