class PositionsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])

    @positions = @source
      .messages
      .includes(:position, :course)
      .order(:created_at)
      .pluck(
        :latitude,
        :longitude,
        :course_over_ground,
        :speed_over_ground,
      )
  end
end
