module WordstreamClient

  class Client

    attr_reader :config

    def initialize(config)
      @config = if config.is_a?(Hash)
        Config.new(config)
      elsif config.is_a?(WordstreamClient::Config)
        config
      else
        raise ArgumentError, 'invalid configuration for client.'
      end
    end

    def auth
      Auth.new @config
    end

  end

end
