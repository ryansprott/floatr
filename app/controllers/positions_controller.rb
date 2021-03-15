class PositionsController < ApplicationController
  def index
    @source = Source.find(params[:source_id])

    @positions = @source.messages.with_courses
  end
end
