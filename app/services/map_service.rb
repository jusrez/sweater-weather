class MapService

  def self.find_location(query)
    response = conn.get("/geocoding/v1/address?location=#{query}")
    parse_response(response)
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true) if response.status == 200
  end

  private

  def self.conn
    Faraday.new("http://www.mapquestapi.com", params: { key: ENV['MAP_API_KEY'] })
  end
end