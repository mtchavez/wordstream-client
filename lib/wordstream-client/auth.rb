module WordstreamClient

  class Auth

    def initialize(config)
      @config = config
    end

    def self.login
      Config.client.auth.login
    end

    def login
      login_path = '/authentication/login'
      query      = "?username=#{@config.username}&password=#{@config.password}&callback=response"
      resp       = RestClient.get(@config.default_host + login_path + query)
      body_match = resp.body.match(/response\((.*)\)/i)
      real_body  = body_match.nil? ? '' : body_match[1]
      data       = JSON.parse real_body

      raise AuthError.new(data['error']) if data.has_key?('error')

      session_id         = data['data']['session_id'] if data.has_key?('data')
      Config.session_id  = session_id
      @config.session_id = session_id

      raise AuthError.new('Failed to get a session id from Wordstream.') if @config.session_id.nil?

      return data
    rescue JSON::ParserError => e
      raise AuthError.new('Bad response from Wordstream when trying to log in.')
    end

  end

end
