# Running the tests
```bash
bundle install
bundle exec rspec
```

If you want to run the integration tests against a real bucket you need to pass your Ksyun credentials to the test runner or declare it in your environment.
```bash
KS3_ENDPOINT="Ksyun ks3 endpoint to connect to" KS3_ACCESS_KEY="Your access key id" KS3_SECRET_KEY="Your access secret" KS3_BUCKET="Your bucket" bundle exec rspec spec/integration --tag integration
```