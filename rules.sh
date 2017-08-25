#!/bin/bash

# This sets up the rules and triggers to get our periodic triggers working

# Maxiumum of five tags per search
./wsk trigger delete so_couchdbish
./wsk trigger create so_couchdbish --feed /whisk.system/alarms/alarm --param cron "*/5 * * * *" --param trigger_payload "{\"tags\": [\"cloudant\",\"ibm-cloudant\",\"pixiedust\",\"data-science-experience\"]}"
./wsk rule update so_couchdbrule so_couchdbish stackoverflow/socron
./wsk rule enable so_couchdbrule

# A less frequent search for compose
./wsk trigger delete so_compose
./wsk trigger create so_compose --feed /whisk.system/alarms/alarm --param cron "7,27,47 * * * *" --param trigger_payload "{\"tags\": [\"compose\", \"compose.io\"]}"
./wsk rule update so_composerule so_compose stackoverflow/socron
./wsk rule enable so_composerule

# the AND searches each need their own entry
# spark search
./wsk trigger delete so_spark
./wsk trigger create so_spark --feed /whisk.system/alarms/alarm --param cron "2,22,42 * * * *" --param trigger_payload "{\"tags\": [\"apache-spark\", \"ibm-bluemix\"], \"search_type\": \"and\"}"
./wsk rule update so_sparkrule so_spark stackoverflow/socron
./wsk rule enable so_sparkrule

# juptyer search
./wsk trigger delete so_jupyter
./wsk trigger create so_jupyter --feed /whisk.system/alarms/alarm --param cron "9,29,49 * * * *" --param trigger_payload "{\"tags\": [\"jupyter-notebooks\", \"ibm-bluemix\"], \"search_type\": \"and\"}"
./wsk rule update so_jupyterrule so_jupyter stackoverflow/socron
./wsk rule enable so_jupyterrule

