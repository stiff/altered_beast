class Moderatorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum

  validates :user_id, :forum_id, :presence => true
  validate :uniqueness_of_relationship
  validate :user_and_forum_in_same_site

  protected

    def uniqueness_of_relationship
      if self.class.exists?(:user_id => user_id, :forum_id => forum_id)
        errors.add(:base, "Cannot add duplicate user/forum relation")
      end
    end

    def user_and_forum_in_same_site
      if user && forum && user.site_id != forum.site_id
        errors.add(:base, "User and Forum must be in the same Site")
      end
    end
end
