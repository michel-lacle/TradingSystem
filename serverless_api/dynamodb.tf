resource "aws_dynamodb_table" "this" {
  name           = "WatchList"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Security"
  range_key      = "CreatedDate"

  attribute {
    name = "CreatedDate"
    type = "S"
  }

  attribute {
    name = "Security"
    type = "S"
  }
}