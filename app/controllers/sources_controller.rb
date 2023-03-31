class SourcesController < ApplicationController
  def index
    @sources = if params[:with_destinations].presence === 'true'
                 Source.with_destinations
               else
                 Source.with_messages
               end

    if params[:search_text].present?
      filter_by_search_text
    end

    respond_to do |format|
      format.html {}
      format.json { render :index }
    end
  end

  def show
    @source = Source.find(params[:id])
    @messages = @source.
                messages.
                includes(:position, :course).
                references(:position, :course).
                order(:created_at)
  end

  private

  def filter_by_search_text
    search_text = "%#{params[:search_text].upcase}%"
    @sources = @sources.where(
      'ship_name like ? or last_destination like ?',
      search_text,
      search_text
    )
  end
end
