class AutomationApi

  DOOR_NAME_LOOKUPS = {
      big_door_open?: 'garage_big_door',
      back_door_open?: 'garage_back_door',
      basement_door_open?: 'garage_basement_door'
  }

  def self.set_door_state(door_name, is_open)
    raise "Invalid door: [#{door_name}]" unless DOOR_NAME_LOOKUPS.has_key? door_name
    res = connection.put("/rest/items/#{DOOR_NAME_LOOKUPS[door_name]}/state", is_open ? 'OPEN' : 'CLOSED')
    unless res.success?
      Rails.logger.warn("Attempt to update Automation failed: HTTP Status [#{res.status}]")
    end
    res.success?
  end

  def self.connection
    Faraday.new('https://automation.elbert.us/', ssl: { verify: false }) do |faraday|
      faraday.basic_auth('garage', ENV['OPENHAB_PASSWORD'])
      faraday.headers["Content-Type"] = "text/plain"
      faraday.adapter Faraday.default_adapter
    end
  end
end