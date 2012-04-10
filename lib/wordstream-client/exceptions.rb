module WordstreamClient

  class WordstreamClientError < ::StandardError; end

  class AuthError < WordstreamClientError

    def initialize(message) # :nodoc:
      super "WordstreamClient::Auth.login - #{message}"
    end

  end

end