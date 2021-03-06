class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy count_comments set_article_number_of_comments analyze_comments]

  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.title = ArticleAnalyzer.article_name(@article.url)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /articles/1 or /articles/1.json
  def count_comments
    comments_count = ArticleAnalyzer.count_comments(@article)

    respond_to do |format|
      if @article.update(number_of_comments: comments_count)
        format.html { redirect_to article_url(@article) }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def analyze_comments
    ArticleAnalyzer.analyze_comments(@article)
    redirect_to article_url(@article)

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :url, :number_of_comments)
  end
end
