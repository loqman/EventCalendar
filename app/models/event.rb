class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :start_date, type: DateTime
  field :start_date_jalali, type: String
  field :end_date, type: DateTime
  field :end_date_jalali, type: String
  field :description, type: String
  field :from_google, type: Boolean, default: false
  field :g_synced, type: Boolean, default: false
  field :color, type: String
  field :author_id, type: String
  field :edited_by_id, type: String

  has_and_belongs_to_many :users

  validates_presence_of :title, :start_date, :end_date, :start_date_jalali, :end_date_jalali


end
