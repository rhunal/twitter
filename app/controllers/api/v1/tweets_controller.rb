class Api::V1::TweetsController < Api::V1::BaseController
  def index
    tweets = Tweet.visible(@current_user)
    render(
      json: {
        success: true,
        data: tweets.each { |d| Api::V1::TweetSerializer.new(d, root: false) },
        errors: []
      },
      status: 201
    )
  end
end