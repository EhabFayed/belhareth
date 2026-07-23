module Admin
  class OperationsController < BaseController
    before_action :set_operation, only: [:edit, :update, :destroy]

    def index
      @operations = Operation.not_deleted.order(:id)
    end

    def new
      @operation = Operation.new
    end

    def create
      @operation = Operation.new(operation_params)
      @operation.user_id = current_admin.id
      if @operation.save
        redirect_to edit_admin_operation_path(@operation), notice: "Operation created. Add its content and FAQs below."
      else
        flash.now[:alert] = @operation.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @operation.update(operation_params)
        redirect_to edit_admin_operation_path(@operation), notice: "Operation updated."
      else
        flash.now[:alert] = @operation.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @operation.update(is_deleted: true)
      redirect_to admin_operations_path, notice: "Operation deleted."
    end

    private

    def set_operation
      @operation = Operation.find(params[:id])
    end

    def operation_params
      params.require(:operation).permit(
        :title_ar, :title_en, :description_ar, :description_en,
        :meta_title_ar, :meta_title_en, :meta_description_ar, :meta_description_en,
        :slug, :slug_ar, :category, :is_published,
        :image_alt_text_ar, :image_alt_text_en,
        operation_photos_attributes: [:id, :alt_ar, :alt_en, :photo, :is_landing, :_destroy]
      )
    end
  end
end
