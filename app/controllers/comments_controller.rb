class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:top_users]

  def create
    @comment = Comments::Creator.new(current_user, params[:movie_id]).call(comment_params[:content])

    if @comment.errors.present?
      redirect_to @comment.movie, flash: { error: parse_error_messages }
    else
      redirect_to @comment.movie
    end
  end

  def destroy
    @comment = Comments::Destroyer.new(current_user, params[:id]).call
    redirect_to @comment.movie
  end

  def top_users
    @users = User
      .select("users.*, count(*) as comment_count")
      .group(:id)
      .joins(:comments)
      .where(comments: { created_at: (Time.current - 7.days)..Time.current })
      .order("comment_count DESC")
      .limit(10)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def parse_error_messages
    @comment.errors.full_messages.join(". ")
  end
end
