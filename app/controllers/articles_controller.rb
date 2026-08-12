class ArticlesController < ApplicationController
  # Filters mirror the operations (SEO/UX review: drop "recovery"/"general" —
  # recovery articles live under their specialty).
  CATEGORIES = %w[knee hip trauma complex].freeze

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

    expected = helpers.loc_slug(@blog)
    if params[:slug] != expected
      redirect_to article_path(expected), status: :moved_permanently and return
    end
  end
end
