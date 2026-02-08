class RemoveAbandonedCartsJob
  include Sidekiq::Job

  def perform(*args)
    Cart.find_each(&:remove_if_abandoned)
  end
end
