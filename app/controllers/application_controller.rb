class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def username_list(param)
    (param or '').split(%r{[,\s]+})
  end
end
