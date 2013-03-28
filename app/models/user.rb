class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status)
    tweet = Tweet.create(text: status)
    self.tweets << tweet
    # TweetWorker.perform_async(self.id, self.tweets.last.id)
    TweetWorker.perform_in(30.seconds, self.id, self.tweets.last.id)
  end

  def fresh!
    tweets = Twitter.user_timeline(self.name).reverse if self.tweets.empty? || self.stale?
    if tweets
      self.cached_at = Time.now
      self.save
      self.tweets << tweets.map{|tweet| Tweet.find_or_create_by_tweet_id( tweet_id: tweet.id, 
                                        text: tweet.text, 
                                        tweet_created_at: tweet.created_at)}
    end
  end

  def stale?
    self.cached_at < 15.minutes.ago
  end
end
