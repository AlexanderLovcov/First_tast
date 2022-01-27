require 'nokogiri'
require 'open-uri'

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy count_comments set_article_number_of_comments]

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
    @article.title = self.get_article_name

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

  def get_article_name
    doc = Nokogiri::HTML(URI.open('%s' % [@article.url_of_article]))
    doc.css('h1').text
  end

  # GET /articles/1 or /articles/1.json
  def count_comments
    list_of_author_names = []
    art_url = @article.url_of_article

    if art_url.include? '/comments.html#comments'
      doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    else
      art_url = @article.url_of_article.gsub('.html', '') + '/comments.html#comments'
      doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    end

    doc.css('div.onecomm p.author span.about strong.name').each do |name|
      list_of_author_names.append(name.content)
    end

    respond_to do |format|
      format.html { redirect_to article_url(@article) }
      format.json { render :show, status: :ok, location: @article }
      list_of_author_names.length
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def set_article_number_of_comments
    @article.number_of_comments = self.count_comments
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :url_of_article, :number_of_comments)
  end
end
