#!/bin/bash

# This sets up the rules and triggers to get our periodic triggers working

./wsk trigger delete so_couchdbish
./wsk trigger create so_couchdbish --feed /whisk.system/alarms/alarm --param cron "*/5 * * * *" --param trigger_payload "{\"tags\": [\"cloudant\",\"ibm-cloudant\",\"pixiedust\"]}"
./wsk rule update so_couchdbrule so_couchdbish stackoverflow/socron
./wsk rule enable so_couchdbrule

./wsk trigger delete so_compose
./wsk trigger create so_compose --feed /whisk.system/alarms/alarm --param cron "7,27,47 * * * *" --param trigger_payload "{\"tags\": [\"compose\", \"compose.io\"]}"
./wsk rule update so_composerule so_compose stackoverflow/socron
./wsk rule enable so_composerule

