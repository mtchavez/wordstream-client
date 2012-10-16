require 'spec_helper'

describe WordstreamClient do

  describe 'configure' do

    it 'can set configuration using a block' do
      WordstreamClient.configure do |config|
        config.username = 'username'
        config.password = 'password'
      end
      WordstreamClient.config.username.should eql 'username'
      WordstreamClient.config.password.should eql 'password'
    end

  end

  describe 'config' do

    it 'can be accessed' do
      WordstreamClient.config.should be_an_instance_of(WordstreamClient::Config)
    end

    it 'can set new options' do
      WordstreamClient.config.username = 'new-username'
      WordstreamClient.config.username.should eql 'new-username'
    end

  end

end
