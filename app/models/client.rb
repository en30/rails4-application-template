class Client
  def self.make(user)
    Twitter::REST::Client.new(
      consumer_key: Settings.twitter.consumer_key,
      consumer_secret: Settings.twitter.consumer_secret,
      access_token: user.access_token,
      access_token_secret: user.access_token_secret
    )
  end

  def self.make_for_app
    Twitter::REST::Client.new(
      consumer_key: Settings.twitter.consumer_key,
      consumer_secret: Settings.twitter.consumer_secret,
      access_token: Settings.twitter.access_token,
      access_token_secret: Settings.twitter.access_token_secret
    )
  end
end
