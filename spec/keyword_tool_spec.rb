require 'spec_helper'

describe WordstreamClient::KeywordTool do

  let(:config)   { WordstreamClient.config }
  let(:keywords) { ['apple', 'ipad', 'macbook pro']  }

  describe 'setup keywords' do

    it 'takes array of keywords and makes newline separated string' do
      keywords = WordstreamClient::KeywordTool.setup_keywords(['one','two','three'])
      keywords.should be_an_instance_of(String)
      keywords.should eql "one\ntwo\nthree"
    end

    it 'takes a string of keywords and sets ivar' do
      terms = "my fancy keyword\nwith another keyword"
      keywords = WordstreamClient::KeywordTool.setup_keywords(terms)
      keywords.should be_an_instance_of(String)
      keywords.should eql keywords
    end

    it 'sets max keyword length to 3950' do
      terms = []
      1.upto(4000) { |i| terms << "keyword #{i}"}
      keywords = WordstreamClient::KeywordTool.setup_keywords(terms)
      keywords.length.should eql 3950
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

    before { set_config and login }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/niches/successfully/valid', :record => :none

      it 'returns keyword niches' do
        results = WordstreamClient::KeywordTool.get_niches(keywords, 5)
        results.should be_an_instance_of(Hash)
        results['keywords'].should be_an_instance_of(Array)
        results['total'].should eql 5
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'keyword_tool/niches/unsuccessfully/with_error', :record => :none

        it 'raises keyword tool error with error message' do
          expect { WordstreamClient::KeywordTool.get_niches(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /session id is invalid/i)
        end

      end

      describe 'with bad json' do

        use_vcr_cassette 'keyword_tool/niches/unsuccessfully/bad_json', :record => :none

        it 'raises keyword tool error' do
          expect { WordstreamClient::KeywordTool.get_niches(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /bad response from wordstream/i)
        end

      end

    end

  end

  describe 'get_suggestions' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before { set_config and login }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/suggestions/successfully/valid', :record => :none

      it 'returns keyword niches' do
        results = WordstreamClient::KeywordTool.get_suggestions(keywords, 5)
        results.should be_an_instance_of(Array)
        results.length.should eql 100
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'keyword_tool/suggestions/unsuccessfully/with_error', :record => :none

        it 'raises keyword tool error with error message' do
          expect { WordstreamClient::KeywordTool.get_suggestions(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /session id is invalid/i)
        end

      end

      describe 'with bad json' do

        use_vcr_cassette 'keyword_tool/suggestions/unsuccessfully/bad_json', :record => :none

        it 'raises keyword tool error' do
          expect { WordstreamClient::KeywordTool.get_suggestions(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /bad response from wordstream/i)
        end

      end

    end

  end

  describe 'get_questions' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before { set_config and login }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/questions/successfully/valid', :record => :none

      it 'returns keyword niches' do
        results = WordstreamClient::KeywordTool.get_questions(keywords, 5)
        results.should be_an_instance_of(Array)
        results.length.should eql 100
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'keyword_tool/questions/unsuccessfully/with_error', :record => :none

        it 'raises keyword tool error with error message' do
          expect { WordstreamClient::KeywordTool.get_questions(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /session id is invalid/i)
        end

      end

      describe 'with bad json' do

        use_vcr_cassette 'keyword_tool/questions/unsuccessfully/bad_json', :record => :none

        it 'raises keyword tool error' do
          expect { WordstreamClient::KeywordTool.get_questions(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /bad response from wordstream/i)
        end

      end

    end

  end

  describe 'get_related' do

    use_vcr_cassette 'auth/login/valid_creds/with_session_id', :record => :none

    before { set_config and login }

    context 'successfully' do

      use_vcr_cassette 'keyword_tool/related/successfully/valid', :record => :none

      it 'returns keyword niches' do
        results = WordstreamClient::KeywordTool.get_related(keywords, 5)
        results.should be_an_instance_of(Array)
        results.length.should eql 100
      end

    end

    context 'unsuccessfully' do

      describe 'with error' do

        use_vcr_cassette 'keyword_tool/related/unsuccessfully/with_error', :record => :none

        it 'raises keyword tool error with error message' do
          expect { WordstreamClient::KeywordTool.get_related(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /session id is invalid/i)
        end

      end

      describe 'with bad json' do

        use_vcr_cassette 'keyword_tool/related/unsuccessfully/bad_json', :record => :none

        it 'raises keyword tool error' do
          expect { WordstreamClient::KeywordTool.get_related(keywords, 5) }.should raise_error(WordstreamClient::KeywordToolError, /bad response from wordstream/i)
        end

      end

    end

  end

end
