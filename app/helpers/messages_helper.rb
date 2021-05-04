module MessagesHelper
  def parse_message_type(message_type, total_messages)
    case message_type
    when 1
      render "messages/message_button", {
        message_description: "Class A position report type 1",
        total_messages: total_messages,
      }
    when 2
      render "messages/message_button", {
        message_description: "Class A position report type 2",
        total_messages: total_messages,
      }
    when 3
      render "messages/message_button", {
        message_description: "Class A position report type 3",
        total_messages: total_messages,
      }
    when 4
      render "messages/message_button", {
        message_description: "Base station report",
        total_messages: total_messages,
      }
    when 5
      render "messages/message_link", {
        message_description: "Class A static data report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 6
      render "messages/message_button", {
        message_description: "Binary addressed message",
        total_messages: total_messages,
      }
    when 7
      render "messages/message_link", {
        message_description: "Binary acknowledgement",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 8
      render "messages/message_link", {
        message_description: "Binary broadcast message",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 9
      render "messages/message_link", {
        message_description: "SAR aircraft position report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 10
      render "messages/message_link", {
        message_description: "UTC/date inquiry",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 15
      render "messages/message_link", {
        message_description: "Interrogation",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 18
      render "messages/message_button", {
        message_description: "Class B position report",
        total_messages: total_messages,
      }
    when 21
      render "messages/message_link", {
        message_description: "Aid-to-navigation report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 24
      render "messages/message_link", {
        message_description: "Static data report",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    when 27
      render "messages/message_link", {
        message_description: "Long range AIS broadcast message",
        total_messages: total_messages,
        link_path: source_message_path(@source, message_type),
      }
    else
      message_type
    end
  end
end
