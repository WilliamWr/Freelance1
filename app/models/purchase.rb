class Purchase < ApplicationRecord
  belongs_to :user
  validates_presence_of :move_out_location, :move_in_location,
                        :move_out_room, :move_in_room, :move_out_date,
                        :move_in_date
  attr_accessor :ui_stripe_token
  before_create :build_stripe_customer

  def build_stripe_customer()
    charge = Stripe::Charge.create(
      :amount => self.amount || 2000,
      :currency => "usd",
      :description => "Charge for #{self.user.email}",
      :source => self.ui_stripe_token
    )
    self.stripe_token = charge.id
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]
      # raise "#{err[:message]}"
       # errors[:base] << "This donation is invalid because #{e}"
      self.errors.add(:base, err[:message])
      # return false
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      self.errors.add :base, "There was a problem with your credit card."
      return false
  end
end
