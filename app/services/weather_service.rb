class WeatherService
  def self.location_weather(latitude, longitude)
    response = conn.get("/data/2.5/onecall?lat=#{latitude}&lon=#{longitude}&exclude=minutely,alerts&units=imperial")
    parse_response(response)
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true) if response.status == 200
  end

  private
  def self.conn
    Faraday.new("https://api.openweathermap.org", params: { appid: ENV['WEATHER_API_KEY'] })
  end
end