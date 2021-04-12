![Rubocop](https://github.com/mattrothstein/testing/actions/workflows/.github/workflows/linter.yaml/badge.svg)
![RSpec](https://github.com/mattrothstein/testing/actions/workflows/.github/workflows/test.yaml/badge.svg)
# Testing API

This application is a sample testing API. There is a single endpoint that accepts the following data:

```
{
  first_name: String,
  last_name: String,
  phone_number: String,
  college_id: Integer,
  exam_id: Integer,
  start_time: DateTime
}
 ```

### Instructions
Execute the following commands to download gems and setup your database:

```shell
bundle install
rails db:setup
```

### Automated Tests
Execute the following commands to run the automated test suite:

```shell
rspec
```


### Manual Tests
Once your application is being served locally on port 3000, you can manually test this application using the following `cURL` command. You will need to adjust the `start_time` so that it falls within the start and end time of an exam window.

```
curl -X POST \
  http://localhost:3000/exam_registrations \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 8ead4afd-1f49-4c6e-bb47-ae98406f7e8c' \
  -H 'cache-control: no-cache' \
  -d '{
	"first_name":"matt",
	"last_name":"rothstein",
	"phone_number":"17863051010",
	"college_id":"1",
	"exam_id":"1",
	"start_time":"2021-04-10T08:30:00-04:00"
}
'
```

