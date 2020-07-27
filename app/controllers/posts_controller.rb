class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @post = Post.new
    @posts = Post.all
    if params[:search]
      @search_results_posts = Post.search_by_title_and_content(params[:search])
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
        respond_to do |format|
          format.html
          format.js
        end
  end

  def create
    @post = Post.new(post_params)
    unless @post.save
      render json: @post.errors, status: :unprocessable_entity
    end

    # respond_to do |format|
    #   if @post.save
    #     format.js
    #     format.html { redirect_to @post, notice: 'Post was successfully created.' }
    #     format.json { render :show, status: :created, location: @post }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @post.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update
    @post.update(post_params)
    respond_to do |format|
      if @post.update(post_params)
        format.js
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content)
    end
end
