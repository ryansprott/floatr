class Dimension < ActiveRecord::Base
  belongs_to :message, optional: true
  include SerializesAttributes
end
