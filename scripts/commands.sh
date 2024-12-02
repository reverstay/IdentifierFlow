#!/bin/sh
set -e

sh /scripts/collectstatic.sh
sh /scripts/migrate.sh
sh /scripts/runserver.sh
