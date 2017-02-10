#!/bin/bash

wsk package update stackoverflow

wsk action update stackoverflow/collector collector/collector.js 

wsk action update --kind nodejs:6 stackoverflow/invoker invoker/invoker.js

# create a sequence of both actions
wsk action update stackoverflow/socron --sequence stackoverflow/collector,stackoverflow/invoker


# actions for store and notify, and a sequence for those

wsk action update stackoverflow/storer storer/storer.js
wsk action update stackoverflow/notifier notifier/notifier.js

wsk action update stackoverflow/qhandler --sequence stackoverflow/storer,stackoverflow/notifier
