#!/bin/bash

# This sets up the rules and triggers to get our periodic triggers working

wsk trigger delete so_couchdbish
wsk trigger create so_couchdbish --feed /whisk.system/alarms/alarm --param cron "*/5 * * * *" --param trigger_payload "{\"tags\": [\"cloudant\",\"ibm-cloudant\",\"pixiedust\", \"dashdb\"]}"
wsk rule update so_couchdbrule so_couchdbish stackoverflow/socron
wsk rule enable so_couchdbrule

wsk trigger delete so_composedbs
wsk rule delete so_composerule

wsk trigger delete so_moredbs
wsk rule delete so_morerule


