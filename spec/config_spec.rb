require 'spec_helper'

describe WordstreamClient::Config do

  it 'can set session id' do
    WordstreamClient.config.set_session('my-session-id')
    WordstreamClient.config.session_id.should eql 'my-session-id'
  end

  it 'sets defaults when initialized' do
    config = WordstreamClient.config
    config.host.should eql WordstreamClient::Config::DEFAULT_HOST
    config.port.should eql WordstreamClient::Config::DEFAULT_PORT
  end

end
