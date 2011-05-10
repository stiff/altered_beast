require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  define_models :users

  describe User, "being created" do
    define_models :users
  
    before do
      @creating_user = lambda do
        user = create_user
        violated "#{user.errors.full_messages.to_sentence}" if user.new_record?
      end
    end
  
    it 'logs in with openid' do
      u = sites(:default).users.new(:openid_url => 'http://foo', :email => 'zoe@girl.com')
      u.login = 'zoegirl'
      assert u.valid?, u.errors.inspect
    end

    it 'increments User.count' do
      @creating_user.should change(User, :count).by(1)
    end
  
    it 'increments Site#users_count' do
      @creating_user.should change { sites(:default).reload.users_count }.by(1)
    end
  end

  [:login, :password, :password_confirmation, :email, :site_id].each do |attr|
    it "requires #{attr}" do
      lambda do
        u = create_user attr => nil
        u.errors.on(attr).should_not be_nil
      end.should_not change(User, :count)
    end
  end
  
  it "formats User#bio" do
    u = User.new :bio => 'foo'
    u.bio_html.should be_nil
    u.send :format_attributes
    u.bio_html.should == '<p>foo</p>'
  end
  
  it "sets User#display_name from login if nil" do
    user = User.new :login => 'foo'
    user.display_name.should == user.login
  end
  
  it "#seen! sets #last_seen_at" do
    user = users(:default)
    user.last_seen_at.should be_nil
    user.seen!
    user.last_seen_at.should_not be_nil
  end

  it 'resets password' do
    users(:default).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    User.authenticate(users(:default).login, 'new password').should == users(:default)
  end

  it 'does not rehash password' do
    users(:default).update_attributes(:login => users(:default).login.reverse)
    User.authenticate(users(:default).login, 'test').should == users(:default)
  end

  it 'authenticates user' do
    User.authenticate(users(:default).login, 'test').should == users(:default)
  end

  it 'sets remember token' do
    users(:default).remember_me
    users(:default).remember_token.should_not be_nil
    users(:default).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    users(:default).remember_me
    users(:default).remember_token.should_not be_nil
    users(:default).forget_me
    users(:default).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    users(:default).remember_me_for 1.week
    after = 1.week.from_now.utc
    users(:default).remember_token.should_not be_nil
    users(:default).remember_token_expires_at.should_not be_nil
    users(:default).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    users(:default).remember_me_until time
    users(:default).remember_token.should_not be_nil
    users(:default).remember_token_expires_at.should_not be_nil
    users(:default).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    users(:default).remember_me
    after = 2.weeks.from_now.utc
    users(:default).remember_token.should_not be_nil
    users(:default).remember_token_expires_at.should_not be_nil
    users(:default).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'suspends user' do
    users(:default).suspend!
    users(:default).should be_suspended
  end

  it 'does not authenticate suspended user' do
    users(:default).suspend!
    User.authenticate('quentin', 'test').should_not == users(:default)
  end

  it 'unsuspends user' do
    users(:suspended).unsuspend!
    users(:suspended).should be_active
  end

  it 'deletes user' do
    users(:default).deleted_at.should be_nil
    users(:default).delete!
    users(:default).deleted_at.should_not be_nil
    users(:default).should be_deleted
  end

  it 'finds currently online users' do
    user = users(:default)
    user.seen!
    User.online.find_by_id(user.id).should_not be_nil
  end

  protected

    def create_user(options = {})
      User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'monkey', :password_confirmation => 'monkey' }.merge(options)).tap do |u|
        u.site_id = options.key?(:site_id) ? options[:site_id] : sites(:default).id
        u.save
      end
    end
end

describe User, "being deleted" do
  define_models :users

  before do
    @deleting_user = lambda { users(:default).destroy }
  end

  it 'decrements User.count' do
    @deleting_user.should change(User, :count).by(-1)
  end

  it 'decrements Site#users_count' do
    @deleting_user.should change { sites(:default).reload.users_count }.by(-1)
  end
end

describe User, "with no created users" do
  define_models :copy => false do
    model User
  end

  def make_user(site, login, email)
    user = User.new :login => login, :email => email, :password => 'monkey', :password_confirmation => 'monkey'
    user.site_id = site.id
    # user.stub!(:site).and_return @site
    user.save!
    user
  end
  
  it 'creates initial user as an admin' do
    site = Site.create! :name => "xfoo", :host => "xsite1.com"
    user = make_user(site, 'quire', 'quire@example.com')
    user.should be_admin
  end
  
  it 'creates initial user as admin for each site' do
    site = Site.create! :name => "foo", :host => "site1.com"

    user1 = make_user(site, 'quire1', 'quire@example1.com')
    user1.should be_admin

    user2 = make_user(site, 'quire2', 'quire@example2.com')
    user2.should_not be_admin

    site2 = Site.create! :name => "bar", :host => "site2.com"
    user3 = make_user(site2, 'quire3', 'quire@example3.com')
    user3.should be_admin
  end
end
