class PositionsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])

    @positions = @source
      .messages
      .includes(:position)
      .order(:created_at)
      .map(&:lat_lon)
      .uniq
      .reject(&:blank?)
  end
end
