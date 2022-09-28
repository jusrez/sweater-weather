class Location
  attr_reader :lat, :long

  def initialize(data)
    @lat = data[:results][0][:locations][0][:latLng][:lat]
    @long = data[:results][0][:locations][0][:latLng][:lng]
  end
end