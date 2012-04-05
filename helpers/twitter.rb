module Sinatra
  module TwitterHelper
    USERNAME = "inhortte"

    def twitter_authenticate
      Twitter.configure do |config|
        config.consumer_key = "tquSIHqPE7mfAn1YeA43bg"
        config.consumer_secret = "V7wbE8xccMmdQPK7AkuZdp9leDXjLFCGb8jKM4"
        config.oauth_token = "215388619-82R9I0e40747hRce1KqL03dhRv1sGOPMFtOXycYp"
        config.oauth_token_secret = "Vv246StvRsPwLKc9EUkveNFVQo3f2pDbk5KjKMKOk6U"
      end
    end

    def twitter_image_url
      Twitter.user(USERNAME).profile_image_url
    end

    def last_tweets(*num)
      n = if num.empty?
            5
          else
            num[0]
          end
      Twitter.user_timeline(USERNAME)[0..(n - 1)].map { |t| t.text }
    end
  end
  
  helpers TwitterHelper
end
