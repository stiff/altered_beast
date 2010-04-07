class Local < ActiveRecord::Base
  named_scope :states, :select => "distinct(states)", :order => "states"
end