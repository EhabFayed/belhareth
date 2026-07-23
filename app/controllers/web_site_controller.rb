class WebSiteController < ApiController
  skip_before_action :authorize_request

  def blogs_landing
    blogs = Blog.published.map do |blog|
      {
        id: blog.id,
        title_ar: blog.title_ar,
        title_en: blog.title_en,
        description_ar: blog.description_ar,
        description_en: blog.description_en,
        category: blog.category,
        slug: blog.slug,
        slug_ar: blog.slug_ar,
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

  def operations_landing
    operations = Operation.published.map do |operation|
      {
        id: operation.id,
        title_ar: operation.title_ar,
        title_en: operation.title_en,
        description_ar: operation.description_ar,
        description_en: operation.description_en,
        category: operation.category,
        slug: operation.slug,
        slug_ar: operation.slug_ar,
        photos: operation.operation_photos.where(is_landing: true).map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt_ar: photo.alt_ar,
            alt_en: photo.alt_en,
            is_landing: photo.is_landing
          }
        end
      }
    end
    render json: operations
  end

  def operation_show
    operation = Operation.find_by_any_slug(params[:slug])
    if operation
      data = {
        id: operation.id,
        title_ar: operation.title_ar,
        title_en: operation.title_en,
        category: operation.category,
        slug: operation.slug,
        slug_ar: operation.slug_ar,
        meta_description_ar: operation.meta_description_ar,
        meta_description_en: operation.meta_description_en,
        meta_title_ar: operation.meta_title_ar,
        meta_title_en: operation.meta_title_en,
        photos: operation.operation_photos.where(is_landing: false).map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt_ar: photo.alt_ar,
            alt_en: photo.alt_en,
            is_landing: photo.is_landing
          }
        end,
        contents: operation.contents.where(is_deleted: false, is_published: true).order(:id).map do |content|
          {
            id: content.id,
            content_ar: content.content_ar,
            content_en: content.content_en,
            photos: content.content_photos.map do |cp|
              {
                url: cp.photo.attached? ? url_for(cp.photo) : nil,
                alt_ar: cp.alt_ar,
                alt_en: cp.alt_en
              }
            end
          }
        end,
        faqs: operation.faqs.where(is_deleted: false, is_published: true).order(:id).map do |faq|
          {
            id: faq.id,
            question_ar: faq.question_ar,
            question_en: faq.question_en,
            answer_ar: faq.answer_ar,
            answer_en: faq.answer_en
          }
        end
      }

      render json: data
    else
      render json: { error: 'Operation not found' }, status: :not_found
    end
  end

  def blog_show
    blog = Blog.find_by_any_slug(params[:slug])
    if blog
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
        photos: blog.blog_photos.map do |photo|
          {
            id: photo.id,
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        end,
        contents: blog.contents.where(is_deleted: false, is_published: true).order(:id).map do |content|
          {
            id: content.id,
            content_ar: content.content_ar,
            content_en: content.content_en,
            photos: content.content_photos.map do |cp|
              {
                url: cp.photo.attached? ? url_for(cp.photo) : nil,
                alt_ar: cp.alt_ar,
                alt_en: cp.alt_en
              }
            end
          }
        end,
        faqs: blog.faqs.where(is_deleted: false, is_published: true).order(:id).map do |faq|
          {
            id: faq.id,
            question_ar: faq.question_ar,
            question_en: faq.question_en,
            answer_ar: faq.answer_ar,
            answer_en: faq.answer_en
          }
        end
      }

      render json: data
    else
      render json: { error: 'Blog not found' }, status: :not_found
    end
  end

  def faq_about_us
    faqs = Faq.where(is_deleted: false, is_published: true, parentable_id: nil).order(:id)

    render json: faqs.map { |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en
      }
    }
  end
end
