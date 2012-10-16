module WordstreamClient

  ##
  #
  # Class used to log in and out of the Wordstream API
  # and manage your API session.

  class Auth

    ##
    #
    # @return [WordstreamClient::Config]

    def self.config
      WordstreamClient.config
    end

    ##
    #
    # Used to clear session_id on {WordstreamClient::Config}
    # @note You will need to log in to get a new session_id to make any API calls

    def self.clear_session
      config.clear_session!
    end

    ##
    #
    # login Wordstream API call.
    #
    # @return  [Hash] Hash response for logging in.
    # @raise   [AuthError] If error is returned in response body from Wordstream.
    # @raise   [AuthError] If bad JSON response from Wordstream.
    # @raise   [AuthError] If no session_id returned
    # @example Example response
    #     {"code": "OK", "data": {"session_id": "user@example.com:asdf1234jkl9876"}, "user": "user@example.com"}
    # @note Sets session_id on {WordstreamClient::Config}

    def self.login
      path  = '/authentication/login'
      query = "?username=#{config.username}&password=#{config.password}"
      resp  = RestClient.get(config.host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('login', data['error']) if data.has_key?('error')

      session_id         = data['data']['session_id'] if data.has_key?('data')
      config.set_session(session_id) unless session_id.nil? or session_id.empty?

      raise AuthError.new('login', 'Failed to get a session id from Wordstream.') if config.session_id.nil?

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('login', 'Bad response from Wordstream when trying to login.')
    end

    ##
    #
    # logout Wordstream API call.
    #
    # @return  [Hash] Hash response for logging out.
    # @raise   [AuthError] If error is returned in response body from Wordstream.
    # @raise   [AuthError] If bad JSON response from Wordstream.
    # @example Example response
    #     { "code" : "OK" }
    # @note Clears out session_id on {WordstreamClient::Config}

    def self.logout
      path  = '/authentication/logout'
      query = "?session_id=#{config.session_id}"
      resp  = RestClient.get(config.host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('logout', data['error']) if data.has_key?('error')

      clear_session

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('logout', 'Bad response from Wordstream when trying to logout.')
    ensure
      clear_session
    end

    ##
    #
    # get_api_credits Wordstream API call.
    #
    # @return  [Hash] Hash of account credit information.
    # @raise   [AuthError] If error is returned in response body from Wordstream.
    # @raise   [AuthError] If bad JSON response from Wordstream.
    # @example Example response
    #     { "remaining_monthly_credits" => 19, "credits_per_month" => 20 }

    def self.get_api_credits
      path  = '/authentication/get_api_credits'
      query = "?session_id=#{config.session_id}"
      resp  = RestClient.get(config.host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('get_api_credits', data['detail']) if data['code'].match(/error/i)

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('get_api_credits', 'Bad response from Wordstream when trying to get api credits.')
    end

  end

end
