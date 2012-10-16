module WordstreamClient

  class KeywordTool

    def self.config
      WordstreamClient.config
    end

    ##
    #
    # Setup keywords for API calls.
    #
    # @param terms [Array[String], String] - Defaults to an empty array. Can be an array of keywords or a string of keywords separated by newline "\\n"
    # @return       [Array] of keyword terms

    def self.setup_keywords(terms = [])
      keywords = terms.is_a?(Array) ? terms.join("\n") : terms.to_s
      # Apache Web Server URL limit is 4000 characters
      # The API is horrible and passes ALL the keywords
      # In the URL string
      keywords[0..3949]
    end

    ##
    # == Description
    #
    # get_keyword_volumes Wordstream API call. Takes list of keywords and returns
    # an array of arrays of keywords and their volumes.
    #
    # == Params
    #
    # @param terms [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return       [Array] Array of arrays of keywords and their volumes.
    # @raise        [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise        [KeywordToolError] If bad JSON response from Wordstream.

    def self.get_volumes(terms, block_adult = 'false')
      keywords     = setup_keywords(terms)
      path         = '/keywordtool/get_keyword_volumes'
      url_keywords = URI.encode( keywords, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{config.session_id}&keywords=#{url_keywords}&block_adult=#{block_adult}"
      resp         = RestClient.post( config.host + path + query, {} )
      data         = JSON.parse resp.body

      raise KeywordToolError.new('get_volumes', data['detail']) if data['code'].match(/error/i)

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_volumes', 'Bad response from Wordstream when trying to get keyword volumes.')
    end

    def self.get_niches(terms, max = 2500, block_adult = 'false')
      keywords     = setup_keywords(terms)
      max          = max.abs > 2500 ? 2500 : max.abs
      path         = '/keywordtool/get_keyword_niches'
      url_keywords = URI.encode( keywords, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{config.session_id}&seeds=#{url_keywords}&block_adult=#{block_adult}&max_niches=#{max}"
      resp         = RestClient.get( config.host + path + query )
      data         = JSON.parse resp.body

      # TODO: Handle Error Code
      # "{\"code\": \"ERROR\", \"detail\": \"No keywords provided!!!\"}"
      raise KeywordToolError.new('get_niches', data['detail']) if data['code'].match(/error/i)

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_niches', 'Bad response from Wordstream when trying to get keyword niches.')
    end

    def self.get_suggestions(terms, max = 100000, block_adult = 'false')
      keywords     = setup_keywords(terms)
      max          = max.abs > 100000 ? 100000 : max.abs
      path         = '/keywordtool/get_keywords'
      url_keywords = URI.encode( keywords[0..19], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{config.session_id}&seeds=#{url_keywords}&block_adult=#{block_adult}&max_niches=#{max}"
      resp         = RestClient.get( config.host + path + query )
      data         = JSON.parse resp.body

      raise KeywordToolError.new('get_suggestions', data['detail']) if data['code'].match(/error/i)

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_suggestions', 'Bad response from Wordstream when trying to get keyword suggestions.')
    end

    def self.get_questions(terms, max = 100000, block_adult = 'false')
      keywords     = setup_keywords(terms)
      max          = max.abs > 100000 ? 100000 : max.abs
      path         = '/keywordtool/get_question_keywords'
      url_keywords = URI.encode( keywords[0..19], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{config.session_id}&seeds=#{url_keywords}&block_adult=#{block_adult}&max_niches=#{max}"
      resp         = RestClient.get( config.host + path + query )
      data         = JSON.parse resp.body

      raise KeywordToolError.new('get_questions', data['detail']) if data['code'].match(/error/i)

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_questions', 'Bad response from Wordstream when trying to get keyword questions.')
    end

    def self.get_related(terms, max = 100, block_adult = 'false')
      keywords     = setup_keywords(terms)
      max          = max.abs > 100 ? 100 : max.abs
      path         = '/keywordtool/get_related_keywords'
      url_keywords = URI.encode( keywords[0..19], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
      query        = "?session_id=#{config.session_id}&seeds=#{url_keywords}&block_adult=#{block_adult}&max_niches=#{max}"
      resp         = RestClient.get( config.host + path + query )
      data         = JSON.parse resp.body

      raise KeywordToolError.new('get_related', data['detail']) if data['code'].match(/error/i)

      return data['data']
    rescue JSON::ParserError => e
      raise KeywordToolError.new('get_related', 'Bad response from Wordstream when trying to get related keyword.')
    end

  end

end
