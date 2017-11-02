class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def get_category_and_date_range
    @category = params[:category]
    @start_range = if params[:start_range].present? then
                     Date.strptime(params[:start_range], '%m/%d/%Y')
                   else
                     Date.today - 1.year
                   end
    @end_range = if params[:end_range].present? then
                   Date.strptime(params[:end_range], '%m/%d/%Y')
                 else
                   Date.today
                 end.end_of_day
  end

  def username_list(param)
    (param or '').split(%r{[,\s]+})
  end

  def send_file_from_twgb_host(path, filename)
    hostname = Rails.application.config.twgb_host_hostname
    username = Rails.application.config.twgb_host_username
    pathname = Rails.application.config.twgb_host_pathname
    ssh_key = Rails.application.config.twgb_host_ssh_key

    full_pathname = pathname + path + filename
    data = nil

    begin
      Net::SCP.start hostname, username, key_data: [ssh_key], keys_only: true do |scp|
        data = scp.download! full_pathname
      end
    rescue Net::SCP::Error => e
      if e.message.include? 'No such file or directory'
        raise ActionController::RoutingError.new('Replay expired')
      end
      raise e
    end

    p 'got data'

    send_data data, filename: filename, disposition: :attachment
  end
end
