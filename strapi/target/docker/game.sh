#!/bin/sh

# wait for server
sh ./waitforserver.sh
echo "Model: Game"

# TODO: make head
getModel() {
    result=$(curl -LI localhost:1337/games -o /dev/null -w '%{http_code}\n' -s)
    echo "$result"
}

status=$( getModel )

if [[ "$status" == "200" ]];
then
    echo "Model already exist, not creating new model";
elif [[ "$status" == "404" ]];
then
    echo "Creating model...";
    (cd strapi-app && strapi generate:api game name:string icon:string)
else
    echo "Can not create model. Status: $status"
fi
