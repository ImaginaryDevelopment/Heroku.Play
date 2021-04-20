#!/bin/bash
# intent: enter last failed docker build image
# WIP
TAG="user:herokuplay.build"
docker build -t $TAG --target build .
