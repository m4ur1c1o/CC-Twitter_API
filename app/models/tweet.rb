class Tweet < ActiveRecord::Base
  belongs_to :twitter_user
  validates :tweet, uniqueness: true
end
