class Api::V1::TweetSerializer < Api::V1::BaseSerializer
  attributes :id, :description, :follower, :follows

  def follower
    object.followed
  end

  def following
    object.follows
  end
end
