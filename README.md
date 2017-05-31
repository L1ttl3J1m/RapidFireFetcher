# RapidfireFetcher


This is a Bash script to collect images from the Nasa Earthview satellites (https://worldview.earthdata.nasa.gov) 

Requires the gdal-bin package

Currently collecting images of the Lake Eyre drainage basin in this script, to change, use the -projwin switch in the gdal_translate command.

It processes the images to add a date stamp and produce a list of the images with less than 40 percent cloud cover. It can either keep all images or only the images in the list, as required. Also included is a mencoder command to render the produced list into a video

For a sample of the output, see the video "Lake Eyre Timelapse Animation - Five years in one minute" at https://www.youtube.com/watch?v=tvYXzUOsnlI



