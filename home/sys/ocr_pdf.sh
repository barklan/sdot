#!/usr/bin/env bash

# First arg is language, second is filename without extension.
# To force ocr with text layer already present add --force-ocr
# To build image create Dockerfile with following:
#
# FROM jbarlow83/ocrmypdf
# RUN apt update && apt install tesseract-ocr-rus
#
# ...and build it:
# docker build -t ocr:local .
#
# Consider using --oversample 600 --clean
docker run --rm -v "$(pwd):/data" -w /data -i ocr:local --force-ocr -l "$1" "/data/$2" "/data/ocr_$2"
