class AddSchoolToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :schoolname, :string
    add_column :users, :schoolyear, :integer
  end
end
