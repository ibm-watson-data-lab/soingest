# soingest

[![Build Status](https://travis-ci.org/ibm-cds-labs/soingest.svg?branch=master)](https://travis-ci.org/ibm-cds-labs/soingest)

A Stack Overflow data ingest tool written for OpenWhisk.

It consists of the following OpenWhisk actions (all of them in the `stackoverflow` package)

* `socron` is a sequence to be triggered periodically (we might need a few of these to cover all our tags) which contains `collector` and `invoker`
* `collector` makes the API call to StackOverflow.  The `tags` parameter must be supplied (usually to the sequence) and the `apikey` parameter will be used if present (a StackOverflow API key).  It returns the "items" array of the result it got
* `invoker` simply fires a `qhandler` action for each of the elements in the `items` array it receives
* `qhandler` is a sequence containing `storer` and `notifier`
* `storer` requires the parameters `cloudantURL` and `dbname` to be set (usually on the package).  It writes every question to the database with the `question_id` as the ID, updating the existing question record if we already have one.  The question is in a field called `question` in the data object, and we also add `status` and `owner`.  Status is `new` if we inserted it and `updated` if we updated it because the ID already existed.
* `notifier` will notify slack for any data it gets that has a status of new


**Quick Start** run `./deploy.sh` and check that the `cloudantURL` and `dbname` parameters are set on the `stackoverflow` package.  Then invoke `stackoverflow/socron` with your desired `tags` param
