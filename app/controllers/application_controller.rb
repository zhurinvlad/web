class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_i18n_locale_from_params
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_date
  def set_date
  	@time =Time.now.strftime("%I:%M:%S")
  end

  protected
	  def authorize
	    unless User.find_by(id: session[:user_id])
	    redirect_to login_url, notice: "Пожалуйста, пройдите авторизацию"
	    end
      end
  protected
	    def set_i18n_locale_from_params
			if params[:locale]
				if I18n.available_locales.map(&:to_s).include?(params[:locale])
					I18n.locale = params[:locale]
				else
					flash.now[:notice] = "#{params[:locale]} translation not available"
					# перевод недоступен
					logger.error flash.now[:notice]
				end
			end
		end

  def default_url_options
    { locale: I18n.locale }
  end

end


