module TimelinesService
  class Updater
    def initialize(event)
      @event = event
    end

    def update
      delete_old_item

      new_timestamp = get_registered_at
      item = {
        TargetDate: get_new_target_date,
        Timestamp: new_timestamp,
        Comment: get_comment
      }
      dynamo_table.put_item({ item: item })

      [ get_new_target_date, {
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

    # 削除するid に紐づく日付を返す
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

    def get_new_target_date
      body = JSON.parse(@event['body'])
      body['registered_at'][0..9]
    end

    def get_registered_at
      body = JSON.parse(@event['body'])
      time = body['registered_at']
      Time.parse(time).to_i
    end
  end
end