#!/bin/bash

# This sets up the rules and triggers to get our periodic triggers working

# Maxiumum of five tags per search
./Bluemix_CLI/bin/bluemix wsk trigger delete so_couchdbish
./Bluemix_CLI/bin/bluemix wsk trigger create so_couchdbish --feed /whisk.system/alarms/alarm --param cron "*/5 * * * *" --param trigger_payload "{\"tags\": [\"cloudant\",\"ibm-cloudant\",\"pixiedust\",\"data-science-experience\"]}"
./Bluemix_CLI/bin/bluemix wsk rule update so_couchdbrule so_couchdbish $WSK_PACKAGE/socron
./Bluemix_CLI/bin/bluemix wsk rule enable so_couchdbrule

# A less frequent search for compose
./Bluemix_CLI/bin/bluemix wsk trigger delete so_compose
./Bluemix_CLI/bin/bluemix wsk trigger create so_compose --feed /whisk.system/alarms/alarm --param cron "7,27,47 * * * *" --param trigger_payload "{\"tags\": [\"compose\", \"compose.io\"]}"
./Bluemix_CLI/bin/bluemix wsk rule update so_composerule so_compose $WSK_PACKAGE/socron
./Bluemix_CLI/bin/bluemix wsk rule enable so_composerule

# the AND searches each need their own entry
# spark search
./Bluemix_CLI/bin/bluemix wsk trigger delete so_spark
./Bluemix_CLI/bin/bluemix wsk trigger create so_spark --feed /whisk.system/alarms/alarm --param cron "2,22,42 * * * *" --param trigger_payload "{\"tags\": [\"apache-spark\", \"ibm-bluemix\"], \"search_type\": \"and\"}"
./Bluemix_CLI/bin/bluemix wsk rule update so_sparkrule so_spark $WSK_PACKAGE/socron
./Bluemix_CLI/bin/bluemix wsk rule enable so_sparkrule

# juptyer search
./Bluemix_CLI/bin/bluemix wsk trigger delete so_jupyter
./Bluemix_CLI/bin/bluemix wsk trigger create so_jupyter --feed /whisk.system/alarms/alarm --param cron "9,29,49 * * * *" --param trigger_payload "{\"tags\": [\"jupyter-notebooks\", \"ibm-bluemix\"], \"search_type\": \"and\"}"
./Bluemix_CLI/bin/bluemix wsk rule update so_jupyterrule so_jupyter $WSK_PACKAGE/socron
./Bluemix_CLI/bin/bluemix wsk rule enable so_jupyterrule

# watch events db changes feed
./Bluemix_CLI/bin/bluemix wsk trigger delete so_dbchanges
./Bluemix_CLI/bin/bluemix wsk trigger create so_dbchanges --feed /Lorna.Mitchell_dev/Bluemix_Lorna-Cloudant_Credentials-1/changes --param dbname events

./Bluemix_CLI/bin/bluemix wsk rule update so_dbrule so_dbchanges $WSK_PACKAGE/db-doc-handler
./Bluemix_CLI/bin/bluemix wsk rule enable so_dbrule

