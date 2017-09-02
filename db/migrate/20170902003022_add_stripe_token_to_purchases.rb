class AddStripeTokenToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :stripe_token, :string
  end
end
