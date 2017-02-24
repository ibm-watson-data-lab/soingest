#!/bin/bash

# This sets up the rules and triggers to get our periodic triggers working

wsk trigger delete so_couchdbish
wsk trigger create so_couchdbish --feed /whisk.system/alarms/alarm --param cron "*/5 * * * *" --param trigger_payload "{\"tags\": [\"cloudant\",\"ibm-cloudant\",\"couchdb\"]}"
wsk rule update so_couchdbrule so_couchdbish stackoverflow/socron
wsk rule enable so_couchdbrule

wsk trigger delete so_composedbs
wsk trigger create so_composedbs --feed /whisk.system/alarms/alarm --param cron "8 * * * *" --param trigger_payload "{\"tags\": [\"postgresql\", \"redis\", \"scylladb\", \"etcd\", \"rabbitmq\"]}"
wsk rule update so_composerule so_composedbs stackoverflow/socron
wsk rule enable so_composerule

wsk trigger delete so_moredbs
wsk trigger create so_moredbs --feed /whisk.system/alarms/alarm --param cron "38 * * * *" --param trigger_payload "{\"tags\": [\"spark\", \"apache-spark\", \"dashdb\"]}"
wsk rule update so_morerule so_moredbs stackoverflow/socron
wsk rule enable so_morerule


