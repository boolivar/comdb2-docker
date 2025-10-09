#!/bin/sh
pmux -n && exec comdb2 "$@" "$DBNAME"