require 'rest-client'

module GoogleMapsApiClient
  extend ActiveSupport::Concern

  GOOGLE_MAPS_API_ENDPOINT = 'https://maps.googleapis.com/maps/api'
  STATIC_MAP_SIZE = '400x400'

  def get_coordinates
    url = "#{GOOGLE_MAPS_API_ENDPOINT}/geocode/json?key=#{app_key}&#{self.to_params}"
    JSON.parse(RestClient.get url)['results'].first['geometry']['location']
  end

  def location_map_url
    "#{GOOGLE_MAPS_API_ENDPOINT}/staticmap?key=#{app_key}&#{{center: @full_name}.to_query}&size=#{STATIC_MAP_SIZE}&zoom=15&markers=size:mid%7C#{Address.to_url_param(@full_name)}"
  end

  def app_key
    'AIzaSyCLyopNQLnHRYPFx9RlE55xdtNiRRTmHME'
  end

  def directions(places)
    result = {}
    places.each do |place|
      url = "#{GOOGLE_MAPS_API_ENDPOINT}/directions/json?key=#{app_key}&origin=#{Address.to_url_param(@full_name)}&mode=walking&destination=#{place}"
      response = JSON.parse(RestClient.get url)
      result[place] = begin
        response['routes'].first['legs'].first['distance']['text']
      rescue nil
      end
    end

    result
  end

end
