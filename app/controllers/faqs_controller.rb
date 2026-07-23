class FaqsController < ApiController
  # GET /blogs/:blog_id/faqs
  # GET /operations/:operation_id/faqs
  def index
    parent = find_parent
    faqs = parent.faqs.where(is_deleted: false).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end

  # POST /blogs/:blog_id/faqs
  # POST /operations/:operation_id/faqs
  def create
    parent = find_parent

    faq = parent.faqs.build(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: { message: 'Faq created successfully' }, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /faqs — create a FAQ without a blog reference (global FAQ)
  def create_without_blog
    faq = Faq.new(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: { message: 'Faq created successfully' }, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /faqs
  def index_without_blog
    faqs = Faq.where(is_deleted: false, parentable_id: nil).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end

  # PATCH/PUT /faqs/:id
  def update_without_blog
    faq = Faq.find(params[:id])
    if faq.update(faq_params)
      render json: { message: 'Faq updated successfully' }, status: :ok
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /faqs/:id
  def delete_without_blog
    faq = Faq.find(params[:id])
    faq.update(is_deleted: true)
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end

  # PATCH/PUT /blogs/:blog_id/faqs/:id
  def update
    faq = Faq.find(params[:id])
    if faq.update(faq_params)
      render json: { message: 'Faq updated successfully' }, status: :ok
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /blogs/:blog_id/faqs/:id
  def destroy
    faq = Faq.find(params[:id])
    faq.destroy
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end

  private

  def find_parent
    if params[:blog_id]
      Blog.find(params[:blog_id])
    elsif params[:operation_id]
      Operation.find(params[:operation_id])
    end
  end

  def faq_params
    params.require(:faq).permit(:question_ar, :question_en, :answer_ar, :answer_en, :is_published)
  end
end
