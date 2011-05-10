class Site < ActiveRecord::Base
  class UndefinedError < StandardError; end

  has_many :users, :conditions => {:state => 'active'}
  has_many :all_users, :class_name => 'User'

  has_many :forums
  has_many :topics, :through => :forums
  has_many :posts,  :through => :forums

  validates_presence_of   :name
  validates_uniqueness_of :host

  attr_readonly :posts_count, :users_count, :topics_count

  class << self

    def main
      @main ||= where(:host => '').first
    end

    def find_by_host(name)
      return nil if name.nil?
      name.downcase! && name.strip! && name.sub!(/^www\./, '')
      sites = where('host = ? or host = ?', name, '')
      sites.reject(&:default?).first || sites.first
    end

  end

  def host=(value)
    write_attribute(:host, value.to_s.downcase)
  end

  # <3 rspec
  def ordered_forums(*args)
    forums.ordered(*args)
  end

  def default?
    host.blank?
  end

  def to_s
    name
  end
end
