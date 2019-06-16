require 'rest-client'

module GoogleMapsApiClient
  extend ActiveSupport::Concern

  GOOGLE_MAPS_API_ENDPOINT = 'https://maps.googleapis.com/maps/api'
  STATIC_MAP_SIZE = '600x600'
  RADIUS = 2

  def get_coordinates
    url = "#{GOOGLE_MAPS_API_ENDPOINT}/geocode/json?key=#{app_key}&#{self.to_params}"
    JSON.parse(RestClient.get url)['results'].first['geometry']['location']
  end

  def location_map_url
    "#{GOOGLE_MAPS_API_ENDPOINT}/staticmap?key=#{app_key}&#{{center: @full_name}.to_query}&size=#{STATIC_MAP_SIZE}&zoom=15&markers=size:mid%7C#{Address.to_url_param(@full_name)}"
  end

  def location_map_zoom_url
    location_map_url.gsub('zoom=15', 'zoom=18')
  end

  def location_map_satellite_url
    location_map_url + '&maptype=satellite'
  end

  def app_key
    'AIzaSyDT17duKrq7z53D6ii9Dq2F3KaLDeweYgY'
  end

  def directions(places)
    result = {}
    places.each do |place|
      url = "#{GOOGLE_MAPS_API_ENDPOINT}/directions/json?key=#{app_key}&origin=#{Address.to_url_param(@full_name)}&mode=walking&destination=#{place}"
      response = JSON.parse(RestClient.get url)
      result[place] = begin
        response['routes'].first['legs'].first['distance']['text'].split(' ').first
      rescue
        nil
      end
    end

    result
  end

  def metros
    return @metros if @metros.present?

    @metros = {}
    ::METROS.each do |metro|
      url = "#{GOOGLE_MAPS_API_ENDPOINT}/directions/json?key=#{app_key}&origin=#{Address.to_url_param(@full_name)}&mode=walking&destination=#{metro[:coordinates]}"
      response = JSON.parse(RestClient.get url)
      @metros[metro[:name]] = response['routes'].first['legs'].first['distance']['text'].split(' ').first
    end
    @metros
  end

  def closest_metro
    name = metros.keys.first
    min = metros[name].to_f

    metros.each do |key, value|
      if value.to_f < min
        name = key
        min = value.to_f
      end
    end

    {
      name: name,
      distance: min.to_s
    }
  end

  def metros_in_radius
    in_radius = []
    ::METROS.each do |metro|
      d = distance("#{@coordinates['lat']},#{@coordinates['lng']}", metro[:coordinates])
      in_radius << metro[:name] if d <= RADIUS
    end
    in_radius
  end

  def distance(point1, point2)
    loc1 = point1.split(',').map &:to_f
    loc2 = point2.split(',').map &:to_f
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    (rm * c).to_f / 1000 # Delta in meters
  end

end
