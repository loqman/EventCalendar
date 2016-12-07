class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :date, type: String
  field :description, type: String
  field :author, type: User
  field :edited_by, type: User

  has_and_belongs_to_many :users
end
