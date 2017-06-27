#!/bin/bash

./wsk package update $WSK_PACKAGE

./wsk action update $WSK_PACKAGE/collector collector/collector.js 

./wsk action update --kind nodejs:6 $WSK_PACKAGE/invoker invoker/invoker.js

# create a sequence of both actions
./wsk action update $WSK_PACKAGE/socron --sequence $WSK_PACKAGE/collector,$WSK_PACKAGE/invoker


# actions for store and notify, and a sequence for those

./wsk action update $WSK_PACKAGE/storer storer/storer.js
./wsk action update $WSK_PACKAGE/notifier notifier/notifier.js

./wsk action update $WSK_PACKAGE/qhandler --sequence $WSK_PACKAGE/storer,$WSK_PACKAGE/notifier
