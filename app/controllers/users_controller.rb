class UsersController < ApplicationController
  before_action :set_user, only: [:follow, :unfollow]

  def follow
    @follow = current_user.follows.build
    @follow.followed_id = @user.id
    @follow.save
    redirect_to peoples_users_path
  end

  def unfollow
    followed = current_user.follows.find_by(followed_id: @user.id)
    followed.destroy
    redirect_to peoples_users_path
  end

  def peoples
    @users = User.where.not(id: current_user.id)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
