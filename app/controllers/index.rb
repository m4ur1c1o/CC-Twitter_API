get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb
  erb :index
end

post '/fetch' do
	username = params[:username]

	redirect to("/#{username}")
end

get '/status' do
	user = TwitterUser.find(1)
	# user = Tweet.find_by(twitter_user_id: 1)
	@status = user.tweets.last.tweet

	@error = session[:error]

	erb :status
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

post '/tweet' do
	tweet = params[:tweet]
	user_id = 1

	begin
		status = $client.update!(tweet)
	rescue
		session[:error] = "Unable to Tweet"
	end

	if status
		Tweet.create(tweet: status.text, twitter_user_id: user_id)		
	end

	redirect to('/status')
end

post '/tweet_ajax' do
	tweet = params[:textarea]
	user_id = 1

	begin
		status = $client.update!(tweet)
	rescue
		
	end

	if status
		Tweet.create(tweet: status.text, twitter_user_id: user_id)	
		'Tweet success'
	else
		"Unable to Tweet"
	end

end