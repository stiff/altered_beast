module PathHelper

  def forum_posts_path(forum, *args)
    posts_path(*args)
  end

  def new_forum_topic_path(forum, *args)
    new_topic_path(*args)
  end

  def forum_topic_path(*args)
    topic_path(*args)
  end

  def forum_path(forum, *args)
    root_path
  end

  def formatted_forum_topic_posts_path(forum, *args)
    topic_posts_path(*args)
  end

  def forum_topic_posts_path(forum, *args)
    topic_posts_path(*args)
  end

  def forum_topics_path(forum, *args)
    topics_path(*args)
  end

  def edit_forum_topic_path(forum, *args)
    edit_topic_path(*args)
  end

  def edit_forum_topic_post_path(forum, *args)
    edit_topic_post_path(*args)
  end

  def forum_topic_post_path(forum, *args)
    topic_post_path(*args)
  end

  def forum_topic_post_url(forum, *args)
    topic_post_url(*args)
  end

  def forum_topic_url(forum, *args)
    topic_url(*args)
  end

  def forum_url(*args)
    root_url
  end

end