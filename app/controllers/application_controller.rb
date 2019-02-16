class ApplicationController < ActionController::API
  before_action :print_params
  before_action :set_device_from_token

  private
  def print_params
    puts '--------------------------------'
  end
  
  def set_device_from_token
    auth_token = request.headers['Authorization']
    if auth_token
      authenticate_with_auth_token(auth_token)
    else
      authentication_error
    end
  end

  def authenticate_with_auth_token(token)
    @device = Device.where(installation_id: token).first
    if @device
      @device.touch # update device timestamp
    else
      authentication_error('token not found')
    end
  end

  def authentication_error(message = nil)
    # puts 'auth error------------------------------------------'
    # puts "Action: #{action_name} Controller: #{controller_name}"
    render json: {error: message}, status: 401  # Authentication timeout
  end
end
