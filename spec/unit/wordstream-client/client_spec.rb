require 'spec_helper'

describe WordstreamClient::Client do

  let(:config) { WordstreamClient::Config.new }
  let(:client) { WordstreamClient::Client.new(config) }

  describe 'initialize' do

    context 'with options hash' do

      let(:client) { WordstreamClient::Client.new(password: 'password', username: 'username') }

      it 'returns new client instance' do
        client.should be_an_instance_of(WordstreamClient::Client)
      end

      it 'sets config attr' do
        client.config.should be_an_instance_of(WordstreamClient::Config)
      end

    end

    context 'with config object' do

      it 'returns new client instance' do
        client.should be_an_instance_of(WordstreamClient::Client)
      end

      it 'sets config attr' do
        client.config.should be_an_instance_of(WordstreamClient::Config)
      end

    end

    context 'with bad config' do

      it 'raises argument error' do
        expect { WordstreamClient::Client.new(true) }.should raise_error(ArgumentError, /invalid configuration for client/)
      end

    end

  end

  describe 'auth' do

    it 'returns new auth instance' do
      client.auth.should be_an_instance_of(WordstreamClient::Auth)
    end

  end

  describe 'keyword tool' do

    it 'returns new auth instance' do
      client.keyword_tool([]).should be_an_instance_of(WordstreamClient::KeywordTool)
    end

  end

end
