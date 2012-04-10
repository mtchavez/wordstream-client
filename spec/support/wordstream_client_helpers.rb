module WordstreamClientHelpers

  def set_config(username='user@example.com', password='password')
    WordstreamClient::Config.username = username
    WordstreamClient::Config.password = password
  end

  def login
    WordstreamClient::Auth.login
  end

end
