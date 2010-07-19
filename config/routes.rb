ActionController::Routing::Routes.draw do |map|
  map.open_id_complete '/session',
    :controller => "sessions", :action => "create",
    :requirements => { :method => :get }

  map.resources :sites, :moderatorships

  map.resources :monitorships

  map.resources :topics do |topic|
    topic.resources :posts
  end

  map.resources :posts, :collection => {:search => :get}
  map.resources :users, :member => { :suspend   => :put,
                                     :settings  => :get,
                                     :make_admin => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :has_many => [:posts]

  map.upvote 'posts/:id/upvote', :controller => "votes", :action => "upvote"
  map.downvote 'posts/:id/downvote', :controller => "votes", :action => "downvote"

  map.activate '/activate/:activation_code',       :controller => 'users',    :action => 'activate', :activation_code => nil
  map.signup   '/signup',                          :controller => 'users',    :action => 'new'
  map.state   '/state',                            :controller => 'users',    :action => 'update_state'
  map.login    '/login',                           :controller => 'sessions', :action => 'new'
  map.logout   '/logout',                          :controller => 'sessions', :action => 'destroy'
  map.resend_confirmation_mail '/resend_confirmation_mail', :controller => 'users', :action => 'resend_confirmation_mail'
  map.lost_password '/lost_password',               :controller => 'users',    :action => 'remember_password'
  map.reset_password_confirmation '/reset_password',            :controller => 'users',    :action => 'reset_password_confirmation', :conditions => { :method => :post }
  map.reset_password '/reset_password/:secret',    :controller => 'users',    :action => 'reset_password', :conditions => { :method => :get }
  map.settings '/settings',                        :controller => 'users',    :action => 'settings'
  map.resource  :session                           
  map.about     '/about',                          :controller => 'about',    :action => 'show'
                                                   
  map.tag       '/tag/:tag_name',                  :controller => 'tags',     :action => 'search'

  map.with_options :controller => 'posts', :action => 'monitored' do |map|
    map.formatted_monitored_posts 'users/:user_id/monitored.:format'
    map.monitored_posts           'users/:user_id/monitored'
  end

  map.show_all "forums/all", :controller => "forums", :action => "show_all"
  map.hide_downvoted "forums/voted", :controller => "forums", :action => "hide_downvoted"

  map.root :controller => :forums, :action => :show, :id => "arquitetura"
end
