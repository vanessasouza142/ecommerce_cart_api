class MarkCartsAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.all.each do |cart|
      if !cart.abandoned && cart.updated_at < 3.hours.ago
        cart.update(abandoned: true, abandoned_at: Time.current)
      end
    end 
  end
end
