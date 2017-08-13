class AddStudentphonenumberToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :studentphonenumber, :string
  end
end
