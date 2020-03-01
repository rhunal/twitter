class Tweet < ApplicationRecord
  belongs_to :user
  validates :description, presence: true

  scope :visible, ->(current_user){ where(user_id: [current_user.follows.pluck(:followed_id), current_user.id]) }
end
