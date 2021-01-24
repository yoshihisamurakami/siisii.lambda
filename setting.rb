ENV['TZ'] = 'Asia/Tokyo'

case ENV['LAMBDA_ENV']
when 'development'
  TABLE_NAME = 'Siisii.Timelines.develop'
when 'demo'
  TABLE_NAME = 'Siisii.Timelines.demo'
when 'production'
  TABLE_NAME = 'Siisii.Timelines'
else
  TABLE_NAME = nil
end