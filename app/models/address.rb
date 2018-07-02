class Address
  include GoogleMapsApiClient

  PLACES = [
    '50.450015,30.523648', # Центр
    '50.406669,30.519762', # Автовокзал
    '50.456183,30.364824', # м. Житомирська
    '50.441926,30.488186'  # м. Вокзальна
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

    @info = {
      location_map:     location_map_url,
      coordinates:      @coordinates,
      directions:       directions(PLACES),
      metros:           metros(::METROS),
      closest_metro:    closest_metro(::METROS),
      metros_in_radius: metros_in_radius(::METROS)
    }
  end

end
