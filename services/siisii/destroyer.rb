module TimelinesService
  class Destroyer
    def initialize(event)
      @event = event
    end

    def destroy
      target_date = Time.now.strftime('%Y-%m-%d')
      timestamp = get_id
      params = {
        key: {
          TargetDate: target_date,
          Timestamp: timestamp.to_f
        }
      }
      dynamo_table.delete_item(params)
    end

    def get_id
      body = @event['pathParameters']
      body['id']
    end
  end
end