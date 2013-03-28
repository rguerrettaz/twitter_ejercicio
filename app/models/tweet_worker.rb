class TweetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :timeout => 60

  def perform(user_id, tweet_id)
    user  = User.find(user_id)
    tweet = user.tweets.find(tweet_id)
    @client ||= Twitter::Client.new(
      :oauth_token => user.access_token,
      :oauth_token_secret => user.access_token_secret
      )
    @client.update(tweet.text)
  end
end


#   @error_message = nil
#   begin
#     @client.update(params[:text])
#   rescue Twitter::Error => e
#     @error_message = e.message
#   end
#   if @error_message
#       @error_message
#   else
#     #@client.user_timeline.first.text
#     params[:text]
#   end
