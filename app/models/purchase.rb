class Purchase < ApplicationRecord
  belongs_to :user
  validates_presence_of :move_out_location, :move_in_location,
                        :move_out_room, :move_in_room, :move_out_date,
                        :move_in_date, :amount
  attr_accessor :ui_stripe_token
  # before_save :build_stripe_customer

  def build_stripe_customer
    if valid?
      charge = Stripe::Charge.create(
        :amount => self.amount.to_i,
        :currency => "usd",
        :description => "Charge for #{self.user.email}",
        :source => self.ui_stripe_token
      )
      self.stripe_token = charge.id
      if self.registration_fee_paid == "0" || self.registration_fee_paid == true
        self.registration_fee_paid_date = DateTime.now.utc
      end
    end
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]
      # raise "#{err[:message]}"
       # errors[:base] << "This donation is invalid because #{e}"
       # logger.error err[:message]
      errors.add(:base, err[:message])
      return false
    rescue Stripe::InvalidRequestError => e
      logger.debug("========== #{amount}")
      if self.amount.to_i < 1
        self.errors.add :amount, " must be greate than 0."
        return false
      end
      # logger.error "Stripe error while creating customer: #{e.message}"
      body = e.json_body
      err  = body[:error]
      errors.add(:base, err[:message])
      # self.errors.add :base, "There was a problem with your credit card."
      return false
  end
end
