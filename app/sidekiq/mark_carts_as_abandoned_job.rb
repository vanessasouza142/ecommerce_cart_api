class MarkCartsAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.find_each(&:mark_as_abandoned)
  end
end
