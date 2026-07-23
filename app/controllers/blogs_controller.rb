class BlogsController < ApiController
  # GET /blogs
  def index
    blogs = Blog.not_deleted.order(:id).map do |blog|
      {
        id: blog.id,
        title_ar: blog.title_ar,
        title_en: blog.title_en,
        description_ar: blog.description_ar,
        description_en: blog.description_en,
        category: blog.category,
        slug: blog.slug,
        slug_ar: blog.slug_ar,
        meta_description_ar: blog.meta_description_ar,
        meta_description_en: blog.meta_description_en,
        meta_title_ar: blog.meta_title_ar,
        meta_title_en: blog.meta_title_en,
        is_published: blog.is_published,
        photos: blog.blog_photos.map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        end
      }
    end

    render json: blogs
  end

  # GET /blogs/:id
  def show
    blog = Blog.find(params[:id])
    data = {
      id: blog.id,
      title_ar: blog.title_ar,
      title_en: blog.title_en,
      category: blog.category,
      slug: blog.slug,
      slug_ar: blog.slug_ar,
      meta_description_ar: blog.meta_description_ar,
      meta_description_en: blog.meta_description_en,
      meta_title_ar: blog.meta_title_ar,
      meta_title_en: blog.meta_title_en,
      is_published: blog.is_published,
      photos: blog.blog_photos.map do |photo|
        {
          id: photo.id,
          url: photo.photo.attached? ? url_for(photo.photo) : nil,
          alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
          is_arabic: photo.is_arabic
        }
      end,
      contents: blog.contents.where(is_deleted: false).order(:id).map do |content|
        {
          id: content.id,
          content_ar: content.content_ar,
          content_en: content.content_en,
          is_published: content.is_published,
          photos: content.content_photos.map do |cp|
            {
              id: cp.id,
              url: cp.photo.attached? ? url_for(cp.photo) : nil,
              alt_ar: cp.alt_ar,
              alt_en: cp.alt_en
            }
          end
        }
      end,
      faqs: blog.faqs.where(is_deleted: false).order(:id).map do |faq|
        {
          id: faq.id,
          question_ar: faq.question_ar,
          question_en: faq.question_en,
          answer_ar: faq.answer_ar,
          answer_en: faq.answer_en,
          is_published: faq.is_published
        }
      end
    }

    render json: data
  end

  # POST /blogs
  def create
    blog = Blog.new(blog_params)
    blog.user_id = current_user.id

    if blog.save
      render json: { message: 'Blog created successfully' }, status: :created
    else
      render json: { error: blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/:id
  def update
    blog = Blog.find(params[:id])

    if blog.update(blog_params)
      render json: { message: 'Blog updated successfully' }, status: :ok
    else
      render json: { error: blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    blog.destroy
    render json: { message: 'Blog deleted successfully' }, status: :ok
  end

  private

  def blog_params
    params.require(:blog).permit(
      :title_ar,
      :title_en,
      :description_ar,
      :description_en,
      :meta_title_ar,
      :meta_title_en,
      :slug,
      :meta_description_ar,
      :meta_description_en,
      :category,
      :is_published,
      :slug_ar,
      blog_photos_attributes: [
        :id,
        :alt_ar,
        :alt_en,
        :photo,
        :is_arabic,
        :_destroy
      ]
    )
  end
end
