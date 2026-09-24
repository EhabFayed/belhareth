class ArticlesController < ApplicationController
  # Filters mirror the operations (SEO/UX review: drop "recovery"/"general" —
  # recovery articles live under their specialty).
  CATEGORIES = %w[knee hip trauma complex].freeze

  # The category chips filter client-side on the one /articles page, so a
  # category never becomes its own URL. Legacy ?category= links 301 to the
  # clean path so search engines fold them into the single listing.
  def index
    if params.key?(:category)
      redirect_to articles_path, status: :moved_permanently and return
    end

    @blogs = Blog.published
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
