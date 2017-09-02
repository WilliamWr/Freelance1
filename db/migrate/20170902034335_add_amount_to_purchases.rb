class AddAmountToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :amount, :decimal
  end
end
