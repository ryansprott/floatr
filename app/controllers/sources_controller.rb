class SourcesController < ApplicationController
  def index
    @sources = params[:with_destinations].presence === 'true' ?
      Source.with_destinations :
      Source.all

    if params[:search_text].present?
      search_text = "%#{params[:search_text].upcase}%"
      @sources = @sources.where(
        'ship_name like ? or last_destination like ?',
        search_text,
        search_text
      )
    end

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end

  def show
    @source = Source.find(params[:id])
    @messages = @source
      .messages
      .joins(:position, :course)
      .order(:created_at)
  end
end
