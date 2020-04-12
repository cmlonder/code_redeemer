#!/bin/sh
# This script is waiting for strapi come live by checking the endpoint http://localhost:8080/auth
echo "Waiting for http endpoint is coming up"
timeout -t 300 /bin/sh -c -- 'until $(curl -k --output /dev/null --silent --head --max-time 5 --fail http://localhost:1337/admin); do printf ".";sleep 0.1; done'
printf "\n"

# /dev/null redirects the command standard output to the null device, which is a special device
# which discards the information written to it
# 2>&1 redirects the standard error stream to the standard output stream (stderr = 2, stdout = 1).
# Note that this takes the standard error stream and points it to same location as standard output at that moment.
# This is the reason for the order >/some/where 2>&1 because one needs to first point stdout to somewhere and then point
# stderr to the same location if one wants to combine both streams in the end.

# In practice it prevents any output from the command (both stdout and stderr) from being displayed.
# It's used when you don't care about the command output.
