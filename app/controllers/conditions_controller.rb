class ConditionsController < ApplicationController
  def index
    @operations = Operation.published.reorder(:id)
  end

  def show
    @operation = Operation.find_by_any_slug(params[:id])
    unless @operation && @operation.is_published && !@operation.is_deleted
      head :not_found and return
    end

    # One URL per page and language: the wrong-locale slug 301s to the
    # locale-correct one (SEO audit: canonical/redirect list).
    expected = helpers.loc_slug(@operation)
    if params[:id] != expected
      redirect_to specialty_path(expected), status: :moved_permanently and return
    end

    @position = Operation.published.reorder(:id).pluck(:id).index(@operation.id).to_i + 1
  end
end
