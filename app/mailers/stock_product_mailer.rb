class StockProductMailer < ApplicationMailer
    def send_notification_mail(product)
        @product = product
        @user =  product.likes.order(:created_at).last.user
        attachments['product.png'] = { mime_type: 'image/png', content: product.image.download } if product.image.attached?
        mail(to: @user.email, subject: "Get your #{@product.name}")
    end
end
