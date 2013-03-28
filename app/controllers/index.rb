before do
  @consumer = OAuth::Consumer.new(ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], {
    :site=>"https://api.twitter.com" })
  puts ENV['TWITTER_KEY']
  puts ENV['TWITTER_SECRET']
  
end

get '/' do
  @tweets = []
  erb :index
end

get '/twitter_token' do
  p request.host_with_port
 
  @request_token = @consumer.get_request_token(oauth_callback: "http://#{request.host_with_port}/oauth")
  session[:request_token] = @request_token
  redirect @request_token.authorize_url
end

get '/oauth' do
  @request_token = session[:request_token]
  @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  session[:oauth] = {
    :access_token => @access_token.token,
    :access_token_secret => @access_token.secret      
  }
  client
  create_user
  erb :tweet
end

# post '/user' do
#   @user = User.find_by_name(params[:username])
#   begin
#     @user = User.create(name: params[:username]) if Twitter.user(params[:username]) unless @user
#   rescue
#   end
  
#   if @user
#     @user.fresh!
#     @tweets = @user.tweets.order("created_at DESC")
#   else
#     @tweets = []
#   end
#   erb :index
# end

# Ajax routes related to tweets

post '/tweet' do   #sidekiq
  current_user.tweet(params[:tweet_content])
end

get '/status/:job_id' do
  
  p params[:job_id]
  jobby = job_is_complete(params[:job_id]) ? "true" : "false"
  jobby
end

