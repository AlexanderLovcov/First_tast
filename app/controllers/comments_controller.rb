class CommentsController < ArticlesController
  before_action :set_article

  def index
    @comments = Comment.all
  end

  def create
    ArticleAnalyzer.get_comments(@article)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article) }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment_text)
  end
end