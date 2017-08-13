class RemoveParentphonenumberFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :parentphonenumber, :integer
  end
end
