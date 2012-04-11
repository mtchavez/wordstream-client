module WordstreamClient

  class Auth

    def initialize(config)
      @config = config
    end

    def self.login
      Config.client.auth.login
    end

    def login
      path  = '/authentication/login'
      query = "?username=#{@config.username}&password=#{@config.password}"
      resp  = RestClient.get(@config.default_host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('login', data['error']) if data.has_key?('error')

      session_id         = data['data']['session_id'] if data.has_key?('data')
      Config.session_id  = session_id
      @config.session_id = session_id

      raise AuthError.new('login', 'Failed to get a session id from Wordstream.') if @config.session_id.nil?

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('login', 'Bad response from Wordstream when trying to login.')
    end

    def self.logout
      Config.client.auth.logout
    end

    def logout
      path  = '/authentication/logout'
      query = "?session_id=#{@config.session_id}"
      resp  = RestClient.get(@config.default_host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('logout', data['error']) if data.has_key?('error')

      Config.session_id  = nil
      @config.session_id = nil

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('logout', 'Bad response from Wordstream when trying to logout.')
    end

    def self.get_api_credits
      Config.client.auth.get_api_credits
    end

    def get_api_credits
      path  = '/authentication/get_api_credits'
      query = "?session_id=#{@config.session_id}"
      resp  = RestClient.get(@config.default_host + path + query)
      data  = JSON.parse resp.body

      raise AuthError.new('get_api_credits', data['error']) if data.has_key?('error')

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('get_api_credits', 'Bad response from Wordstream when trying to get api credits.')
    end

  end

end
