class Address
  include GoogleMapsApiClient

  def initialize(full_name)
    @full_name = full_name
  end

  def info
    @info ||= load_info
  end

  def to_params
    {address: @full_name}.to_query
  end

  private

  def load_info
    @coordinates ||= get_coordinates
    @info = {location_map: location_map_url, coordinates: @coordinates}
  end

end
