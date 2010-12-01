module ModelStubbing
  define_models do
    time 2007, 6, 15

    model Site do
      stub :name => 'default', :host => '', :created_at => current_time - 5.years
    end

    model Local do
      stub :name => "Guaratingueta-SP", :created_at => current_time - 5.days,
      :city => "Guaratingueta", :states => "SP"
    end

    model CompanySize do
     stub :description => "1-10"
   end

    model Responsability do
      stub :description => "P.O."
    end

    model User do
      stub :login => 'normal-user', :email => 'normal-user@example.com', :state => 'active',
        :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
        :created_at => current_time - 5.days, :site => all_stubs(:site), :remember_token => 'foo-bar', :remember_token_expires_at => current_time + 5.days,
        :activation_code => '8f24789ae988411ccf33ab0c30fe9106fab32e9b', :activated_at => current_time - 4.days, :posts_count => 3, :permalink => 'normal-user',
        :local => all_stubs(:local), :working_since => 2000, :signature => 'Programmer', :signature_html => '<p>Programmer</p>'

      stub :activated, :login => 'activated-user', :email => 'activated-user@example.com', :state => 'active',
        :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
        :created_at => current_time - 5.days, :site => all_stubs(:site), :remember_token => 'foo-bar-activated', :remember_token_expires_at => current_time + 5.days,
        :activation_code => nil, :activated_at => current_time - 4.days, :posts_count => 3, :permalink => 'activated-user', :local => all_stubs(:local), :working_since => 2000,
        :signature => 'Programmer', :signature_html => '<p>Programmer</p>', :position => "CIO"
        
      stub :admin,     :login => 'admin-user',     :email => 'admin-user@example.com', :remember_token => 'blah', :admin => true, :state => 'active', :activated_at => current_time - 4.days, :signature => 'Programmer', :signature_html => '<p>Programmer</p>'
    end

    model Forum do
      stub :name => "Default", :topics_count => 2, :posts_count => 2, :position => 1, :state => 'public', :site => all_stubs(:site), :permalink => 'default'
      stub :other, :name => "Other", :topics_count => 1, :posts_count => 1, :position => 0, :permalink => 'other'
    end

    model Topic do
      stub :forum => all_stubs(:forum), :user => all_stubs(:user), :title => "initial", :hits => 0, :sticky => 0, :posts_count => 1,
        :last_post_id => 1000, :last_updated_at => current_time - 5.days, :site => all_stubs(:site), :permalink => 'initial', :created_at => current_time - 3.years
      stub :other, :title => "Other", :last_updated_at => current_time - 4.days, :permalink => 'other'
      stub :other_forum, :forum => all_stubs(:other_forum)
    end

    model Post do
      stub :topic => all_stubs(:topic), :forum => all_stubs(:forum), :user => all_stubs(:user), :body => 'initial', :created_at => current_time - 5.days, :updated_at => current_time - 5.days, :site => all_stubs(:site)
      stub :other, :topic => all_stubs(:other_topic), :body => 'other', :created_at => current_time - 13.days
      stub :other_forum, :forum => all_stubs(:other_forum), :topic => all_stubs(:other_forum_topic)
    end

    model Moderatorship do
      stub :user => all_stubs(:user), :forum => all_stubs(:other_forum)
    end
    model Monitorship
  end

  define_models :users do
    model User do
      stub :admin,     :login => 'admin-user',     :email => 'admin-user@example.com', :remember_token => 'blah', :admin => true, :signature => 'Programmer', :signature_html => '<p>Programmer</p>'
      stub :pending,   :login => 'pending-user',   :email => 'pending-user@example.com',   :state => 'pending', :activated_at => nil, :remember_token => 'asdf', :signature => 'Programmer', :signature_html => '<p>Programmer</p>'
      stub :suspended, :login => 'suspended-user', :email => 'suspended-user@example.com', :state => 'suspended', :remember_token => 'dfdfd', :signature => 'Programmer', :signature_html => '<p>Programmer</p>'
    end
  end

  define_models :moderators do
    model User do
      stub :other, :login => 'other-user', :email => '@example.com', :signature => 'Programmer', :signature_html => '<p>Programmer</p>'
    end

    model Moderatorship do
      stub :user => all_stubs(:user), :forum => all_stubs(:forum)
      stub :default_other, :user => all_stubs(:user), :forum => all_stubs(:other_forum)
      stub :other_default, :user => all_stubs(:other_user)
    end
  end

  define_models :monitorships do
    model Monitorship do
      stub :user => all_stubs(:user), :topic => all_stubs(:topic), :active => true
      stub :inactive, :user => all_stubs(:user), :topic => all_stubs(:other_topic), :active => false
    end
  end

  define_models :sites_controller do
    model Site do
      stub :other, :name => 'other', :host => 'other.test.host'
      stub :new, :name => 'new site', :host => 'new.test.host'
    end
  end
end
