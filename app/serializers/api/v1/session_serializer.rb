class Api::V1::SessionSerializer < Api::V1::BaseSerializer
  #just some basic attributes
  attributes :id, :email, :token, :success, :errors

  def success
    true
  end

  def errors
    []
  end

  def token
    object.authentication_token
  end
end
