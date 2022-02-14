class CommentsController < ApplicationController
  before_action :set_article

  def index
    @comments = Article.find(params[:article_id]).comments
  end

  def create
    ArticleAnalyzer.get_comments(@article)
    redirect_to article_url(@article), notice: "Comments were successfully fetched."
  end

  def destroy
    @comments.destroy
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment_text)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

end