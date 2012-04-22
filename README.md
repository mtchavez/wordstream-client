# Wordstream API Gem

A wrapper around the Wordstream API calls.

* [Github](http://github.com/mtchavez/wordstream-client "Github Repo")
* [Rubygems](http://rubygems.org/mtchavez/wordstream-client "Rubygems Page")

## Disclaimer

The Wordstream API is constructed very poorly in my personal opinion. In addition to this I have had issues with it's
reliability and usability. I take no responsibility for you using their service and I advise you use them 
**at your own risk**. This library was written due to the lack of libraries for Ruby and due to the only one out there does
not look maintained nor does it implement all the current endpoints available.

## Description

Wordstream API gem to wrap the API calls available. Allows you to login/logout, get your api credits, get keyword volumes,
get keyword suggestions, get keyword niches, get question keywords and get related keywords. Currently the callback parameter
is not implemented on any of the endpoints. This may change in the future if it becomes a needed feature.

## Install

    gem install wordstream-client

## Setup

  To set up the gem you need to set your Wordstream username and password before making any API requests.

    require 'wordstream-client'
    
    WordstreamClient::Config.username = 'user@example.com'
    WordstreamClient::Config.password = 'password'

## Authentication Endpoints

---

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

---

### Volumes

  To get keyword volumes you can pass in an array of keywords to get their volumes *relative* to each other.

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_volumes(keywords)
    
    # Returns array of arrays with keywords and their volume
    # [ ['running', 123], ['apple', 77], ['ipod', 34] ]
    
    keyword_volumes       = Hash[data]
    keywords_with_volumes = keyword_volumes.keys

### Niches

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_niches(keywords)
    
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

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_suggestions(keywords)

### Question Keywords

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_questions(keywords)

### Related Keywords

    keywords = %w[running apple ipod ipad race triathlon]
    data     = WordstreamClient::KeywordTool.get_related(keywords)

## License

Written by Chavez

Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
