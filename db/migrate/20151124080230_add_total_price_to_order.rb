class AddTotalPriceToOrder < ActiveRecord::Migration
  def up
    add_column :orders, :price, :decimal, :precision => 8, :scale => 2

    say_with_time "Updating prices..." do
      price = 0
      Order.find_each do |order|
	      LineItem.where(order_id: order.id).each do |lineitem|
	        price += lineitem.product.price*lineitem.quantity
	      end
	       order.update_attribute :price, price
	       price = 0
	   end
    end

  end

  def down
    remove_column :orders, :price, :decimal, :precision => 8, :scale => 2
  end
end
