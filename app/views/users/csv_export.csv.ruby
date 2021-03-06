require 'csv'
CSV.generate do |csv|
  column_names = %w(date started_time finished_time)
  csv << column_names
  @days.each do |d|
  column_values = [
    d.attendance_day,
    started_time_for_total(d)&.strftime("%H:%M"),
    finished_time_for_total(d)&.strftime("%H:%M")
    ]
    csv << column_values
  end
end