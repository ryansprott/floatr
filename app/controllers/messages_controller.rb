class MessagesController < ApplicationController
  def show
    source = Source.find(params[:source_id])

    messages = source.messages
      .where(type: params[:id].to_i)
      .includes(
        "type_#{params[:id]}_specific".to_sym,
        :course,
        :dimension,
      )

    @message_headers = messages
      .first
      .specific_attributes
      .keys
      .map(&:titleize)
      .map(&:humanize)

    @message_rows = messages
      .map(&:specific_attributes)
      .map(&:values)
      .uniq
  end
end
