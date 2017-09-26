class MapsController < ApplicationController
  def download
    path = "Island Troll Tribes v#{params[:version]}.w3x"
    send_file_from_twgb_host 'maps/', path
  end
end
