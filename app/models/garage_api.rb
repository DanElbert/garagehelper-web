class GarageApi
  include HTTParty
  base_uri 'http://garagehelper.thenever/'
  format :json

  def self.status
    get('/status').parsed_response
  end

  def self.push_garage_door
    post('/pushGarageOpener').code == 204
  end
end