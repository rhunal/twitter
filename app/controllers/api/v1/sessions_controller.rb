class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    return api_error(errors: 'Email required !!') unless params[:email].present?
    return api_error(errors: 'Password required !!') unless params[:password].present?

    user = User.find_by_email(create_params[:email])

    if user && user.valid_password?(create_params[:password])
      user.refresh_token!
      self.current_user = user

      render(
        json: {
          success: true,
          data: JSON.parse(Api::V1::SessionSerializer.new(user, root: false).to_json),
          errors: []
        },
        status: 201
      )
    else
      unauthenticated!
    end
  end

private
  def create_params
    {
      email: params[:email],
      password: params[:password]
    }
  end
end