class GarageController < ApplicationController

  protect_from_forgery :except => [:update, :push_door_opener]

  if ENV["GARAGE_HELPER_PASSWORD"]
    http_basic_authenticate_with name: "dan", password: ENV["GARAGE_HELPER_PASSWORD"], except: [:update, :keepalive]
  end

  before_action :only_allow_helper, only: [:update, :keepalive]

  def status
    begin
      @status = GarageApi.status
    rescue
      update = GarageUpdate.history.first
      if update
        flash[:error] = "Unable to contact Garage Helper.  Displaying last known status as of #{update.created_at}"
        @status = { 'bigDoor' => update.big_door_open?, 'backDoor' => update.back_door_open?, 'basementDoor' => update.basement_door_open? }
      else
        flash[:error] = "Unable to contact Garage Helper and no previous updates found"
        @status = {}
      end
    end
  end

  def history
    @updates = GarageUpdate.history
  end

  def summary
    @summary = GarageUpdate.summarize
  end

  def push_door_opener
    begin
      GarageApi.push_garage_door
      flash[:notice] = "Button pushed"
    rescue
      flash[:error] = "Unable to contact Garage Helper"
    end
    redirect_to :back
  end

  # POST /garage/helper/update
  def update
    if [:bigDoor, :backDoor, :basementDoor].all? { |d| params.has_key? d }
      previous = GarageUpdate.history.first
      update = GarageUpdate.new(big_door_open: params[:bigDoor], back_door_open: params[:backDoor], basement_door_open: params[:basementDoor])
      update.is_change = update.different?(previous)
      update.save!

      if update.is_change?
        update.differences(previous).each do |door|
          AutomationApi.set_door_state(door, update.send(door))
        end
      end

      render nothing: true, status: 204
    else
      raise "Missing params"
    end
  end

  # GET /garage/helper/keepalive
  def keepalive
    render nothing:true, status: 204
  end

end