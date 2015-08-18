require "rsync"

module Rack
  class Rsync
    attr_reader :source, :destination, :options

    def initialize(app, source, destination, *options, &condition)
      @app         = app
      @source      = source
      @destination = destination
      @options     = [*options]
      @condition   = condition
    end

    def call(env)
      res = @app.call(env)
      sync if should_run?(env)
      res
    end

    private

    def should_run?(env)
      @condition.call(env)
    end

    def sync
      ::Rsync.run(
        source,
        destination,
        options
      )
    end
  end
end
