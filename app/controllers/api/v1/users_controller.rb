class Api::V1::UsersController < Api::V1::BaseController
  def index
    users = User.all
    render(
      json: {
        success: true,
        data: tweets.each { |d| Api::V1::UserSerializer.new(d, root: false) },
        errors: []
      },
      status: 201
    )
  end
end