class Purchase < ApplicationRecord
  belongs_to :user
  validates_presence_of :move_out_location, :move_in_location,
                        :move_out_room, :move_in_room, :move_out_date,
                        :move_in_date
  attr_accessor :ui_stripe_token

  def build_stripe_customer(params)
    begin
      purchase_params = params["purchase"]
      # Get the payment token ID submitted by the form:
      customer = Stripe::Customer.create(
        :email  => params[:email],
        :source => purchase_params[:ui_stripe_token]
      )
      # Charge the Customer instead of the card:
      charge = Stripe::Charge.create(
        :amount => purchase_params[:amount] || 1000,
        :currency => "usd",
        :description  => params[:email],
        :customer => customer.id,
      )
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card."
      false
    end
    self.stripe_token = customer.id
  end
end
