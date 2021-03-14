class HeatmapsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])

    respond_to do |format|
      format.html { }
      format.json {
        @heatmaps = @source.messages.weighted_by_position
        render :index
      }
    end
  end
end
