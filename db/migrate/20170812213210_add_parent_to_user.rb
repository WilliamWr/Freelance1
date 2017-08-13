class AddParentToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :parentfirstname, :string
    add_column :users, :parentmiddleinitial, :string
    add_column :users, :parentlastname, :string
    add_column :users, :parentemail, :string
    add_column :users, :parentphonenumber, :integer
  end
end
