module GarageHelper
  def door_status(stat)
    stat ? 'Open' : 'Closed'
  end
end