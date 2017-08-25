#!/usr/bin/env bash

HOST=hadoop-data-01.sidnlabs.nl

#country sizes
impala-shell -i $HOST -f ./select-country-size-legacygtld.sql -o ./select-country-size-legacygtld.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./select-country-size-newgtld.sql -o ./select-country-size-newgtld.csv -B --output_delimiter=, -k


#apwg
impala-shell -i $HOST -f ./apwg/apwg-newgtld-domain-geolocation-count.sql -o ./apwg/apwg-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./apwg/apwg-legacy-domain-geolocation-count.sql -o ./apwg/apwg-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#sbw
impala-shell -i $HOST -f ./stopbadware/sbw-newgtld-domain-geolocation-count.sql -o ./stopbadware/sbw-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./stopbadware/sbw-legacy-domain-geolocation-count.sql -o ./stopbadware/sbw-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#spamhaus
impala-shell -i $HOST -f ./spamhaus/spamhaus-newgtld-domain-geolocation-count.sql -o ./spamhaus/spamhaus-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./spamhaus/spamhaus-legacy-domain-geolocation-count.sql -o ./spamhaus/spamhaus-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#surbl
impala-shell -i $HOST -f ./surbl/surbl-newgtld-domain-geolocation-count.sql -o ./surbl/surbl-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./surbl/surbl-legacy-domain-geolocation-count.sql -o ./surbl/surbl-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#cleanmx-phishing
impala-shell -i $HOST -f ./cleanmx-phishing/cleanmx-phishing-newgtld-domain-geolocation-count.sql -o ./cleanmx-phishing/cleanmx-phishing-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-phishing/cleanmx-phishing-legacy-domain-geolocation-count.sql -o ./cleanmx-phishing/cleanmx-phishing-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#cleanmx-viruses
impala-shell -i $HOST -f ./cleanmx-viruses/cleanmx-viruses-newgtld-domain-geolocation-count.sql -o ./cleanmx-viruses/cleanmx-viruses-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-viruses/cleanmx-viruses-legacy-domain-geolocation-count.sql -o ./cleanmx-viruses/cleanmx-viruses-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#cleanmx-portals
impala-shell -i $HOST -f ./cleanmx-portals/cleanmx-portals-newgtld-domain-geolocation-count.sql -o ./cleanmx-portals/cleanmx-portals-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-portals/cleanmx-portals-legacy-domain-geolocation-count.sql -o ./cleanmx-portals/cleanmx-portals-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k

#sdf
impala-shell -i $HOST -f ./sdf/sdf-newgtld-domain-geolocation-count.sql -o ./sdf/sdf-newgtld-domain-geolocation-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./sdf/sdf-legacy-domain-geolocation-count.sql -o ./sdf/sdf-legacy-gtld-domain-geolocation-count.csv -B --output_delimiter=, -k
