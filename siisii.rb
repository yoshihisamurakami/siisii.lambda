require 'aws-sdk-dynamodb'
require 'time'
require 'setting.rb'

Dir[File.dirname(__FILE__) + '/services/siisii/*.rb'].each {|file| require file }

def handler(event:, context:)
  raise StandardError, '環境変数LAMBDA_ENVをセットしてください' if ENV['LAMBDA_ENV'].nil?
  case event['httpMethod']
  when 'GET'
    body = index(event)
  when 'POST'
    body = create(event)
  when 'PATCH'
    body = update(event)
  when 'DELETE'
    body = destroy(event)
  else
    body = { event: event.inspect }
  end
  res = response_json(body)
  res
rescue => e
  body = { error: e.inspect }
  response_json(body)
end

def response_json(body)
  { 
    isBase64Encoded: false,
    statusCode: 200,
    headers: {
      "Access-Control-Allow-Origin": ENV['ACCESS_CONTROL_ALLOW_ORIGIN']
    },
    body: body.to_json
  }
end

def index(event)
  indexer = TimelinesService::Index.new(event)
  target_date, timelines = indexer.get_index
  {
    result: true,
    data: {
      target_date: target_date,
      timelines: timelines
    }
  }
end

def create(event)
  creator = TimelinesService::Creator.new(event)
  target_date, timeline = creator.create
  { 
    target_date: target_date,
    timeline: timeline
  }
end

def update(event)
  updater = TimelinesService::Updater.new(event)
  target_date, timeline = updater.update
  {
    target_date: target_date,
    timeline: timeline
  }
end

def destroy(event)
  destroyer = TimelinesService::Destroyer.new(event)
  destroyer.destroy
  {}
end