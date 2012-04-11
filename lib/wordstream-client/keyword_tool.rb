module WordstreamClient

  class KeywordTool

    attr_accessor :keywords

    def initialize(config, keywords)
      @config   = config
      @keywords = keywords.is_a?(Array) ? keywords.join("\n") : keywords.to_s
      # Apache Web Server URL limit is 4000 characters
      # The API is horrible and passes ALL the keywords
      # In the URL string
      @keywords = @keywords[0..3950]
    end

    def self.get_volumes(keywords, block_adult = 'false')
      Config.client.keyword_tool(keywords).get_volumes(block_adult)
    end

    def get_volumes(block_adult = 'false')
      path         = '/keywordtool/get_keyword_volumes'
      url_keywords = URI.encode( @keywords, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{@config.session_id}&keywords=#{url_keywords}&block_adult=#{block_adult}"
      resp         = RestClient.get( @config.default_host + path + query )
      data         = JSON.parse resp.body

      raise KeywordToolError.new('get_volumes', data['error']) if data.has_key?('error')

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_volumes', 'Bad response from Wordstream when trying to get keyword volumes.')
    end

  end

end
