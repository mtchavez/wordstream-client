require 'spec_helper'

describe WordstreamClient::Config do

  describe 'class attrs' do

    before { set_config nil, nil }

    it 'can set password' do
      WordstreamClient::Config.password.should be_nil
      WordstreamClient::Config.password = 'password'
      WordstreamClient::Config.password.should eql 'password'
    end

    it 'can set username' do
      WordstreamClient::Config.username.should be_nil
      WordstreamClient::Config.username = 'username'
      WordstreamClient::Config.username.should eql 'username'
    end

  end

  describe 'instantiate' do

    let(:config) { WordstreamClient::Config.instantiate }

    before { set_config nil, nil }

    it 'returns config instance' do
      config.should be_an_instance_of(WordstreamClient::Config)
    end

    context 'without username or password or session' do

      it 'does not set username on instance' do
        config.instance_variable_get('@username').should be_nil
      end

      it 'does not set password on instance' do
        config.instance_variable_get('@password').should be_nil
      end

      it 'does not set session id on instance' do
        WordstreamClient::Config.session_id = nil
        config.instance_variable_get('@session_id').should be_nil
      end

    end

    context 'with username and password and session' do

      before { set_config }

      it 'sets username on instance' do
        config.instance_variable_get('@username').should_not be_nil
      end

      it 'sets password on instance' do
        config.instance_variable_get('@password').should_not be_nil
      end

      it 'sets session id on instance' do
        WordstreamClient::Config.session_id = '123'
        config.instance_variable_get('@session_id').should_not be_nil
      end

    end

  end

  describe 'initialize' do

    it 'does not set variables other than password or username' do
      config = WordstreamClient::Config.new(awesome_attr: 'Super Happy Fun Time')
      config.instance_variable_get('@awesome_attr').should be_nil
    end

  end

end
