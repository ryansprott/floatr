class SourceSummariesController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper

  def index
    @recently_added = render_to_string(
      partial: "/sources/source_table.html",
      locals: { sources: Source.recently_added },
      layout: false,
      formats: [:html],
    ).squish

    @recently_seen = render_to_string(
      partial: "/sources/source_table.html",
      locals: { sources: Source.recently_seen },
      layout: false,
      formats: [:html],
    ).squish
  end
end
