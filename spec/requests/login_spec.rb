require 'spec_helper'

describe 'Wordstream Login' do

  describe 'with invalid credentials' do

    use_vcr_cassette 'login/invalid_creds', :record => :none

    it 'raises login error' do
      set_config 'bad_username', 'bad_password'
      expect { login }.should raise_error(WordstreamClient::AuthError, /Invalid username or password/)
    end

  end

  describe 'with valid credentials' do

    before { set_config 'user@example.com', 'password' }

    context 'bad json response' do

      use_vcr_cassette 'login/valid_creds/bad_json', :record => :none

      it 'raises login error' do
        expect { login }.should raise_error(WordstreamClient::AuthError, /Bad response from Wordstream when trying to login/)
      end

    end

    context 'no session id passed back' do

      use_vcr_cassette 'login/valid_creds/no_session_id', :record => :none

      it 'raises login error' do
        expect { login }.should raise_error(WordstreamClient::AuthError, /Failed to get a session id from Wordstream/)
      end

    end

    context 'session id given' do

      use_vcr_cassette 'login/valid_creds/with_session_id', :record => :none

      it 'returns hash from json response' do
        response = login
        response.should be_an_instance_of(Hash)
      end

      it 'sets session id on config class' do
        login
        WordstreamClient::Config.session_id.should_not be_nil
      end

    end

  end

end
