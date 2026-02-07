class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_not_found(error)
    render json: { error: error.model, message: "#{error.model} not found" }, status: :not_found
  end

  def record_invalid(exception)
    first_error = exception.record.errors.full_messages.first
    render json: { error: exception.record.class.name, message: first_error }, status: :unprocessable_entity
  end
end
