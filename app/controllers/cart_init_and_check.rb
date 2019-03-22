module CartInitAndCheck
      
  def check_session_kart
    unless session[:kart].present? || !session[:kart].nil?
      delete_nil_orders
      if current_user
        purchase = Purchase.find_by_user_in_progress(current_user).first
        if !purchase.nil?
            session[:kart] = purchase.id
        else
            purchase = Purchase.new
            purchase.state = 'in_progress'
            purchase.user = current_user
            purchase.save
            session[:kart] = Purchase.last.id
        end
      else
        purchase = Purchase.new
        purchase.state = 'in_progress'
        purchase.save
        session[:kart] = Purchase.last.id
      end
      session[:first_interaction] = current_user.nil?
    end
  end
    
  def check_change_user
    if session[:first_interaction] != current_user.nil?
      if current_user
        purchase = Purchase.find_by_user_in_progress(current_user).first
        if purchase
          purchase_send = Purchase.find(session[:kart])
          add_orders_to_purchase(purchase_send, purchase)
          session[:kart] = purchase.id
        else
          purchase = Purchase.find(session[:kart])
          purchase.user = current_user
          purchase.save
        end
      else
        session[:kart] = nil
        delete_nil_orders
      end
        session[:first_interaction] = current_user.nil?
    end
  end
    
  def delete_nil_orders
    karts = Purchase.where(user_id: nil)
    karts&.each do |k|
      k.orders.each(&:destroy)
      k.destroy
     end
   end
    
  def add_orders_to_purchase(purchase_send, purchase_recive)
    purchase_send.orders.each do |o|
      o.purchase = purchase_recive
      o.save
    end
    purchase_send.destroy
  end

end