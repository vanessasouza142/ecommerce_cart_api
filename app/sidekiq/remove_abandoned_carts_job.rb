class RemoveAbandonedCartsJob
  include Sidekiq::Job

  def perform(*args)
    Cart.all.each do |cart|
      if cart.abandoned && cart.abandoned_at < 7.days.ago
        cart.destroy
      end
    end 
  end
end
