class InfoController < ApplicationController

  def show
    @address = parse_address

    render json: @address.info.to_json
  end

  private

  def parse_address
    Address.new params.require(:address).permit(:city, :street_type, :street_name, :building)
  end

end
