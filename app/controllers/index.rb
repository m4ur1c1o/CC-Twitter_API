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
		@timeline = exisiting_user.tweets
	end




	erb :tweets
end
