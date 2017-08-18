class Purchase < ApplicationRecord
  belongs_to :user
  validates_presence_of :move_out_location, :move_in_location, :move_out_room, :move_in_room, :move_out_date, :move_in_date
end
