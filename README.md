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
# startup solr
rake jetty:start
# load test data
rake metastore:testdata:index
# startup server
bin/rails s
```

