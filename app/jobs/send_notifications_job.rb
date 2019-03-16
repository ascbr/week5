class SendNotificationsJob < ApplicationJob
    queue_as :default
    def perform(product)
      StockProductMailer.send_notification_mail(product).deliver_now
    end
end