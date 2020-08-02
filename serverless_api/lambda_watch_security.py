from urllib import request
import json, os, boto3


def send_to_slack(message):
    url = os.environ['SLACK_WEBHOOK']
    body = {"text": message}
    bytes = json.dumps(body).encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, bytes)


# entry point of lambda
def main(event, context):
    send_to_slack("```" + json.dumps(event) + "```")

    body = json.loads(event['body'])

    date = body['date']
    driver = body['security']

    # save in dynamo db
    client = boto3.client('dynamodb')
    response = client.put_item(
        Item={
            'CreatedDate': {
                'S': date,
            },
            'Security': {
                'S': driver,
            }
        },
        ReturnConsumedCapacity='TOTAL',
        TableName='WatchList',
    )

    print(response)
    send_to_slack("```" + json.dumps(response) + "```")

    response = {
        'statusCode': 200,
        'headers': {
            "x-custom-header": "my custom header value",
            "Access-Control-Allow-Origin": "*"
        },
        'body': 'success'
    }

    send_to_slack("```" + json.dumps(response) + "```")

    return response
