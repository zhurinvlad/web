class OrderNotifier < ApplicationMailer
default from: 'Google Support <support@gmail.com>'
  # Subject can be set in your I18n fil at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order, h)
    @order = order

    mail to: h['email'], subject: 'Подтверждение заказа в Vlad Store'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject
  #
  def shipped(order)
   @order = order

    mail to: order.email, subject: 'Подтверждение заказа в Vlad Store'
  end
end
