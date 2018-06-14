class InfoController < ApplicationController

  def show
    @address = Address.new params.permit(:address)[:address]

    puts @address.info
    render json: @address.info
  end

end
