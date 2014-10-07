class GarageController < ApplicationController

  protect_from_forgery :except => [:update]

  def status
    @status = GarageApi.status
  end

  def history
    @updates = GarageUpdate.order(created_at: :desc).limit(100)
  end

  # POST /garage/update
  def update
    if [:bigDoor, :backDoor, :basementDoor].all? { |d| params.has_key? d }
      GarageUpdate.create!(big_door_open: params[:bigDoor], back_door_open: params[:backDoor], basement_door_open: params[:basementDoor])
      render nothing: true, status: 204
    else
      raise "Missing params"
    end
  end

end