require 'json'
require 'rest-client'
require 'net/http'

require File.dirname(__FILE__) + '/wordstream_client/auth'
require File.dirname(__FILE__) + '/wordstream_client/config'
require File.dirname(__FILE__) + '/wordstream_client/exceptions'
require File.dirname(__FILE__) + '/wordstream_client/keyword_tool'

module WordstreamClient

  extend self

  ##
  #
  # Takes a block where you can configure your API calls with your username and password
  # @example Sample Configuration
  #     WordstreamClient.configure do |config|
  #       config.username = 'my.username@example.com'
  #       config.password = 'my-secret-password'
  #     end

  def configure
    yield config
  end

  ##
  #
  # Used to access your current configuration for API calls.
  # @return [WordstreamClient::Config] Config object with your current settings

  def config
    @config ||= Config.new
  end

end
