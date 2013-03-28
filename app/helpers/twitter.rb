helpers do
   
  def client
    @client ||= Twitter::Client.new(
      :oauth_token => session[:oauth][:access_token],
      :oauth_token_secret => session[:oauth][:access_token_secret]
      )
  end

  def create_user
   user_hash = {
          twitter_id: client.user.id, 
          access_token: session[:oauth][:access_token],
          access_token_secret: session[:oauth][:access_token_secret]
    }
  
    user = User.create(user_hash)
    session[:user_id] = user.id
  end

  def current_user
    @current_user = User.find(session[:user_id])
  end

  def job_is_complete(jid)
    waiting = Sidekiq::Queue.new
    working = Sidekiq::Workers.new
    return false if waiting.find { |job| job.jid == jid }
    return false if working.find { |worker, info| info["payload"]["jid"] == jid }
    true
  end
end
