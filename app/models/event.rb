class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :start_date, type: DateTime
  field :start_date_jalali, type: String
  field :end_date, type: DateTime
  field :end_date_jalali, type: String
  field :description, type: String, default: ''
  field :from_google, type: Boolean, default: false
  field :g_synced, type: Boolean, default: false
  field :g_html_link, type: String
  field :g_author, type: String
  field :color, type: String, default: '#FFEA00'
  field :author_id, type: String
  field :edited_by_id, type: String

  has_and_belongs_to_many :users, autosave: true

  validates_presence_of :title, :start_date, :end_date, :start_date_jalali, :end_date_jalali

  def author_name
    if self.from_google
      self.g_author
    else
      User.find(self.author_id).name
    end
  end

  def edited_by_name
    if self.edited_by_id
      @edited_by_name ||= User.find(self.edited_by_id).name
    else
      false
    end
  end

  def audience

  end

end
