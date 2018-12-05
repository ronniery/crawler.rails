class Quote
  include Mongoid::Document
  field :desc, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array
end
