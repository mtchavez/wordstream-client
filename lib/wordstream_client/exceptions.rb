module WordstreamClient

  ##
  #
  # Generic WordstreamClientError, inherits form StandardError

  class WordstreamClientError < ::StandardError; end

  ##
  #
  # Raised when an error happens authenticating with Wordstream.

  class AuthError < WordstreamClientError

    # Initialize new AuthError
    # @private

    def initialize(method, message)
      super "WordstreamClient::Auth.#{method} - #{message}"
    end

  end

  ##
  #
  # Raised when an error with the Keyword Tool endpoint occurs.

  class KeywordToolError < WordstreamClientError

    # Initialize new KeywordToolError
    # @private

    def initialize(method, message) # :nodoc:
      super "WordstreamClient::KeywordTool.#{method} - #{message}"
    end

  end
  

end