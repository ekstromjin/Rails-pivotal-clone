class CommentController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment[:user_id] = session[:user_id]
    @comment.save

    @story = @comment.story

    @admin = User.getAdmin
    PivotalMailer.create_comment(@comment, @story, @admin).deliver_later
    @story.users.where.not(id: session[:user_id]).each {|user| PivotalMailer.create_comment(@comment, @story, user).deliver_later }
  end

  private
    def comment_params
      params.require(:comment).permit(:comment, :story_id)
    end
end
