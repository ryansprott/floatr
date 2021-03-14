class Specific < ActiveRecord::Base
  self.abstract_class = true
  include SerializesAttributes
end
