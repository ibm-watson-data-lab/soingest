#!/bin/bash

wsk activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs wsk activation logs
# wsk activation list -l1 | grep "^[0-9a-f]\{32\}" | cut -c1-32 | xargs wsk activation logs

