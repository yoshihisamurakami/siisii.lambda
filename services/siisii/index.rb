
module TimelinesService
  class Index
    # include TimelinesCommon

    def initialize(event, context)
      @event = event
    end

    def get_index
      params = {
        table_name: dynamo_tablename,
        key_condition_expression: "#targetdate = :targetdate",
        expression_attribute_names: {
          "#targetdate" => "TargetDate"
        },
        expression_attribute_values: {
          ":targetdate" => target_date
        }
      }

      result = dynamo_client.query(params)
      data = []
      result.items.each do |timeline|
        data << {
          id: get_id(timeline),
          registered_at: get_registered_at(timeline),
          comment: timeline["Comment"]
        }
      end
      [target_date, data]
    end

    def target_date
      @event['queryStringParameters']['target_date'] || Time.now.strftime('%Y-%m-%d')
    end

    # id => Timestamp
    def get_id(timeline)
      timeline["Timestamp"].to_f
    end

    def get_registered_at(timeline)
      Time.at(timeline["Timestamp"].to_f).strftime('%H:%M')
    end
  end
end