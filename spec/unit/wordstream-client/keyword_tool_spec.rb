require 'spec_helper'

describe WordstreamClient::KeywordTool do

  let(:config)   { WordstreamClient::Config.new }
  let(:keywords) { ['apple', 'ipad', 'macbook pro']  }

  describe 'initialize' do

    it 'sets config' do
      kt = WordstreamClient::KeywordTool.new(config)
      kt.instance_variable_get("@config").should be_an_instance_of(WordstreamClient::Config)
    end

    it 'takes array of keywords and makes newline separated string' do
      kt = WordstreamClient::KeywordTool.new(config, ['one','two','three'])
      kt.keywords.should be_an_instance_of(String)
      kt.keywords.should eql "one\ntwo\nthree"
    end

    it 'takes a string of keywords and sets ivar' do
      keywords = "my fancy keyword\nwith another keyword"
      kt = WordstreamClient::KeywordTool.new(config, keywords)
      kt.keywords.should be_an_instance_of(String)
      kt.keywords.should eql keywords
    end

    it 'sets max keyword length to 3950' do
      keywords = []
      1.upto(4000) { |i| keywords << "keyword #{i}"}
      kt = WordstreamClient::KeywordTool.new(config, keywords)
      kt.keywords.length.should eql 3950
    end

  end

  describe 'get_volumes' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before { set_config and login }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/volumes/successfully/valid', :record => :none

      it 'returns keyword volumes' do
        results = WordstreamClient::KeywordTool.get_volumes(keywords)
        results.should be_an_instance_of(Array)
        results.should eql [ ['apple', 196], ['macbook pro', 23] ]
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'keyword_tool/volumes/unsuccessfully/with_error', :record => :none

        it 'raises keyword tool error with error message' do
          expect { WordstreamClient::KeywordTool.get_volumes(keywords) }.should raise_error(WordstreamClient::KeywordToolError, /session id is invalid/i)
        end

      end

      describe 'with bad json' do

        use_vcr_cassette 'keyword_tool/volumes/unsuccessfully/bad_json', :record => :none

        it 'raises keyword tool error' do
          expect { WordstreamClient::KeywordTool.get_volumes(keywords) }.should raise_error(WordstreamClient::KeywordToolError, /bad response from wordstream/i)
        end

      end

    end

  end

  describe 'get_niches' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before do
      set_config 'user@example.com', 'password'
      login
    end

    context 'successfully' do
      
    end

    context 'unsuccessfully' do
      
    end

  end

  describe 'get_suggestions' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before do
      set_config 'user@example.com', 'password'
      login
    end

    context 'successfully' do
      
    end

    context 'unsuccessfully' do
      
    end

  end

  describe 'get_related' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before do
      set_config 'user@example.com', 'password'
      login
    end

    context 'successfully' do
      
    end

    context 'unsuccessfully' do
      
    end

  end

end
