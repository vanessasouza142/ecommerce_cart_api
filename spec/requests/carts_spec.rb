require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:cart) { Cart.create }
  let(:product) { Product.create(name: "Test Product", price: 10.0) }
  let!(:cart_product) { CartProduct.create(cart: cart, product: product, quantity: 1) }

  describe "GET /show" do
    it "renders a successful response" do
      get cart_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "adds a product in the cart" do
        expect {
          post cart_url,
            params: { product_id: product.id, quantity: 1 }, as: :json
        }.to change(CartProduct, :count).by(1)
      end

      it "renders a successful response with cart products" do
        post cart_url,
          params: { product_id: product.id, quantity: 1 }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not add a product in the cart" do
        expect {
          post cart_url,
            params: { product_id: product.id, quantity: -2 }, as: :json
        }.to change(CartProduct, :count).by(0)
      end

      it "renders a JSON response with errors for the product in the cart" do
        post cart_url,
          params: { product_id: product.id, quantity: -2 }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "POST /cart/add_item" do
    context 'when the product already is in the cart' do
      before do
        post cart_url,
          params: { product_id: product.id, quantity: 1 }, as: :json
      end

      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { CartProduct.last.reload.quantity }.from(1).to(2)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      post cart_url,
        params: { product_id: product.id, quantity: 1 }, as: :json
    end

    it "destroys the requested product in the cart" do
      expect {
        delete "/cart/#{product.id}", as: :json
      }.to change(CartProduct, :count).by(-1)
    end
  end
end
