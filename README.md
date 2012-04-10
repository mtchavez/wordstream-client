require 'wordstream-client'
WordstreamClient::Config.username = 'username'
WordstreamClient::Config.password = 'password'
WordstreamClient::Auth.login

WordstreamClient::Auth.logout
WordstreamClient::Auth.get_credits

WordstreamClient::KeywordTool.get_volumes([])
WordstreamClient::KeywordTool.get_niches([])
WordstreamClient::KeywordTool.get_suggestions([])
