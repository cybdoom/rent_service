class Address
  include GoogleMapsApiClient

  def initialize(city:, street_type:, street_name:, building:)
    @city        = city
    @street_type = street_type
    @street_name = street_name
    @building    = building
  end

  def info
    @info ||= load_info
  end

  def to_params
    { address: to_s }.to_query
  end

  def to_s
    "#{city}, #{street_type} #{street_name} #{building}"
  end

  private

  def load_info
    @coordinates ||= get_coordinates
    @info = {location: location_map_url}
  end

end
