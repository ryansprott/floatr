class SourcesController < ApplicationController
  def index
    @sources = Source.with_valid_messages.order(created_at: :desc)

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end

  def summary
    @recently_added = Source.recently_added
    @recently_seen = Source.recently_seen
  end

  def show
    @source = Source.find(params[:id])

    @messages = @source.messages

    @positions = @messages.joins(:position, :course).order(:created_at)
  end
end
