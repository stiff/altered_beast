class PostsSweeper < ActionController::Caching::Sweeper
  observe Post
  
  def after_save(post)
    FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'posts.atom')
  end
  
end