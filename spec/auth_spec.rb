require 'spec_helper'

describe WordstreamClient::Auth do

  let(:config) { WordstreamClient.config }
  let(:auth)   { WordstreamClient::Auth }

  describe 'clear session' do

    before do
      config.set_session '123xyz'
    end

    it 'sets session_id to nil' do
      auth.clear_session
      WordstreamClient.config.session_id.should be_nil
    end

  end

  describe 'login' do

    describe 'with invalid credentials' do

      use_vcr_cassette 'auth/login/invalid_creds', :record => :none

      it 'raises login error' do
        set_config 'bad_username', 'bad_password'
        expect { login }.should raise_error(WordstreamClient::AuthError, /Invalid username or password/)
      end

    end

    describe 'with valid credentials' do

      before { set_config 'user@example.com', 'password' }

      context 'bad json response' do

        use_vcr_cassette 'auth/login/valid_creds/bad_json', :record => :none

        it 'raises login error' do
          expect { login }.should raise_error(WordstreamClient::AuthError, /Bad response from Wordstream when trying to login/)
        end

      end

      context 'no session id passed back' do

        use_vcr_cassette 'auth/login/valid_creds/no_session_id', :record => :none

        it 'raises login error' do
          expect { login }.should raise_error(WordstreamClient::AuthError, /Failed to get a session id from Wordstream/)
        end

      end

      context 'session id given' do

        use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

        it 'returns hash from json response' do
          response = login
          response.should be_an_instance_of(Hash)
        end

        it 'sets session id on config class' do
          login
          WordstreamClient.config.session_id.should_not be_nil
        end

      end

    end

  end

  describe 'logout' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before do
      set_config 'user@example.com', 'password'
      login
    end

    context 'successfully' do

      use_vcr_cassette 'auth/logout/successfully/valid', :record => :none

      it 'clears config session_id' do
        logout
        WordstreamClient.config.session_id.should be_nil
      end

      it 'returns hash from json response' do
        response = logout
        response.should be_an_instance_of(Hash)
      end

    end

    context 'unsuccessfully' do

      describe 'with invalid session' do

        use_vcr_cassette 'auth/logout/unsuccessfully/invalid_session', :record => :none

        it 'raises auth error' do
          expect { logout }.should raise_error(WordstreamClient::AuthError, /invalid session/i)
        end

        it 'clears session id' do
          expect { logout }.should raise_error
          WordstreamClient.config.session_id.should be_nil
        end

      end

      describe 'with invalid response' do

        use_vcr_cassette 'auth/logout/unsuccessfully/invalid_response', :record => :none

        it 'raises auth error' do
          expect { logout }.should raise_error(WordstreamClient::AuthError, /bad response from wordstream when trying to logout/i)
        end

        it 'clears session id' do
          expect { logout }.should raise_error
          WordstreamClient.config.session_id.should be_nil
        end

      end

    end

  end

  describe 'get_api_credits' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before do
      set_config 'user@example.com', 'password'
      login
    end

    context 'successfully' do

      use_vcr_cassette 'auth/get_api_credits/successfully/valid', :record => :none

      before { @response = WordstreamClient::Auth.get_api_credits }

      it 'returns hash from json response' do
        @response.should be_an_instance_of(Hash)
      end

      it 'returns remaining credits' do
        @response['data']['remaining_monthly_credits'].should eql 19429
      end

      it 'returns monthly credit allowance' do
        @response['data']['credits_per_month'].should eql 20000
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'auth/get_api_credits/unsuccessfully/with_error', :record => :none

        it 'raises auth error' do
          expect { WordstreamClient::Auth.get_api_credits }.should raise_error(WordstreamClient::AuthError, /wordstream error detail/i)
        end

      end

      describe 'with bad response' do

        use_vcr_cassette 'auth/get_api_credits/unsuccessfully/bad_response', :record => :none

        it 'raises auth error' do
          expect { WordstreamClient::Auth.get_api_credits }.should raise_error(WordstreamClient::AuthError, /bad response from wordstream when trying to get api credits/i)
        end

      end

    end

  end

end
