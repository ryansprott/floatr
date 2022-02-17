class SourceSummariesController < ApplicationController
  def index
    @recently_added = render_to_string(
      partial: "/sources/source_cards",
      locals: { sources: Source.recently_added },
      layout: false,
      formats: [:html],
    ).squish

    @recently_seen = render_to_string(
      partial: "/sources/source_recent",
      locals: {
        last_15_minutes: Source.seen_within_last_15_minutes,
        last_minute: Source.seen_within_last_minute,
      },
      layout: false,
      formats: [:html],
    ).squish
  end
end
