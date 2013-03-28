class TweetWorker
  include Sidekiq::Worker
  # sidekiq_options :retry => false, :timeout => 60

  def perform(user_id, tweet_id)
    user  = User.find(user_id)
    tweet = user.tweets.find(tweet_id)
      puts "starting..."
      begin
        @client ||= Twitter::Client.new(
          :oauth_token => user.access_token,
          :oauth_token_secret => user.access_token_secret
          )
        @client.update(tweet.text)
      rescue Twitter::Error => e
        @errors = e
      end
  end
end


