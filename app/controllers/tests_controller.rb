class TestsController < ApplicationController

  def data
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: File.read(Rails.root.join('public/data.json'))
  end

end
