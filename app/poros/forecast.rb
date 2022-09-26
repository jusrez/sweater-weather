class Forecast
  attr_reader :id, :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @id = nil
    @current_weather = current(data)
    @daily_weather = daily(data)
    @hourly_weather = hourly(data)
  end

  def current(data)
    {
      datetime: Time.at(data[:current][:dt]),
      sunrise: Time.at(data[:current][:sunrise]),
      sunset: Time.at(data[:current][:sunset]),
      temperature: data[:current][:temp],
      feels_like: data[:current][:feels_like],
      humidity: data[:current][:humidity],
      uvi: data[:current][:uvi],
      visibility: data[:current][:visibility],
      conditions: data[:current][:weather][0][:description],
      icon: data[:current][:weather][0][:icon]
    }
  end

  def daily(data)
    data[:daily].first(5).map do |day|
      {
        date: Time.at(day[:dt]).strftime("%Y-%m-%e"), 
        sunrise: Time.at(day[:sunrise]), 
        sunset: Time.at(day[:sunset]), 
        max_temp: day[:temp][:max], 
        min_temp: day[:temp][:min], 
        conditions: day[:weather][0][:description], 
        icon: day[:weather][0][:icon] 
      }
    end
  end

  def hourly(data)
    data[:hourly].first(8).map do |hour| 
      {
        time: Time.at(hour[:dt]).strftime("%H:%M:%S"),
        temperature: hour[:temp],
        conditions: hour[:weather][0][:description],
        icon: hour[:weather][0][:icon] 
      }
    end
  end
end