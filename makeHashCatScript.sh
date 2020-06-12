#!/bin/bash

RAW_SHADOW="$(tr -d " \t\n" <shadowhash | tr -s "<>" "\n\n")"

ITERATION_LINES="$(echo "$RAW_SHADOW" | grep -n iterations | cut -d: -f1)"
SALT_LINES="$(echo "$RAW_SHADOW" | grep -n salt | cut -d: -f 1)"
ENTROPY_LINE="$(echo "$RAW_SHADOW" | grep -n entropy | cut -d: -f 1)"

SAMPLES="$(echo "$SALT_LINES" | wc -l)"
ENTROPY_HEX="$(echo "$RAW_SHADOW" | head -$(($ENTROPY_LINE + 3)) | tail -1 | base64 -D | xxd | cut -d " " -f 2-9 | tr -d " \n")"

for (( c=1; c <= $SAMPLES; c++))
do
	ITERATION_LINE="$(echo "$ITERATION_LINES" | head -$c | tail -1)"
	SALT_LINE="$(echo "$SALT_LINES" | head -$c | tail -1)"

	ITERATION="$(echo "$RAW_SHADOW" | head -$(($ITERATION_LINE + 3)) | tail -1)"
	SALT_HEX="$(echo "$RAW_SHADOW" | head -$(($SALT_LINE + 3)) | tail -1 | base64 -D | xxd | cut -d " " -f 2-9 | tr -d " \n")"

	echo -e "\$ml\$$ITERATION\$$SALT_HEX\$$ENTROPY_HEX"
done
