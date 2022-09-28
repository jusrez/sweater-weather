class Roadtrip
  attr_reader :start_city, :end_city, :travel_time, :weather_at_eta
  def initialize(trip_data, weather_data)
    @start_city = origin(trip_data)
    @end_city = destination(trip_data)
    @travel_time = trip_time(trip_data)
    @weather_at_eta = destination_weather(weather_data)
  end

  def trip_time(trip_data)
    formatted_time = location_data[:route][:formattedTime]
    if formatted_time == nil
      return 'impossible route'
    else
      return formatted_time
    end
  end

  def origin(trip_data)
    city = trip_data[:route][:locations][0][:adminArea5]
    state = trip_data[:route][:locations][0][:adminArea3]
    return "#{city}, #{state}"
  end

  def destination(trip_data)
    city = trip_data[:route][:locations][1][:adminArea5]
    state = trip_data[:route][:locations][1][:adminArea3]
    return "#{city}, #{state}"
  end

  def destination_weather(weather_data)
    if @travel_time == 'impossible route'
      return nil
    else
      eta = @travel_time.to_i
      hourly_weather = weather_data[:hourly][eta]
    {
      temperature: hourly_weather[:temp]
      conditions: hourly_weather[:weather][0][:description]
    }
    end
  end
end