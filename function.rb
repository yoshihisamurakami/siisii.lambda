require 'aws-sdk-dynamodb'
require 'time'
require 'setting.rb'

Dir[File.dirname(__FILE__) + '/services/siisii/*.rb'].each {|file| require file }

module Siisii
  class Handler
    def self.index(event:, context:)
      indexer = TimelinesService::Index.new(event, context)
      target_date, timelines = indexer.get_index
      {
        result: true,
        data: {
          target_date: target_date,
          timelines: timelines
        }
      }
    end

    def self.create(event:, context:)
      creator = TimelinesService::Creator.new(event, context)
      target_date, timeline = creator.create
      { 
        target_date: target_date,
        timeline: timeline
      }
    end

    def self.update(event:, context:)
      updater = TimelinesService::Updater.new(event, context)
      target_date, timeline = updater.update
      {
        target_date: target_date,
        timeline: timeline
      }
    end

    def self.destroy(event:, context:)
      destroyer = TimelinesService::Destroyer.new(event, context)
      destroyer.destroy
      {}
    end
 
    def self.any(event:, context:)
      raise StandardError, '環境変数LAMBDA_ENVをセットしてください' if ENV['LAMBDA_ENV'].nil?
      body = nil
      case event['httpMethod']
      when 'GET'
        body = index(event: event, context: context)
      when 'POST'
        body = create(event: event, context: context)
      when 'PATCH'
        body = update(event: event, context: context)
      when 'DELETE'
        body = destroy(event: event, context: context)
      else
        body = { message: 'request error!' }
      end
      { 
        isBase64Encoded: false,
        statusCode: 200,
        headers: {
          "Access-Control-Allow-Origin": ENV['ACCESS_CONTROL_ALLOW_ORIGIN']
        },
        body: body.to_json
      }
    end
  end
end
