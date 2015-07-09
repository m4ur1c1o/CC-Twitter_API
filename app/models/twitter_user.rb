class TwitterUser < ActiveRecord::Base
  has_many :tweets

  validates :username, presence: true, uniqueness: true

  def updated?
  	last_tweet_updated_date = self.tweets.last.updated_at
  	if Time.now - last_tweet_updated_date < 3.minutes
  		true
  	else
  		false
  	end
  end

  def tweet(text)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = self.oauth_token
      config.access_token_secret = self.oauth_token_secret
    end

    client.update!(text)

  end
end
