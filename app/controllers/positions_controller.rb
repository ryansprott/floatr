class PositionsController < ApplicationController
  def index
    @positions = Source.find(params[:source_id])
      .messages
      .includes(:position)
      .sort_by(&:created_at)
      .map(&:lat_lon)
      .uniq
      .reject(&:blank?)
  end
end
