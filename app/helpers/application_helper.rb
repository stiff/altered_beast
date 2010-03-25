require 'md5'
module ApplicationHelper
	#def forum_posts_path(forum, options = {})
	#	super(Forum.first, options)
	#end
  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('feed-icon.png', :size => '14x14', :alt => "Subscribe to #{title}"), url
  end

  def pagination(collection)
    if collection.total_entries > 1
      "<p class='pages'>" + I18n.t('txt.pages', :default => 'Pages') + ": <strong>" +
      will_paginate(collection, :inner_window => 10, :next_label => I18n.t('txt.page_next', :default => 'next'), :prev_label => I18n.t('txt.page_prev', :default => 'previous')) +
      "</strong></p>"
    end
  end

  def next_page(collection)
    unless collection.current_page == collection.total_entries or collection.total_entries == 0
      "<p style='float:right;'>" + link_to(I18n.t('txt.next_page', :default => 'next page'), { :page => collection.current_page.next }.merge(params.reject{|k,v| k=="page"})) + "</p>"
    end
  end

  def search_posts_title
    returning(params[:q].blank? ? I18n.t('txt.recent_posts', :default => 'Recent Posts') : I18n.t('txt.searching_for', :default => 'Searching for') + " '#{h params[:q]}'") do |title|
      title << " " + I18n.t('txt.by_user', :default => 'by {{user}}', :user => h(@user.display_name)) if @user
      title << " " + I18n.t('txt.in_forum', :default => 'in {{forum}}', :forum => h(@forum.name)) if @forum
    end
  end

  def topic_title_link(topic, options)
    if topic.title =~ /^\[([^\]]{1,15})\]((\s+)\w+.*)/
      "<span class='flag'>#{$1}</span>" +
      link_to(h($2.strip), forum_topic_path(@forum, topic), options)
    else
      link_to(h(topic.title), forum_topic_path(@forum, topic), options)
    end
  end

  def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end

  def avatar_for(user, size=32)
    image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.md5(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
  end

  def search_path(atom = false)
    options = params[:q].blank? ? {} : {:q => params[:q]}
    prefix =
      if @topic
        options.update :topic_id => @topic, :forum_id => @forum
        :forum_topic
      elsif @forum
        options.update :forum_id => @forum
        :forum
      elsif @user
        options.update :user_id => @user
        :user
      else
        :search
      end
    atom ? send("#{prefix}_posts_path", options.update(:format => :atom)) : send("#{prefix}_posts_path", options)
  end

  def for_moderators_of(record, &block)
    moderator_of?(record) && concat(capture(&block))
  end

  def display_linked_tags(topic)
    topic.tag_list.map{|t| link_to("##{t}", tag_path(t))}.join(" ")
  end

  def display_tags(topic)
    topic.tag_list.map{|t| "##{t}"}.join(" ")
  end

  # i18n do will_paginate

  include WillPaginate::ViewHelpers

  def will_paginate_with_i18n(collection, options = {})
    will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next)))
  end

  alias_method_chain :will_paginate, :i18n

  # /i18n

  # PATH

  include PathHelper

  # /PATH

end
