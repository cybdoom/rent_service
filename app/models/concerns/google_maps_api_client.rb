require 'rest-client'

module GoogleMapsApiClient
  extend ActiveSupport::Concern

  GOOGLE_MAPS_API_ENDPOINT = 'https://maps.googleapis.com/maps/api'
  STATIC_MAP_SIZE = '400x400'

  def get_coordinates
    url = "#{GOOGLE_MAPS_API_ENDPOINT}/geocode/json?#{@address.to_params}"
    JSON.parse(RestClient.get url).body['results']['geometry']['location']
  end

  def location_map_url
    url = "#{GOOGLE_MAPS_API_ENDPOINT}/staticmap?#{{center: @address.to_s}.to_query}&size=#{STATIC_MAP_SIZE}"
    RestClient.get(url).body
  end

end
