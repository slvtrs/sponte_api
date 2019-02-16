class ProfilesController < ApplicationController
  skip_before_action :set_device_from_token, only: [:self, :update, :destroy]
  before_action :set_profile, only: [:show]
  before_action :set_profile_from_token, only: [:self, :update, :destroy]

  def self
    render json: {profile: @profile, posts: Post.mutate(@profile.posts)}
  end

  # GET /profiles
  def index
    @profiles = Profile.all

    render json: @profiles
  end

  # GET /profiles/1
  def show
    render json: @profile
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      render json: @profile, status: :created, location: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_profile_from_token
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
        @profile = @device.profile
      else
        @profile = Profile.new
        if @profile.save!
          @device = @profile.devices.build(installation_id: token)
          @device.save!
        end
      end
    end

    def authentication_error(message = nil)
      # puts 'auth error------------------------------------------'
      # puts "Action: #{action_name} Controller: #{controller_name}"
      render json: {error: message}, status: 401  # Authentication timeout
    end

    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:device_id, :bio, :window_start_at, :window_end_at)
    end
end
