class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def get_category_and_date_range
    @category = params[:category]
    @start_range = if params[:start_range].present? then
                     Date.strptime(params[:start_range], '%m/%d/%Y')
                   else
                     Date.today - 3.months
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
end
