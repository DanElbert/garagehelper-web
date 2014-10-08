class GarageController < ApplicationController

  protect_from_forgery :except => [:update]

  before_action :only_allow_helper, only: [:update, :keepalive]

  def status
    @status = GarageApi.status
  end

  def history
    @updates = GarageUpdate.order(created_at: :desc).limit(100)
  end

  def summary
    @summary = GarageUpdate.summarize
  end

  def push_door_opener
    GarageApi.push_garage_door
    flash[:notice] = "Button pushed"
    redirect_to garage_status_path
  end

  # POST /garage/helper/update
  def update
    if [:bigDoor, :backDoor, :basementDoor].all? { |d| params.has_key? d }
      GarageUpdate.create!(big_door_open: params[:bigDoor], back_door_open: params[:backDoor], basement_door_open: params[:basementDoor])
      render nothing: true, status: 204
    else
      raise "Missing params"
    end
  end

  # GET /garage/helper/keepalive
  def keepalive
    #Rails.logger.fatal "Remote: #{request.remote_ip}; x forwarded header: #{request.env["HTTP_X_FORWARDED_FOR"]}"
    render nothing:true, status: 204
  end

  protected

  def only_allow_helper
    render nothing: true, status: 401 unless request.env['HTTP_X_FORWARDED_FOR'] == '10.0.0.105'
  end

end