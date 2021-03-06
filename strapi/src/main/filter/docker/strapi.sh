#!/bin/sh
set -ea

_stopStrapi() {
  echo "Stopping strapi"
  kill -SIGINT "$strapiPID"
  wait "$strapiPID"
}

# SIGINT is the interrupt signal. The terminal sends it to the foreground process when the user presses ctrl-c.
# The default behavior is to terminate the process, but it can be caught or ignored.
# The intention is to provide a mechanism for an orderly, graceful shutdown.

# SIGTERM is the termination signal. The default behavior is to terminate the process,
# but it also can be caught or ignored. The intention is to kill the process, gracefully or not,
# but to first allow it a chance to cleanup.

#  Trap allows you to catch signals and execute code when they occur.
#  Signals are asynchronous notifications that are sent to your script when certain events occur.
trap _stopStrapi SIGTERM SIGINT

cd /usr/src/api

APP_NAME=${APP_NAME:-strapi-app}
DATABASE_CLIENT=${DATABASE_CLIENT:-mongo}
DATABASE_HOST=${DATABASE_HOST:-localhost}
DATABASE_PORT=${DATABASE_PORT:-27017}
DATABASE_NAME=${DATABASE_NAME:-strapi}
DATABASE_SRV=${DATABASE_SRV:-false}
EXTRA_ARGS=${EXTRA_ARGS:-}
DEV_MODE=${DEV_MODE:-true}

if [ ! -f "$APP_NAME/package.json" ]
then
    yarn create strapi-app ${APP_NAME} --dbclient=$DATABASE_CLIENT --dbhost=$DATABASE_HOST --dbport=$DATABASE_PORT --dbsrv=$DATABASE_SRV --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbssl=$DATABASE_SSL --dbauth=$DATABASE_AUTHENTICATION_DATABASE $EXTRA_ARGS
elif [ ! -d "$APP_NAME/node_modules" ]
then
    yarn install --cwd ./$APP_NAME
fi

cd $APP_NAME
if [ "$DEV_MODE" = true ]
then
  echo "Starting application with autoReload enabled ..."
  yarn develop &
else
  echo "Building admin panel and starting application with autoReload disabled ..."
  yarn build
  yarn start &
fi

# cd /usr/src/api
# echo "Creating models if necessary"
# sh ./create_models.sh

strapiPID=$!
wait "$strapiPID"