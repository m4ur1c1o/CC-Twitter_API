# app/models/tweet_worker.rb

class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    # tweet = # Encuentra el tweet basado en el 'tweet_id' pasado como argumento
    tweet = Tweet.find(tweet_id)
    # user  = # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet
    user = tweet.twitter_user
    # Manda a llamar el método del usuario que crea un tweet (user.tweet)
    user.tweet(tweet.tweet)
  end
end