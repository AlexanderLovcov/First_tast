class CommentsController < ArticlesController
  before_action :set_article

  def index
    @comment = Comment.all
  end

  def create

  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment_text)
  end
end