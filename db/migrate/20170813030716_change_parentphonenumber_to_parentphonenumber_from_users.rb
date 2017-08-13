class ChangeParentphonenumberToParentphonenumberFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :parentphonenumber, :string
  end
end
