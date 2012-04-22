module WordstreamClient

  class Config

    class << self
      attr_accessor :username, :password, :session_id
    end

    def self.instantiate # :nodoc:
      new( username: username, password: password, session_id: session_id )
    end

    def self.client
      Client.new instantiate
    end

    def initialize(options = {})
      [:username, :password, :session_id].each do |var| 
        instance_variable_set "@#{var}", options[var]
      end
    end

    def username
      @username
    end

    def password
      @password
    end

    def session_id
      @session_id
    end

    def session_id=(new_session)
      # return false if new_session.to_s.empty?
      instance_variable_set "@session_id", new_session
      self.class.session_id = new_session
    end

    def default_host
      'http://api.wordstream.com'
    end

  end

end
