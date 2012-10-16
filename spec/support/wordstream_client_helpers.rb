module WordstreamClientHelpers

  def set_config(username='user@example.com', password='password')
    WordstreamClient.configure do |config|
      config.username = username
      config.password = password
    end
  end

  def login
    WordstreamClient::Auth.login
  end

  def logout
    WordstreamClient::Auth.logout
  end

end
