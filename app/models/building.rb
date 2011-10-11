class Building < ActiveRecord::Base
  has_many :meter
  # TODO build up dependencies & stoff
end
