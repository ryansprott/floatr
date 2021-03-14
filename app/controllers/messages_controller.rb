class MessagesController < ApplicationController
  def show
    @source = Source.find(params[:source_id])

    @messages = @source.messages.details_by_type(params[:id])

    @message_headers = @messages
      .first
      .specific_attributes
      .keys
      .map(&:titleize)
      .map(&:humanize)

    @message_rows = @messages
      .map(&:specific_attributes)
      .map(&:values)
      .uniq
  end
end
