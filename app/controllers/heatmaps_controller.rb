class HeatmapsController < ApplicationController
  def index
    @heatmaps = Source.find(params[:source_id])
      .messages
      .includes(:position)
      .select { |el| el.position }
      .group_by(&:lat_lon)
      .map { |k, v| [k, v.length] }
  end
end
