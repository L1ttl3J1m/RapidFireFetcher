#!/bin/bash

#############################################
#											#
#         Zero All the Variables!           #
#											#
#############################################
DIRSTR=.        #          Is the directory the script runs in
YEAR=2016 		#          Year counter for the date process
DAY=000			#	   Day counter for the date process
DATESTAMP=000   #	   YYYY-MMM-DD stamp for labeling the images at line 51
IMAGE=" "       #          Name of our images
CENTAGE=0		#          Used for holding percentage of white on images


for (( YEAR=2004; YEAR<=2016; YEAR++ ))                 # Ends on line 92
do
for (( DAY=1; DAY<=65; DAY++))
do
STAMPY="$(date -d "`date +$YEAR` -01-01 +$(( ${DAY} -1 ))days" +$YEAR-%m-%d)"
DATESTAMP="$(date -d "`date +$YEAR` -01-01 +$(( ${DAY} -1 ))days" +$YEAR-%b-%d)"
# Fetch the image

gdal_translate -of GTiff -outsize 3840 2880 -projwin 134.58420604198 -22.661754774206 144.11019468423 -29.136863038477 '<GDAL_WMS>
<Service name="TMS">
<ServerUrl>http://map1.vis.earthdata.nasa.gov/wmts-geo/MODIS_Terra_CorrectedReflectance_TrueColor/default/'${STAMPY}'/EPSG4326_250m/${z}/${y}/${x}.jpg</ServerUrl>
</Service>

<DataWindow>
<UpperLeftX> -180.0 </UpperLeftX>  <UpperLeftY>    90 </UpperLeftY>
<LowerRightX> 396.0 </LowerRightX> <LowerRightY> -198 </LowerRightY>
<TileLevel>8</TileLevel>
<TileCountX>2</TileCountX>
<TileCountY>1</TileCountY>
<YOrigin>top</YOrigin>
</DataWindow>
<Projection>EPSG:4326</Projection>
<BlockSizeX>512</BlockSizeX>
<BlockSizeY>512</BlockSizeY>
<BandsCount>3</BandsCount>
</GDAL_WMS>' $DIRSTR/AERONET_$STAMPY.TIF

# gdal_translate -of JPEG $DIRSTR/AERONET_Birdsville.tif $DIRSTR/AERONET_$STAMPY.jpg

IMAGE=AERONET_$STAMPY.TIF        	# Set IMAGE to the filename

# Print Datestamp in lower left corner. 
echo $IMAGE								
echo $DATESTAMP

convert $IMAGE -gravity southwest -stroke '#000C' -pointsize 50 -strokewidth 3 -fill blue -annotate 0 `echo $DATESTAMP` $IMAGE
					#
					# Change gravity if focussing on a different area in the next convert statement
					# (southwest,southeast,northeast,northwest - see man convert for more)
               

#########################################################################
#																		#
#	Adding "-crop 1920x1200+0+0 -sharpen 25" to the convert line		#
#	will focus on the bottom left corner of the image               	#
#																		#
#     Do this before you calculate white area, because coverage will  	#
#     vary depending on what area you are focussing on.					#
#																		#
#    Change the values of the -crop section to your preference			#
#    Or, swap commented lines to use whole swathe						#
#   N.B. Add -vf scale to mencoder command on line 75 if you do this 	#
#																		#
#########################################################################

 		
CENTAGE=`convert $IMAGE -colorspace gray -format "%[fx:100*mean]" info:` # Calculate the amount of white in the image

echo $CENTAGE "percent of "$IMAGE" is obscured" 

#  Reduce to integer and test if the amount of white is less than %40
CENTAGE=$( printf "%.0f" $CENTAGE )				

# If the amount of white is less than 40, add the name of this image to the list of images to be included in the movie
if [ $CENTAGE -lt 40 ]; then  echo $IMAGE >> list.txt

else

echo "Not that one!"

rm $IMAGE

fi		# End of IF from line 62


echo "Sleeping..."						# Short delay before we begin again (It's the polite thing to do)

sleep 20 

done
done
						# End of FOR-DO loop from line 16

# mencoder mf://@list.txt -noskip -ovc lavc -lavcopts vpass=1:vbitrate=4192:vcodec=mjpeg:keyint=1:vb_strategy=1:bidir_refine=4:vqcomp=0.7:subcmp=2:last_pred=4:preme=2:aic:turbo -fps 15 -nosound -o Output.avi

# Add -vf scale=1440:960 between -noskip and -ovc if you commented out the crop convert at line 52
