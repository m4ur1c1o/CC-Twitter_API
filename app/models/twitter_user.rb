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
end
