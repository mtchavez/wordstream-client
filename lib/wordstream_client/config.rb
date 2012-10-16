module WordstreamClient

  ##
  #
  # Config class used internally for API calls

  class Config

    DEFAULT_HOST = 'http://api.wordstream.com'
    DEFAULT_PORT = 80 # @private

    attr_accessor :username, :password
    attr_reader   :host, :port, :session_id # @private

    ##
    #
    # @private

    def initialize
      @host = DEFAULT_HOST
      @port = DEFAULT_PORT
    end

    ##
    #
    # @private

    def set_session(session)
      @session_id = session
    end

    ##
    #
    # @private

    def clear_session!
      @session_id = nil
    end

  end

end
