class ContentsController < ApiController
  # GET /blogs/:blog_id/contents
  # GET /operations/:operation_id/contents
  def index
    parent = find_parent
    contents = parent.contents.where(is_deleted: false).order(:id).map do |content|
      {
        id: content.id,
        content_ar: content.content_ar,
        content_en: content.content_en,
        photos: content.content_photos.map do |cp|
          {
            cp_id: cp.id,
            url: cp.photo.attached? ? url_for(cp.photo) : nil,
            alt_ar: cp.alt_ar,
            alt_en: cp.alt_en
          }
        end
      }
    end
    render json: contents
  end

  # POST /blogs/:blog_id/contents
  # POST /operations/:operation_id/contents
  def create
    parent = find_parent
    content = parent.contents.build(content_params)
    content.user_id = current_user.id
    if content.save
      render json: { message: 'Content created successfully' }, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/:blog_id/contents/:id
  def update
    content = Content.find(params[:id])
    if content.update(content_params)
      render json: { message: 'Content updated successfully' }, status: :ok
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /blogs/:blog_id/contents/:id
  def destroy
    content = Content.find(params[:id])
    content.destroy
    render json: { message: 'Content deleted successfully' }, status: :ok
  end

  private

  def find_parent
    if params[:blog_id]
      Blog.find(params[:blog_id])
    elsif params[:operation_id]
      Operation.find(params[:operation_id])
    end
  end

  def content_params
    params.require(:content).permit(
      :content_ar,
      :content_en,
      :user_id,
      :is_published,
      content_photos_attributes: [
        :id,
        :alt_ar,
        :alt_en,
        :photo,
        :_destroy
      ]
    )
  end
end
