module TimelinesService
  class Updater
    # include TimelinesCommon

    def initialize(event, context)
      @event = event
    end

    def update
      target_date = get_target_date
  
      delete_old_item

      new_timestamp = get_registered_at
      item = {
        TargetDate: target_date,
        Timestamp: new_timestamp,
        Comment: get_comment
      }
      dynamo_table.put_item({ item: item })

      [ target_date, {
          id: new_timestamp,
          comment: get_comment 
      }]
    end

    # 既存項目の削除
    def delete_old_item
      params = {
        key: {
          TargetDate: get_target_date,
          Timestamp: get_id
        }
      }
      dynamo_table.delete_item(params)
    end

    def get_target_date
      body = JSON.parse(@event['body'])
      Time.at(body['id']).strftime('%Y-%m-%d')
    end

    def get_id
      body = JSON.parse(@event['body'])
      body['id'] || '-'
    end

    def get_comment
      body = JSON.parse(@event['body'])
      body['comment'] || '-'
    end

    def get_registered_at
      body = JSON.parse(@event['body'])
      old_seconds = Time.at(body['id']).strftime('%S') # 秒
      new_time = "#{get_target_date} " + body['registered_at'] + ':' + old_seconds
      Time.parse(new_time).to_i
    end
  end
end