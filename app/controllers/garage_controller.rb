class GarageController < ApplicationController

  protect_from_forgery :except => [:update]

  if ENV["GARAGE_HELPER_PASSWORD"]
    http_basic_authenticate_with name: "dan", password: ENV["GARAGE_HELPER_PASSWORD"], except: [:update, :keepalive]
  end

  before_action :only_allow_helper, only: [:update, :keepalive]

  def status
    begin
      @status = GarageApi.status
    rescue
      update = GarageUpdate.history.first
      flash[:notice] = "Unable to contact Garage Helper.  Displaying last known status as of #{update.created_at}"
      @status = { 'bigDoor' => update.big_door_open?, 'backDoor' => update.back_door_open?, 'basementDoor' => update.basement_door_open? }
    end
  end

  def history
    @updates = GarageUpdate.history
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
    render nothing:true, status: 204
  end

  protected

  def only_allow_helper
    unless request_ip_addresses.include?('10.0.0.105')
      Rails.logger.info "Rejected request from #{request.env['HTTP_X_FORWARDED_FOR']}"
      render nothing: true, status: 401
    end
  end

  private

  def request_ip_addresses
    request.env['HTTP_X_FORWARDED_FOR'].to_s.split(',').map { |ip| ip.strip }.compact
  end

end