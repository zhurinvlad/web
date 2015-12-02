class StoreController < ApplicationController
   skip_before_action :authorize
    include CurrentCart
    before_action :set_cart
  def index
  	if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
  	@count = count_index
    @counttext = "#{@count} просматривают в текущий момент"
  end
  def count_index
  		if session[:couner].nil?
  		   session[:couner] = 0  
  		end
  		session[:couner] += 1   	
  end
end
