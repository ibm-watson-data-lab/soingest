#!/bin/bash


wsk action update stackoverflow/collector collector/collector.js 

cd pubwriter
rm pubwriter.zip
zip -r pubwriter.zip pubwriter.js package.json node_modules
cd -

wsk action update --kind nodejs:6 stackoverflow/pubwriter pubwriter/pubwriter.zip


# create a sequence of both actions
wsk action update stackoverflow/socron --sequence stackoverflow/collector,stackoverflow/pubwriter
