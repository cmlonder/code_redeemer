#!/bin/sh

# wait for server
sh ./waitforserver.sh
echo "Model: Code"

getModel() {
    result=$(curl -LI localhost:1337/codes -o /dev/null -w '%{http_code}\n' -s)
    echo "$result"
}

status=$( getModel )

if [[ "$status" == "200" ]];
then
    echo "Model already exist, not creating new model";
elif [[ "$status" == "404" ]];
then
    echo "Creating model...";
    (cd strapi-app && strapi generate:api code description:text valid:boolean summary:text)
else
    echo "Can not create model. Status: $status"
fi
