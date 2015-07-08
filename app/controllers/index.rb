get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb
  erb :index
end

post '/fetch' do
	username = params[:username]

	redirect to("/#{username}")
end

get '/:handle' do
	username = params[:handle]
	options = {count: 20}
	@timeline = $client.user_timeline(username, options)
	puts "Timeline: #{@timeline.first.text}"

	erb :tweets
end