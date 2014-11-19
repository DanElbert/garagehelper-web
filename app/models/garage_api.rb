class GarageApi

  def self.status
    res = connection.get('/status')
    if res.body.present?
      res.body
    else
      {}
    end
  end

  def self.push_garage_door
    res = connection.post('/pushGarageOpener')
    res.status.to_i == 204
  end

  def self.connection
    Faraday.new('http://garagehelper.thenever/') do |faraday|
      faraday.request :json
      faraday.adapter :em_http
    end
  end
end