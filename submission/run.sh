#!/usr/bin/bash

echo "XML TO JSON CONVERSION"

awk -f xTj.awk sample.xml

echo "JSON TO XML CONVERSION"

awk -f jTx.awk sample.json
