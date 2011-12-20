require 'digest/md5'
module ApplicationHelper
  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('feed-icon.png', :size => '14x14', :alt => I18n.t('txt.subscribe_to_feed', :default => "Subscribe to %{title}", :title => title)), url
  end

  def flash_messages
    flash.map do |name, message|
      content_tag :p, message, :class => [:notice, name].uniq.join(' ')
    end.join.html_safe if flash.present?
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
    (params[:q].blank? ? I18n.t('txt.recent_posts', :default => 'Recent Posts') : I18n.t('txt.searching_for', :default => 'Searching for') + " '#{params[:q]}'").tap do |title|
      title << " " + I18n.t('txt.by_user', :default => 'by %{user}', :user => @user.display_name) if @user
      title << " " + I18n.t('txt.in_forum', :default => 'in %{forum}', :forum => @forum.name) if @forum
    end
  end

  def topic_title_link(topic, options)
    if topic.title =~ /^\[([^\]]{1,15})\]((\s+)\w+.*)/
      "<span class='flag'>#{$1}</span>" + 
      link_to($2.strip, forum_topic_path(@forum, topic), options)
    else
      link_to(topic.title, forum_topic_path(@forum, topic), options)
    end
  end

  def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> ".html_safe
  end

  def avatar_for(user, size=32)
    image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
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
    capture(&block) if moderator_of?(record)
  end
end
