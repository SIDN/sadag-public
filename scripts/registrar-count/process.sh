#!/usr/bin/env bash

#calc top abusive registrars

HOST=hadoop-data-01.sidnlabs.nl

#registrar sizes

impala-shell -i $HOST -f ./registrar-total-count-new.sql -o ./registrar-newgtld-total-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./registrar-total-count-legacy.sql -o ./registrar-legacygtld-total-count.csv -B --output_delimiter=, -k

#per list

impala-shell -i $HOST -f ./apwg/count-new.sql -o ./apwg/apwg-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./apwg/count-legacy.sql -o ./apwg/apwg-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./cleanmx-phishing/count-new.sql -o ./cleanmx-phishing/cleanmx-phishing-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-phishing/count-legacy.sql -o ./cleanmx-phishing/cleanmx-phishing-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./cleanmx-portals/count-new.sql -o ./cleanmx-portals/cleanmx-portals-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-portals/count-legacy.sql -o ./cleanmx-portals/cleanmx-portals-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./cleanmx-viruses/count-new.sql -o ./cleanmx-viruses/cleanmx-viruses-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./cleanmx-viruses/count-legacy.sql -o ./cleanmx-viruses/cleanmx-viruses-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./spamhaus/count-new.sql -o ./spamhaus/spamhaus-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./spamhaus/count-legacy.sql -o ./spamhaus/spamhaus-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./stopbadware/count-new.sql -o ./stopbadware/stopbadware-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./stopbadware/count-legacy.sql -o ./stopbadware/stopbadware-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./surbl/count-new.sql -o ./surbl/surbl-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./surbl/count-legacy.sql -o ./surbl/surbl-registrar-legacygtld-count.csv -B --output_delimiter=, -k

impala-shell -i $HOST -f ./sdf/count-new.sql -o ./sdf/sdf-registrar-newgtld-count.csv -B --output_delimiter=, -k
impala-shell -i $HOST -f ./sdf/count-legacy.sql -o ./sdf/sdf-registrar-legacygtld-count.csv -B --output_delimiter=, -k

#alpnames
impala-shell --print_header -i $HOST -f ./registrar/alpnames/spamhaus-alpnames-gtld-per-tld-new.sql -o ./registrar/alpnames/spamhaus-alpnames-new-gtld-count.csv -B --output_delimiter=, -k
impala-shell --print_header -i $HOST -f ./registrar/alpnames/spamhaus-alpnames-gtld-per-tld-legacy.sql -o ./registrar/alpnames/spamhaus-alpnames-legacy-gtld-count.csv -B --output_delimiter=, -k

impala-shell --print_header -i $HOST -f ./registrar/alpnames/surbl-alpnames-gtld-per-tld-new.sql -o ./registrar/alpnames/surbl-alpnames-new-gtld-count.csv -B --output_delimiter=, -k
impala-shell --print_header -i $HOST -f ./registrar/alpnames/surbl-alpnames-gtld-per-tld-legacy.sql -o ./registrar/alpnames/surbl-alpnames-legacy-gtld-count.csv -B --output_delimiter=, -k

#nanjing
impala-shell --print_header -i $HOST -f ./registrar/Nanjing-Imperiosus-Technology/spamhaus-Nanjing-Imperiosus-Technology-new.sql -o ./registrar/Nanjing-Imperiosus-Technology/spamhaus-new-gtld-Nanjing-Imperiosus-Technology.csv -B --output_delimiter=, -k
impala-shell --print_header -i $HOST -f ./registrar/Nanjing-Imperiosus-Technology/spamhaus-Nanjing-Imperiosus-Technology-legacy.sql -o ./registrar/Nanjing-Imperiosus-Technology/spamhaus-legacy-gtld-Nanjing-Imperiosus-Technology.csv -B --output_delimiter=, -k

impala-shell --print_header -i $HOST -f ./registrar/Nanjing-Imperiosus-Technology/surbl-Nanjing-Imperiosus-Technology-new.sql -o ./registrar/Nanjing-Imperiosus-Technology/surbl-new-gtld-Nanjing-Imperiosus-Technology.csv -B --output_delimiter=, -k
impala-shell --print_header -i $HOST -f ./registrar/Nanjing-Imperiosus-Technology/surbl-Nanjing-Imperiosus-Technology-legacy.sql -o ./registrar/Nanjing-Imperiosus-Technology/surbl-legacy-gtld-Nanjing-Imperiosus-Technology.csv -B --output_delimiter=, -k





