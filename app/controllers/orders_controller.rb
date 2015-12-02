class PostmanWorker
  include Sidekiq::Worker
    sidekiq_options :queue => :mailer
  def perform(order, h)
    h = JSON.load(h)
    OrderNotifier.received(order, h).deliver_now
  end
end

class OrdersController < ApplicationController
 skip_before_action :authorize, only: [:new, :create]
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
  if @cart.line_items.empty?
        redirect_to store_url, notice: "Ваша корзина пуста."
        return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)
    @order.add_order_price(@cart,@order)
    respond_to do |format|
      if @order.save
            Cart.destroy(session[:cart_id])
            session[:cart_id] = nil
            h = JSON.generate({ 'name' => @order.name,
                        'email' => @order.email,
                        'message' => @order.address })

            PostmanWorker.perform_async(@order,h)
           # OrderNotifier.received(@order).deliver_now
            format.html { redirect_to store_url, notice: I18n.t('.thanks') }      
            format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end
