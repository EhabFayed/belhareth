module Admin
  class ContentsController < BaseController
    def create
      parent = find_parent
      content = parent.contents.build(content_params)
      content.user_id = current_admin.id
      if content.save
        redirect_back fallback_location: admin_root_path, notice: "Content block added."
      else
        redirect_back fallback_location: admin_root_path, alert: content.errors.full_messages.to_sentence
      end
    end

    def update
      content = Content.find(params[:id])
      if content.update(content_params)
        redirect_back fallback_location: admin_root_path, notice: "Content block updated."
      else
        redirect_back fallback_location: admin_root_path, alert: content.errors.full_messages.to_sentence
      end
    end

    def destroy
      content = Content.find(params[:id])
      content.update(is_deleted: true)
      redirect_back fallback_location: admin_root_path, notice: "Content block deleted."
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
        :content_ar, :content_en, :is_published,
        content_photos_attributes: [:id, :alt_ar, :alt_en, :photo, :_destroy]
      )
    end
  end
end
