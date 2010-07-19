class VotesController < ApplicationController

  def upvote
    post = vote(params[:id], 1)
    render :partial => "topics/vote_control", :locals => {:post => post}
  end

  def downvote
    post = vote(params[:id], -1)
    render :partial => "topics/vote_control", :locals => {:post => post}
  end

  def vote(post_id, value)
    existing_vote = Vote.find(:first, :conditions => { :user_id => current_user.id, :post_id => post_id })
    post = Post.find(post_id)
    topic = Topic.find(post.topic_id)
    if existing_vote && existing_vote.value == value
      return
    elsif existing_vote && existing_vote.value != value
      existing_vote.update_attribute(:value, value)
      score = post.score + value

      post.update_attribute(:score, score)
      topic.update_attribute(:score, score)
    else
      @vote = Vote.new({ :user => current_user, :post_id => post_id, :value => value })
      if @vote.save
        score = post.score + value

        post.update_attribute(:score, score)
        topic.update_attribute(:score, score)
      end
    end
    post
  end
end