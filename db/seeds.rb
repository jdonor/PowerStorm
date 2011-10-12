# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Building.create([{:building_name => "Arend", :occupants => 170},
                 {:building_name => "Baldwin Jenkins", :occupants => 164},
				 {:building_name => "Ballard", :occupants => 66},
				 {:building_name => "Boppell", :occupants => 84},
				 {:building_name => "Cornerstone", :occupants => 32},
				 {:building_name => "Duvall", :occupants => 162},
				 {:building_name => "East", :occupants => 170},
				 {:building_name => "McMillan", :occupants => 85},
				 {:building_name => "Stewart/Village", :occupants => 134},
				 {:building_name => "Warren", :occupants => 227}])

User.create(:name => "admin", :password => "password")
