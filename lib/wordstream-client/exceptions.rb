module WordstreamClient

  class WordstreamClientError < ::StandardError; end

  class AuthError < WordstreamClientError

    def initialize(method, message) # :nodoc:
      super "WordstreamClient::Auth.#{method} - #{message}"
    end

  end

  class KeywordToolError < WordstreamClientError

    def initialize(method, message) # :nodoc:
      super "WordstreamClient::KeywordTool.#{method} - #{message}"
    end

  end
  

end