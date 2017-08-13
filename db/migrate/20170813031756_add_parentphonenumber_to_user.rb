class AddParentphonenumberToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :parentphonenumber, :string
  end
end
