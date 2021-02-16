class HeatmapsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])

    @heatmaps = @source
      .messages
      .includes(:position)
      .select(&:position)
      .group_by(&:lat_lon)
      .map { |k, v| [k, v.length] }

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end
end
