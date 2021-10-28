class HeatmapsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])
  end
end
