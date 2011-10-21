# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Building.create(
 [{:building_name => "Arend",           :capacity => 170, :occupants => 0, :abbreviation => "arh", :area => 36900},
  {:building_name => "Baldwin Jenkins", :capacity => 164, :occupants => 0, :abbreviation => "bjs", :area => 39900},
  {:building_name => "Ballard",         :capacity => 66,  :occupants => 0, :abbreviation => "bah", :area => 14490},
  {:building_name => "Boppell",         :capacity => 84,  :occupants => 0, :abbreviation => "boh", :area => 29467},
  {:building_name => "Cornerstone",     :capacity => 24,  :occupants => 0, :abbreviation => "cos", :area => 17086},
  {:building_name => "Duvall",          :capacity => 162, :occupants => 0, :abbreviation => "duh", :area => 47755},
  {:building_name => "East",            :capacity => 170, :occupants => 0, :abbreviation => "eah", :area => 40885},
  {:building_name => "McMillan",        :capacity => 85,  :occupants => 0, :abbreviation => "mmh", :area => 20738},
  {:building_name => "The Village",     :capacity => 60,  :occupants => 0, :abbreviation => "thv", :area => 14040},
  {:building_name => "Stewart",         :capacity => 74,  :occupants => 0, :abbreviation => "sth", :area => 16750},
  {:building_name => "Warren",          :capacity => 227, :occupants => 0, :abbreviation => "wah", :area => 49400}])

User.create(:name => "admin", :password => "password")
