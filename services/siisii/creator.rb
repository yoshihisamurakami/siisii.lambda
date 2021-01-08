module TimelinesService
  class Creator
    # include TimelinesCommon

    def initialize(event, context)
      @event = event
    end

    def create
      target_date = Time.now.strftime('%Y-%m-%d')
      timestamp = Time.now.to_f.truncate(2)
      item = {
        TargetDate: target_date,
        Timestamp: timestamp,
        Comment: comment
      }
      dynamo_table.put_item({ item: item })

      timeline = {
        id: timestamp,
        registered_at: Time.at(timestamp).strftime('%H:%M'),
        comment: comment
      }
      [item[:TargetDate], timeline]
    end

    def put_items(items)
      items.each do |item|
        dynamo_table.put_item({ item: item })
      end
    end

    def comment
      body = JSON.parse(@event['body'])
      body['comment'] || '-'
    end
  end
end