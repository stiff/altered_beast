class Vote < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :value, :post_id, :user_id
  validates_uniqueness_of :user_id, :scope => :post_id
end