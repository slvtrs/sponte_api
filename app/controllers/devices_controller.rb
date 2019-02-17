class DevicesController < ApplicationController
  # before_action :set_device, only: [:show, :update, :destroy]
  skip_before_action :set_device_from_token, only: [:update]

  # GET /devices
  def index
    @devices = Device.all
    render json: @devices
  end

  # GET /devices/1
  def show
    render json: @device
  end

  # POST /devices
  def create
    @device = Device.new(device_params)

    if @device.save
      render json: @device, status: :created, location: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  def update
    message = ''
    if !@device
      auth_token = request.headers['Authorization']
      if auth_token
        @device = Device.where(installation_id: auth_token).first
        if !@device
          @profile = Profile.new
          if @profile.save!
            @device = @profile.devices.build(installation_id: auth_token)
            @device.save!
          end
        end
      else
        message = 'missing auth token'
      end
    end

    if !message.blank?
      render json: {error: message}, status: 401  # Authentication timeout
    else
      if @device.update(device_params)
        @device.save!
        render json: @device
      else
        render json: @device.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_device
    #   @device = Device.find(params[:id])
    # end

    # Only allow a trusted parameter "white list" through.
    def device_params
      params.require(:device).permit(:installation_id, :push_token)
    end
end
