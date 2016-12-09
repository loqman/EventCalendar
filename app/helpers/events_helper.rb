module EventsHelper
  def farsi_date(date)
    date.to_farsi.gsub('AM', 'قبل‌ازظهر').gsub('PM', 'بعدازظهر')
  end
end
