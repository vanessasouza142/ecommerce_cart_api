class CartsController < ApplicationController
  before_action :set_session_cart, only: %i[ show create add_item destroy]
  before_action :find_product, only: %i[create add_item destroy]
  before_action :find_cart_product, only: %i[add_item destroy]

  # GET /cart
  def show
    render json: cart_payload(@cart), status: :ok
  end

  # POST /cart
  def create
    cart_product = @cart.cart_products.find_or_initialize_by(product: @product)
    cart_product.quantity = cart_params[:quantity]

    cart_product.save!
    render json: cart_payload(@cart), status: :created
  end

  # PATCH /cart/add_item
  def add_item
    @cart_product.update!(quantity: @cart_product.quantity + cart_params[:quantity])
    render json: cart_payload(@cart), status: :ok
  end

  # DELETE /cart/1
  def destroy
    @cart_product.destroy
    render json: cart_payload(@cart)
  end
  
  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def set_session_cart
    @cart = Cart.find_by(id: session[:cart_id]) || create_cart
  end

  def create_cart
    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end

  def find_product
    @product = Product.find(cart_params[:product_id])
  end

  def find_cart_product
    @cart_product = @cart.cart_products.find_by!(product: @product)
  end

  def cart_payload(cart)
    {
      id: cart.id,
      products: cart.cart_products.includes(:product).map do |cp|
        {
          id: cp.product.id,
          name: cp.product.name,
          quantity: cp.quantity,
          unit_price: cp.product.price.to_f,
          total_price: cp.total_price.to_f
        }
      end,
      total_price: cart.total_price.to_f
    }
  end
end