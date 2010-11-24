class Topic < ActiveRecord::Base
  include User::Editable

  acts_as_taggable

  before_validation_on_create :set_default_attributes
  validates_presence_of :title

  after_create   :after_create_handler
  before_update  :check_for_moved_forum
  after_update   :set_post_forum_id
  before_destroy :count_user_posts_for_counter_cache
  after_destroy  :update_cached_forum_and_user_counts

  # creator of forum topic
  belongs_to :user

  # creator of recent post
  belongs_to :last_user, :class_name => "User"

  belongs_to :forum, :counter_cache => true

  # forum's site, set by callback
  belongs_to :site, :counter_cache => true

  has_many :posts,       :order => "#{Post.table_name}.created_at", :dependent => :delete_all
  has_one  :recent_post, :order => "#{Post.table_name}.created_at DESC", :class_name => "Post"

  has_many :voices, :through => :posts, :source => :user, :uniq => true

  has_many :monitorships, :dependent => :delete_all
  has_many :monitoring_users, :through => :monitorships, :source => :user, :conditions => {"#{Monitorship.table_name}.active" => true}
  
  has_many :views, :dependent => :delete_all
  
  validates_presence_of :user_id, :site_id, :forum_id, :title
  validates_presence_of :body, :on => :create

  attr_accessor :body
  attr_accessible :title, :body, :score

  attr_readonly :posts_count, :hits, :my_permalink

  has_permalink :nice_permalink, :scope => :forum_id

  def nice_permalink
    title.parameterize.tr '-','_' if title
  end

  def to_s
    title
  end

  def sticky?
    sticky == 1
  end

  def hit!
    View.create(:topic_id => self.id)
    self.class.increment_counter :hits, id
  end

  def paged?
    posts_count > Post.per_page
  end

  def self.per_page
    20
  end

  def last_page
    [(posts_count.to_f / Post.per_page.to_f).ceil.to_i, 1].max
  end

  def update_cached_post_fields(post)
    # these fields are not accessible to mass assignment
    if remaining_post = post.frozen? ? recent_post : post
      self.class.update_all(['last_updated_at = ?, last_user_id = ?, last_post_id = ?, posts_count = ?',
        remaining_post.created_at, remaining_post.user_id, remaining_post.id, posts.count], ['id = ?', id])
    else
      destroy
    end
  end

  def to_param
   permalink
  end
  
  def self.send_hottest_topics_to_gui()
    UserMailer.deliver_hottest_topics("pedro.matiello@caelum.com.br",
                                      Topic.top_hottest_since(15.days.ago),
                                      User.recent_and_silent)
  end
  
  def self.top_hottest_since(date, max = 10)
    views = View.find(:all, :select => 'topic_id, count(topic_id) as count', :group => 'topic_id', :conditions => ['created_at >= ?', date], :order => 'count DESC', :limit => max)
    ids = views.map{|topic| topic.topic_id}
    Topic.find(ids)
  end
  

protected
  def after_create_handler
      create_initial_post
      create_monitorships
  end

  def create_monitorships
    Monitorship.create!(:topic_id => id, :user_id => user.id)
  end

  def create_initial_post
    user.reply self, @body #unless locked?
    @body = nil
  end

  def set_default_attributes
    self.site_id           = forum.site_id if forum_id
    self.sticky          ||= 0
    self.last_updated_at ||= Time.now.utc
  end

  def check_for_moved_forum
    old = Topic.find(id)
    @old_forum_id = old.forum_id if old.forum_id != forum_id
    true
  end

  def set_post_forum_id
    return unless @old_forum_id
    posts.update_all :forum_id => forum_id
    Forum.update_all "posts_count = posts_count - #{posts_count}", ['id = ?', @old_forum_id]
    Forum.update_all "posts_count = posts_count + #{posts_count}", ['id = ?', forum_id]
  end

  def count_user_posts_for_counter_cache
    @user_posts = posts.group_by { |p| p.user_id }
  end

  def update_cached_forum_and_user_counts
    Forum.update_all "posts_count = posts_count - #{posts_count}", ['id = ?', forum_id]
    Site.update_all  "posts_count = posts_count - #{posts_count}", ['id = ?', site_id]
    @user_posts.each do |user_id, posts|
      User.update_all "posts_count = posts_count - #{posts.size}", ['id = ?', user_id]
    end
  end
end