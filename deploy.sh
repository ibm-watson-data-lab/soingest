#!/bin/bash

# verify that the required Cloud Foundry variables are set
invocation_error=0
# - BXIAM: IBM Cloud API key
if [ -z ${BXIAM+x} ]; then echo 'Error: Environment variable BXIAM is undefined.'; invocation_error=1; fi
# - CF_ORGANIZATION: IBM Cloud/Cloud Foundry organization name
if [ -z ${CF_ORGANIZATION+x} ]; then echo 'Error: Environment variable CF_ORGANIZATION is undefined.'; invocation_error=1; fi
# - CF_SPACE: IBM Cloud/Cluod Foundry space name
if [ -z ${CF_SPACE+x} ]; then echo 'Error: Environment variable CF_SPACE is undefined.'; invocation_error=1; fi
#
# set optional Cloud Foundry variables if they are not set
# - CF_API: IBM Cloud API endpoint (default to US-South region)
if [ -z ${CF_API+x} ]; then export CF_API='https://api.ng.bluemix.net'; fi

# verify that the required application specific variables are set
# - refer to documentation
if [ -z ${WSK_PACKAGE+x} ]; then echo 'Error: Environment variable WSK_PACKAGE is undefined.'; invocation_error=1; fi
if [ -z ${CLOUDANT_URL+x} ]; then echo 'Error: Environment variable CLOUDANT_URL is undefined.'; invocation_error=1; fi
if [ -z ${QUESTIONS_DB+x} ]; then echo 'Error: Environment variable QUESTIONS_DB is undefined.'; invocation_error=1; fi
if [ -z ${SLACK_URL+x} ]; then echo 'Error: Environment variable SLACK_URL is undefined.'; invocation_error=1; fi
if [ -z ${HUBOT_URL+x} ]; then echo 'Error: Environment variable HUBOT_URL is undefined.'; invocation_error=1; fi

if [ ${invocation_error} -eq 1 ]; then echo 'Aborting deployment.'; exit 1; fi

# login and set target
set -x
./Bluemix_CLI/bin/bluemix config --check-version false
./Bluemix_CLI/bin/bluemix api $CF_API
./Bluemix_CLI/bin/bluemix login --apikey $BXIAM
./Bluemix_CLI/bin/bluemix target -o $CF_ORGANIZATION -s $CF_SPACE

# Bring in the rules next
./rules.sh

./Bluemix_CLI/bin/bluemix wsk package update $WSK_PACKAGE -p cloudantURL $CLOUDANT_URL -p dbname $QUESTIONS_DB -p slackURL $SLACK_URL -p apikey $STACKOVERFLOW_API_KEY -p hubotURL $HUBOT_URL

./Bluemix_CLI/bin/bluemix wsk action update $WSK_PACKAGE/collector collector/collector.js 

./Bluemix_CLI/bin/bluemix wsk action update --kind nodejs:6 $WSK_PACKAGE/invoker invoker/invoker.js

# create a sequence of both actions
./Bluemix_CLI/bin/bluemix wsk action update $WSK_PACKAGE/socron --sequence $WSK_PACKAGE/collector,$WSK_PACKAGE/invoker


# actions for store and notify, and a sequence for those

./Bluemix_CLI/bin/bluemix wsk action update $WSK_PACKAGE/storer storer/storer.js
./Bluemix_CLI/bin/bluemix wsk action update $WSK_PACKAGE/notifier notifier/notifier.js

./Bluemix_CLI/bin/bluemix wsk action update $WSK_PACKAGE/qhandler --sequence $WSK_PACKAGE/storer,$WSK_PACKAGE/notifier
