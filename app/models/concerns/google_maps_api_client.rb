require 'rest-client'

module GoogleMapsApiClient
  extend ActiveSupport::Concern

  GOOGLE_MAPS_API_ENDPOINT = 'https://maps.googleapis.com/maps/api'
  STATIC_MAP_SIZE = '600x600'

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
        response['routes'].first['legs'].first['distance']['text'].split(' ').first
      rescue
        nil
      end
    end

    result
  end

  def metros(points)
    return @metros if @metros.present?

    @metros = {}
    points.each do |point|
      url = "#{GOOGLE_MAPS_API_ENDPOINT}/directions/json?key=#{app_key}&origin=#{Address.to_url_param(@full_name)}&mode=walking&destination=#{point}"
      response = JSON.parse(RestClient.get url)
      @metros[point] = response['routes'].first['legs'].first['distance']['text'].split(' ').first
    end
    @metros
  end

  def closest_metro(points)
    min = metros(points).first.last.to_f
    place = metros(points).first.first

    metros(points).each do |key, value|
      place = key
      min = value.to_f if value.to_f < min
    end

    {
      location: place,
      distance: min.to_s
    }
  end

end
