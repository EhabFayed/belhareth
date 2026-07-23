class ArticlesController < ApplicationController
  CATEGORIES = %w[knee hip trauma recovery general].freeze

  def index
    @category = CATEGORIES.include?(params[:category]) ? params[:category] : nil
    @blogs = Blog.published
    @blogs = @blogs.where(category: Blog.category.find_value(@category).value) if @category
  end

  def show
    @blog = Blog.find_by_any_slug(params[:slug])
    unless @blog && @blog.is_published && !@blog.is_deleted
      head :not_found and return
    end
  end
end
