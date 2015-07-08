get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb
  erb :index
end

post '/fetch' do
	username = params[:username]

	redirect to("/#{username}")
end

get '/:username' do
	username = params[:username]
	# user = TwitterUser.find_by(username: username)
	# user_id = user.id

	# tweet = Tweet.find_by(twitter_user_id: user_id)

	options = {count: 20}
	@timeline = []
	exisiting_user = TwitterUser.find_by(username: username)

	if exisiting_user == nil  
		user = TwitterUser.create(username: username)
		@tweets = $client.user_timeline(username, options)
		@tweets.each do |tweet|
			@timeline << Tweet.create(tweet: tweet.text, twitter_user_id: user.id)
		end
	else
		if exisiting_user.updated?
			@timeline = exisiting_user.tweets
			@trajimos_tweets = "NO trajimos Tweets"
		else
			@trajimos_tweets = "Si trajimos Tweets"
			@tweets = $client.user_timeline(username, options)
			@tweets.each do |tweet|
				@timeline << Tweet.create(tweet: tweet.text, twitter_user_id: exisiting_user.id)
			end
		end
	end

	erb :tweets
end
