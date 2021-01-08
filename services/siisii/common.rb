def dynamo_table
  dynamodb = Aws::DynamoDB::Resource.new(region: 'ap-northeast-1')
  dynamodb.table(TABLE_NAME)
end

def dynamo_client
  Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
end

def dynamo_tablename
  TABLE_NAME
end
