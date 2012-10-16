module WordstreamClient

  ##
  #
  # API calls for the Wordstream Keyword Tool endpoint.

  class KeywordTool

    ##
    #
    # @return [WordstreamClient::Config]

    def self.config
      WordstreamClient.config
    end

    ##
    #
    # Setup keywords for API calls.
    #
    # @param terms [Array[String], String] - Defaults to an empty array. Can be an array of keywords or a string of keywords separated by newline "\\n"
    # @return      [Array] of keyword terms

    def self.setup_keywords(terms = [])
      keywords = terms.is_a?(Array) ? terms.join("\n") : terms.to_s
      # Apache Web Server URL limit is 4000 characters
      # The API is horrible and passes ALL the keywords
      # In the URL string
      keywords[0..3949]
    end

    ##
    #
    # get_keyword_volumes Wordstream API call. Takes list of keywords and returns
    # an array of arrays of keywords and their volumes.
    #
    # @param terms [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return  [Array] Array of arrays of keywords and their volumes.
    # @raise   [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise   [KeywordToolError] If bad JSON response from Wordstream.
    # @example Example response
    #     [ ['running', 123], ['apple', 77], ['ipod', 34] ]

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

    ##
    #
    # get_niches Wordstream API call. Takes list of keywords and returns
    # a set of keyword niche groups and their associated keywords.
    #
    # @param terms       [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param max         [Integer] _Optional_ - The max number of niches returned. Maxed at 2500 niches from Wordstream.
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return  [Hash] Hash of results from JSON response.
    # @raise   [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise   [KeywordToolError] If bad JSON response from Wordstream.
    # @example Example response where keyword_index refers to the array position in the 'keywords' array of arrays.
    #     {
    #       'total': number_of_suggestions,
    #       'groupings': [
    #         {
    #           'title': display_label, 
    #           'score': score, 
    #           'wordlist': [query_word, ... , query_word], 
    #           'matches': [keyword_index, ... , keyword_index]
    #         }
    #       ], 
    #       'keywords': [ [keyword, relative_volume], ... , [keyword, relative_volume] ]
    #     }

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

    ##
    #
    # get_keywords Wordstream API call. Takes list of keywords and returns
    # an array of suggested keywords.
    #
    # @param terms       [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param max         [Integer] _Optional_ - The max number of keywords returned. Maxed at 100,000 keywords from Wordstream.
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return  [Array] Array of arrays of keyword / volume pairs.
    # @raise   [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise   [KeywordToolError] If bad JSON response from Wordstream.
    # @example Example response.
    #     [ ["apple", 196], ["ipad 2 cases", 95], ["apple stock", 75], ["apple cider vinegar", 72], ["apple store", 69],
    #       ["apple computers",69], ["apple juice", 68] ]

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

    ##
    #
    # get_question_keywords Wordstream API call. Takes list of keywords and returns
    # an array of suggested questions.
    #
    # @param terms       [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param max         [Integer] _Optional_ - The max number of questions returned. Maxed at 100,000 questions from Wordstream.
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return  [Array] Array of questions.
    # @raise   [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise   [KeywordToolError] If bad JSON response from Wordstream.
    # @example Example response.
    #     [ ["what is in apple juice", 38], ["how to can apple juice", 20], ["can apple juice", 20],
    #       ["why buy apple stock", 13], ["where to buy apple stock", 13], ["what s in apple juice", 13],
    #       ["what is apple juice concentrate", 13], ["how do i buy apple stock", 13] ]

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

    ##
    #
    # get_related_keywords Wordstream API call. Takes list of keywords and returns
    # an array of related keywords.
    #
    # @param terms       [String, Array[String]] *Required* - Array of keywords or string of keywords separated by newline "\\n"
    # @param max         [Integer] _Optional_ - The max number of keywords returned. Maxed at 100 keywords from Wordstream.
    # @param block_adult [String] _Optional_ - Defaults to 'false'. Set to 'true' if you want to block adult results.
    #
    # @return  [Array] Array of related keywords.
    # @raise   [KeywordToolError] If error is returned in response body from Wordstream.
    # @raise   [KeywordToolError] If bad JSON response from Wordstream.
    # @example Example response.
    #     ["mac os x", "learn and earn", "all around my", "store for education", "the crazy ones" ]

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
