# soingest

[![Build Status](https://travis-ci.org/ibm-watson-data-lab/soingest.svg?branch=master)](https://travis-ci.org/ibm-watson-data-lab/soingest)

A Stack Overflow data ingest tool written for OpenWhisk.

It consists of the following OpenWhisk actions (all of them in the `stackoverflow` package)

* `socron` is a sequence to be triggered periodically (we might need a few of these to cover all our tags) which contains `collector` and `invoker`
* `collector` makes the API call to StackOverflow.  The `tags` parameter must be supplied (usually to the sequence) and the `apikey` parameter will be used if present (a StackOverflow API key).  It returns the "items" array of the result it got
* `invoker` simply fires a `qhandler` action for each of the elements in the `items` array it receives
* `qhandler` is a sequence containing `storer` and `notifier`
* `storer` requires the parameters `cloudantURL` and `dbname` to be set (usually on the package).  It writes every question to the database with the `question_id` as the ID, updating the existing question record if we already have one.  The question is in a field called `question` in the data object, and we also add `status` and `owner`.  Status is `new` if we inserted it and `updated` if we updated it because the ID already existed.
* `notifier` will notify slack for any data it gets that has a status of new

![schematic](https://raw.githubusercontent.com/ibm-cds-labs/soingest/master/img/schematic.png)

**Quick Start** run `./deploy.sh` and check that the `cloudantURL`, `slackURL`, and `dbname` parameters are set on the `stackoverflow` package (optional: also set the `apikey` parameter to a valid StackOverflow API key).  Then invoke `stackoverflow/socron` with your desired `tags` param.  To set the setup configured rules so that the actions run periodically, run `./rules.sh`.

## Deployment

To deploy to IBM Cloud, there are [TravisCI setup instructions on the wiki](https://github.com/ibm-watson-data-lab/soingest/wiki/TravisCI-setup).

## Development Setup

Look at `rules.sh` and `deploy.sh` - these are set up by default for Travis, so make some changes to use this stuff locally but do not commit your changes to git unless there's something we need to change on our central deploy.  Try this:
 - remove the first half of `deploy.sh` so that we're not checking for env vars or installing `bx`
 - update all the commands to use `bx` instead of a path to Bluemix_CLI

Make sure your local `bx` tool is targetting your preferred org and workspace (since this is Cloud Functions, they don't run locally)

Configure environment variables, you will need at least:
 - `CLOUDANT_URL` to point to the URL (including creds) of the cloudant to use
 - `QUESTIONS_DB` usually "questions"
 - `BOT_URL` either the publicly-running bot (if you're not working on the bot) or the URL (try using ngrok) to the bot running on your local machine

