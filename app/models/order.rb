class Order < ActiveRecord::Base
    has_many :line_items, dependent: :destroy
    PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
    validates :name, :address, :email, presence: true
    validates :pay_type, :inclusion => PaymentType.names
    def add_line_items_from_cart(cart)
        cart.line_items.each do |item|
            item.cart_id = nil
            line_items << item
        end
    end

    def add_order_price(cart,order)
        price = 0
        cart.line_items.each do |item|
          price += item.quantity * item.product.price
        end
        order.price = price
    end
end
