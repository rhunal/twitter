class Api::V1::BaseController < ApplicationController
  # include Pundit
  # include ActiveHashRelation
  include ActionController::Serialization
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  attr_accessor :current_user
  protected

  def destroy_session
    request.session_options[:skip] = true
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: {
      success: false,
      error: ['Bad credentials']
    }, status: 401
  end

  def unauthorized!
    render json: { error: 'not authorized' }, status: 403
  end

  def invalid_resource!(errors = [])
    api_error(status: 422, errors: errors)
  end

  def not_found!
    return api_error(status: 404, errors: 'Not found')
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end

    render json: {
      success: false,
      error: JSON.parse(jsonapi_format(errors).to_json)
    }, status: status
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per_page(params[:per_page])
    end

    return resource
  end

  def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    user_id = params.try(:[], :user_id).to_i
    user = user_id && token && User.find(user_id)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end
end