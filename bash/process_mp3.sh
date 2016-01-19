#!/bin/bash

echo "Processing mp3 folders"

find . -maxdepth 1 -mindepth 1 -type d | while read d; do
  echo "[${d}]"
  pushd "${d}" &> /dev/null
  find . -type f -name '*.par2' | while read f; do
    par2repair "${f}" &> /dev/null && {
      find . -type f ! -name '*.mp3' ! -name "*.jpg" | while read f; do
        rm -f "${f}"
      done
      find . -type f -name '*.mp3' | while read f; do
        replaygain "${f}"
      done
    }
  done
  popd &> /dev/null
done

echo "Done."
