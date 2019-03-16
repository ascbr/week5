class StockProductMailer < ApplicationMailer
    def send_notification_mail(product)
        @product = product
        @user =  product.likes.order(:created_at).last.user
        attachments['image.jpg'] = File.read(
            ActiveStorage::Blob.service.send(
                :path_for, @product.image.key)
                ) if @product.image.attached?
        mail(to: @user.email, subject: "Get your #{@product.name}")
    end
end
