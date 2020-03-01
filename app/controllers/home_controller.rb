class HomeController < ApplicationController
  def index
    @tweets = Tweet.visible(current_user)
    @tweet = current_user.tweets.build
  end

  def create_tweet
    @tweet = current_user.tweets.new(tweet_params)
    @tweet.save
    redirect_to root_path, notice: @tweet.errors.full_messages.join(',').presence || 'Tweeted.'
  end

  def tweet_params
    params.require(:tweet).permit(
      :description
    )
  end
end
