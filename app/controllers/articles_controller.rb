require "net/http"
require "uri"
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /articles
  # GET /articles.json
  def index
    if params[:query].present?
      # binding.pry
      @articles = Article.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 8).search(params)
      # binding.pry
    else
      @articles = Article.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 8)
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        @url = "http://localhost:3000"
        @uri = URI.parse @url
        http = Net::HTTP.new(@uri.host, @uri.port)
        req = Net::HTTP::Post.new("/articles")
        req["Content-Type"] = "application/json"
        # test_data = {'dd' => "this is test data from mysearchapp"}
        req.body= @article.to_json
        response=http.start do |h|
          h.request req
        end 
        binding.pry
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render action: 'show', status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :published_on)
    end
    def sort_column
      Article.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end
end
