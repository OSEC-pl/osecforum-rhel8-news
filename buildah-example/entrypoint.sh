#!/bin/bash
/usr/bin/nc -vv --exec /usr/bin/bc --max-conns 10 -l 7777 --keep-open --output /logs/dump --append-output

