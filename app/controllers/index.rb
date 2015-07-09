# before do
# 	pass if ['sign_in', nil].include? request.path_info.split('/')[1]
# 	if session[:screen_name] == nil
# 		# puts "No existe una sesion"
# 		session[:errors] = "No existe una sesion"
# 		# @error = session[:error]
# 		redirect to("/")
# 	end
# end


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

# OAuth

get '/sign_in' do
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera atentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url 
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'acces_token' 
  # Este 'acces_token' lo utilizaremos para futuras comunicaciones.   
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  # TESTING @access_token
  # session[:token] = @access_token

  oauth_token = @access_token.params[:oauth_token]
  oauth_token_secret = @access_token.params[:oauth_token_secret]
  screen_name = @access_token.params[:screen_name]

  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir. 
  session.delete(:request_token)
  
  user = TwitterUser.create(username: screen_name, oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
  session[:screen_name] = user.username

  # redirect to ('/test')
  erb :twitter_access_success

  # Aquí es donde deberás crear la cuenta del usuario y guardar, usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  # No olvides crear su sesión 


end

  # Para el signout no olvides borrar el hash de session

# get '/test' do
# 	@token = session[:token]
# 	erb :twitter_access_success
# end

get '/logout' do
	session.clear
	redirect to('/')
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
		@tweets = CLIENT.user_timeline(username, options)
		@tweets.each do |tweet|
			@timeline << Tweet.create(tweet: tweet.text, twitter_user_id: user.id)
		end
	else
		if exisiting_user.updated?
			@timeline = exisiting_user.tweets
			@trajimos_tweets = "NO trajimos Tweets"
		else
			@trajimos_tweets = "Si trajimos Tweets"
			@tweets = CLIENT.user_timeline(username, options)
			@tweets.each do |tweet|
				@timeline << Tweet.create(tweet: tweet.text, twitter_user_id: exisiting_user.id)
			end
		end
	end

	erb :tweets
end

# post '/tweet' do
# 	tweet = params[:tweet]
# 	user_id = 1

# 	begin
# 		status = CLIENT.update!(tweet)
# 	rescue
# 		session[:error] = "Unable to Tweet"
# 	end

# 	if status
# 		Tweet.create(tweet: status.text, twitter_user_id: user_id)		
# 	end

# 	redirect to('/status')
# end

post '/tweet_ajax' do
	tweet_text = params[:textarea]
	# user_id = 1
	screen_name = session[:screen_name]
	user = TwitterUser.find_by(username: screen_name)

	begin
		status = user.tweet(tweet_text)
	rescue
		
	end

	if status
		Tweet.create(tweet: status.text, twitter_user_id: user.id)	
		'Tweet success'
	else
		"Unable to Tweet"
	end

end


