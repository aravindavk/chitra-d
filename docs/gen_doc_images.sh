#!/usr/bin/bash

for file in _gallery/source/*.d
do
  dub $file;
done

for file in static/images/*.png
do
    convert $file -resize "800>" $file;
    convert $file -resize "400>" static/images/thumbs/$(basename $file);
done
