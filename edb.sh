#!/bin/bash
# intent: enter last failed docker build image
# WIP
# TAG="user:herokuplay.build"

BIMAGE=herokuplay-build
BTAG=$BIMAGE:latest
# BID=$(docker build -q -t $BTAG --target build . --progress=plain)
docker build -q -t "$BTAG" --target build . # --progress=plain

BID=(docker ps -aqf "name=$BTAG")

# docker run -t $TAG -a stdin -a stdout -i /bin/bash
echo Build ID for $BTAG was $BID
RIMAGE=herokuplay-run
RTAG=$RIMAGE:latest

# RID=$(docker build -q -t $RTAG --target runtime . --progress=plain)
docker build -q -t "$RTAG" --target runtime . --progress=plain
# another option
RID=$(docker inspect --format="{{.Id}}" $RTAG)
echo Run ID for $RTAG was $RID
echo "docker run next"

#worked
# docker run -a stdin -a stdout -i -t $TAG ls
# docker run -a stdin -a stdout -i -t $TAG ls /bin
# docker container run -it user:herokuplay.build /bin/bash
#end worked
# docker run -a stdin -a stdout -a stderr -i -t $TAG /code/app/dockerdiag.sh

echo "docker run done"
