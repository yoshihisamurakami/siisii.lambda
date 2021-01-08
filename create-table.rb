require 'aws-sdk-dynamodb'

def handler(event:, context:)

  attribute_defs = [
    { attribute_name: 'Timestamp',  attribute_type: 'N' },
  ]

  key_schema = [
    { attribute_name: 'Timestamp', key_type: 'HASH' }
  ]
  request = {
    attribute_definitions:    attribute_defs,
    table_name:               'Siisii.Notes.development',
    key_schema:               key_schema,
    provisioned_throughput:   { read_capacity_units: 5, write_capacity_units: 10 }
  }
  
  dynamodb_client = Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
  
  dynamodb_client.create_table(request)

  { status: '200' }
end
