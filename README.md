# Den Danske Forskningsdatabase

## Setup

You will need the system libraries for postgres and sqlite.

```
sudo apt-get install libpq-dev libsqlite3-dev
```
Once this is done:

```
# install dependencies
bundle install
# setup solr and load test data
rake solr:setup_and_import
# startup server
bin/rails s
```

