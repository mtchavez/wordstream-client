# Wordstream API Gem [![Build Status](https://secure.travis-ci.org/mtchavez/wordstream-client.png)](http://travis-ci.org/mtchavez/wordstream-client?branch=master)

A wrapper around the Wordstream API calls.

* [Github](http://github.com/mtchavez/wordstream-client "Github Repo")
* [Rubygems](https://rubygems.org/gems/wordstream-client "Rubygems Page")

## Description

Wordstream API gem to wrap the API calls available. Allows you to login/logout, get your api credits, get keyword volumes,
get keyword suggestions, get keyword niches, get question keywords and get related keywords. Currently the callback parameter
is not implemented on any of the endpoints. This may change in the future if it becomes a needed feature.

## Install

    gem install wordstream_client

## Configure

  To set up the gem you need to set your Wordstream username and password before making any API requests.

    require 'wordstream_client'

    WordstreamClient.configure do |config|
      config.username = 'my.username@example.com'
      config.password = 'my-secret-password'
    end

## Authentication Endpoints

### Login

  After configuring your username and password you need to login to Wordstream to get a session_id
  in order to make API requests. This will be configured for you automatically after login.

    WordstreamClient::Auth.login

### Logout

  If you want to destroy your Wordstream session you can use the logout endpoint to do so.

    WordstreamClient::Auth.logout

### Get API Credits

  Wordstream allows you to get your monthly API credits and your monthly credits used. Use this endpoint to
  see your API credit usage.

    data = WordstreamClient::Auth.get_api_credits
    
    # Returns hash of credits
    # { "remaining_monthly_credits" => 19, "credits_per_month" => 20 }
    
    remaining = data['remaining_monthly_credits']
    total     = data['credits_per_month']

## Keyword Tool Endpoints

### Volumes

  To get keyword volumes you can pass in an array of keywords to get their volumes *relative* to each other.

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_volumes(keywords)
    
    # Returns array of arrays with keywords and their volume
    # [ ['running', 123], ['apple', 77], ['ipod', 34] ]
    
    keyword_volumes       = Hash[data]
    keywords_with_volumes = keyword_volumes.keys

### Niches

  Make sure to pass in a smaller max then the default as it will most likely timeout from Wordstream.

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_niches(keywords)
    
    # Example data response
    # keyword_index refers to the array position in the 'keywords' dict element.
    {
      'total': number_of_suggestions,
      'groupings': [
        {
          'title': display_label, 
          'score': score, 
          'wordlist': [query_word, ... , query_word], 
          'matches': [keyword_index, ... , keyword_index]
        }
      ], 
      'keywords': [ [keyword, relative_volume], ... , [keyword, relative_volume] ]
    }
    

### Suggestions

  Make sure to pass in a smaller max then the default as it will most likely timeout from Wordstream.

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_suggestions(keywords)
    
    # Example data response
    [["apple", 196], ["ipad 2 cases", 95], ["apple
     stock", 75], ["apple cider vinegar", 72], ["apple store", 69], ["apple computers",
     69], ["apple juice", 68], ["apple vacations", 60], ["apple ipod", 60], ["apple
     crisp recipe", 53], ["apple earnings", 52], ["case for ipad 2", 51], ["cases
     for the ipad 2", 48], ["valley apple", 46], ["apple laptops", 42], ["apple
     iphone", 42], ["vinegar apple", 39], ["silver apple", 39], ["jeans apple bottom",
     39], ["apple bottom", 39], ["what is in apple juice", 38], ["stock of apple",
     38], ["stock in apple", 38], ["stock for apple", 38], ["stock apple com",
     38], ["apple apple juice", 38], ["tree apple", 36], ["cider apple", 36], ["apple
     stock shares", 34], ["ipad best buy", 33], ["apple pie", 33], ["apple jeans",
     33], ["recipes for apple crisp", 31], ["recipe apple", 31], ["ipad charger",
     31], ["apple osx tiger icons", 31], ["apple airport express", 31], ["wikipedia
     apple", 29], ["green apple", 28], ["apple charger", 28], ["ipad 2 best buy",
     26], ["fiona apple", 26], ["big apple", 26], ["wikipedia ipad", 25], ["keyboard
     case for ipad 2", 25], ["ipad 2 keyboard case", 25], ["ipad 2 case with keyboard",
     25], ["ipad 2 case and keyboard", 25], ["ipad 2 best cases", 25], ["best cases
     for ipad 2", 25], ["pie recipe apple", 24], ["stocks on apple", 23], ["leather
     ipad 2 case", 23], ["leather case for ipad 2", 23], ["cider from apple juice",
     23], ["cider apple juice", 23], ["apple talk", 23], ["apple juice apple cider",
     23], ["apple juice and apple cider", 23], ["apple cider or apple juice", 23],
     ["apple cider from apple juice", 23], ["walmart ipad", 22], ["target ipad",
     22], ["stock price of apple", 22], ["stock price for apple", 22], ["stock
     price apple", 22], ["red apple", 22], ["price of stock for apple", 22], ["ipad
     at target", 22], ["ipad 2 cover case", 22], ["apple lyrics", 22], ["apple
     stocks and shares", 21], ["apple itunes", 21], ["apple federal credit union",
     21], ["apple crisp", 21], ["value of apple stock", 20], ["stock quote for
     apple", 20], ["stock quote apple", 20], ["pie crust for apple pie", 20], ["ipad
     2 case review", 20], ["how to can apple juice", 20], ["crystal apple", 20],
     ["can apple juice", 20], ["apple trailers", 20], ["apple stock value", 20],
     ["apple stock share price", 20], ["apple stock price quote", 20], ["apple
     pie crust", 20], ["apple picking", 20], ["apple ipad 2 case", 20], ["apple
     cinnamon", 20], ["stock market for apple", 19], ["stock market apple", 19],
     ["orchard apple", 19], ["ipad", 19], ["beatles apple", 19], ["apple in the
     stock market", 19], ["apple caramel", 19], ["apple cake", 19], ["make apple
     juice", 18]]
    
### Question Keywords

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_questions(keywords)
    
    # Example data response
    [["what is in apple juice", 38], ["how to can apple juice", 20], ["can apple juice", 20], 
     ["why buy apple stock", 13], ["where to buy apple stock", 13], ["what s in apple juice", 13], 
     ["what is apple juice concentrate", 13], ["how do i buy apple stock", 13], 
     ["what is apple stock today", 12], ["what is apple juice made of", 12], ["how is apple juice made", 12], 
     ["how much is apple juice", 11], ["does apple juice go bad", 10], ["kindle vs ipad", 9], 
     ["is apple juice good for you", 9], ["how much is stock in apple", 9], ["how much is apple stock", 9], 
     ["cider vs apple juice", 9], ["apple juice vs apple cider", 9], ["who owns apple", 8],
     ["what is apple stock worth", 8], ["will apple stock split", 7], ...]

### Related Keywords

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_related(keywords)
    
    # Example data response
    ["mac os x", "learn and earn", "all around
     my", "store for education", "the crazy ones", "mac os rumors", "rip mix burn",
     "ipaq pocket pc", "will ferrell", "steve jobs", "will farrell", "os x", "developer
     connection", "think different", "power book", "learning interchange", "mac
     rumors", "steven jobs", "knowledge navigator", "digital hub", "think secret",
     "jonathan ive", "i mac", "data quest", "crazy ones", "rescue raiders", "mac
     rumor", "next byte", "megahertz myth", "real losers", "pocket pc", "hard reset",
     "concurso publico", "com br", "ipaq 2210", "ipaq 4150", "ipaq 1940", "detran
     pernambuco", "detran pe", "iphone", "macintosh", "titanium", "laptops", "applescript",
     "mac", "applesauce", "apples", "rumors", "mackintosh", "orchards", "appleseed",
     "versiontracker", "resellers", "parody", "keynote", "imovie", "superdrive",
     "crabapple", "wallstreet", "macworld", "iphoto", "appleworks", "applewood",
     "cider", "parodies", "crumble", "laserwriter", "schnapps", "powerpc", "martinis",
     "applecare", "performa", "crisp", "spoof", "rumor", "manzana", "stylewriter",
     "gravis", "appletalk", "wozniak", "clarisworks", "pismo", "strudel", "macs",
     "appel", "garamond", "pectin", "altair", "applejacks", "applestore", "macally",
     "macrumors", "hypercard", "appleshare", "powerlogix", "macos", "applemac",
     "isync", "thinkdifferent", "carbonlib"]

## Todo

1. Handle potential errors better when making requests to Wordstream.
2. Refactor HTTP requests.
3. Make a Response class to be returned from API calls instead of parsed JSON.
4. Implement callback parameter for api calls that allow for JSONP callback.

## License

Written by Chavez

Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
