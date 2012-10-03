module WordstreamClient

  class WordstreamClientError < ::StandardError; end

  class AuthError < WordstreamClientError

    # Initialize new AuthError
    # @private

    def initialize(method, message)
      super "WordstreamClient::Auth.#{method} - #{message}"
    end

  end

  class KeywordToolError < WordstreamClientError

    # Initialize new KeywordToolError
    # @private

    def initialize(method, message) # :nodoc:
      super "WordstreamClient::KeywordTool.#{method} - #{message}"
    end

  end
  

end