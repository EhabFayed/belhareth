module Admin
  class BlogsController < BaseController
    before_action :set_blog, only: [:edit, :update, :destroy]

    def index
      @blogs = Blog.not_deleted.order(created_at: :desc)
    end

    def new
      @blog = Blog.new
    end

    def create
      @blog = Blog.new(blog_params)
      @blog.user_id = current_admin.id
      if @blog.save
        redirect_to edit_admin_blog_path(@blog), notice: "Blog created. Add its content and FAQs below."
      else
        flash.now[:alert] = @blog.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @blog.update(blog_params)
        redirect_to edit_admin_blog_path(@blog), notice: "Blog updated."
      else
        flash.now[:alert] = @blog.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @blog.update(is_deleted: true)
      redirect_to admin_blogs_path, notice: "Blog deleted."
    end

    private

    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(
        :title_ar, :title_en, :description_ar, :description_en,
        :meta_title_ar, :meta_title_en, :meta_description_ar, :meta_description_en,
        :slug, :slug_ar, :category, :is_published,
        :image_alt_text_ar, :image_alt_text_en,
        blog_photos_attributes: [:id, :alt_ar, :alt_en, :photo, :is_arabic, :_destroy]
      )
    end
  end
end
