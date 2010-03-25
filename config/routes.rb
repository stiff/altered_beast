ActionController::Routing::Routes.draw do |map|
  map.open_id_complete '/session',
    :controller => "sessions", :action => "create",
    :requirements => { :method => :get }

  map.resources :sites, :moderatorships, :monitorship

  map.resources :topics do |topic|
    topic.resources :posts
    topic.resource :monitorship
  end

  map.resources :posts, :collection => {:search => :get}
  map.resources :users, :member => { :suspend   => :put,
                                     :settings  => :get,
                                     :make_admin => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :has_many => [:posts]

  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  map.settings '/settings',                  :controller => 'users',    :action => 'settings'
  map.resource  :session

  map.tag       '/tag/:tag_name',            :controller => 'tags',     :action => 'search'

  map.with_options :controller => 'posts', :action => 'monitored' do |map|
    map.formatted_monitored_posts 'users/:user_id/monitored.:format'
    map.monitored_posts           'users/:user_id/monitored'
  end

  map.root :controller => :forums, :action => :show, :id => "arquitetura"

end
