module TimelinesService
  class Destroyer
    def initialize(event)
      @event = event
    end

    def destroy
      target_date = get_target_date
      timestamp = get_id
      params = {
        key: {
          TargetDate: target_date,
          Timestamp: timestamp.to_f
        }
      }
      dynamo_table.delete_item(params)
    end

    def get_target_date
      body = @event['pathParameters']
      Time.at(body['id'].to_f).strftime('%Y-%m-%d')
    end

    def get_id
      body = @event['pathParameters']
      body['id']
    end
  end
end