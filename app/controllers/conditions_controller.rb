class ConditionsController < ApplicationController
  def index
  end

  def show
    @condition = Condition.find(params[:id])
    head :not_found unless @condition
  end
end
