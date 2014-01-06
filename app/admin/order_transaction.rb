ActiveAdmin.register OrderTransaction do
  index do
    column :success
    column 'Order Value' do |order_transaction|
      Cart.find(order_transaction.order.cart_id).total_price
    end
    column :message
    column :courses do |order_transaction|
      table_for order_transaction.order.cart.courses do
        column do |course|
          link_to course.name, [:admin, course]
        end
      end
    end
    column 'User' do |order_transaction|
      cart = order_transaction.order.cart
      user = User.find(cart.user_id)
      "#{user.first_name} #{user.last_name} (#{cart.user_id})"
    end
  end
end
