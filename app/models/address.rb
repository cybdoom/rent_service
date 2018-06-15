class Address
  include GoogleMapsApiClient

  PLACES = [
    '50.450015,30.523648',
    '50.406669,30.519762',
    '50.456183,30.364824'
  ]

  def initialize(full_name)
    @full_name = full_name
  end

  def info
    @info ||= load_info
  end

  def to_params
    {address: @full_name}.to_query
  end

  def self.to_url_param(full_name)
    URI.encode(full_name)
  end

  private

  def load_info
    @coordinates ||= get_coordinates
    @info = {location_map: location_map_url, coordinates: @coordinates, directions: directions(PLACES)}
  end

end
