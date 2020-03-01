class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :followed, foreign_key: 'followed_id', class_name: 'Follow'
  has_many :follows
  has_many :tweets

  def is_following? user_id
    follows.where(followed_id: user_id).present?
  end

  def refresh_token!
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end

    self.save!
  end

  private
  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end
end
