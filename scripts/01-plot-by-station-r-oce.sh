#!/bin/bash -i
conda activate r-oce

mkdir -p CTD-plots

infile=input/I8S_metadata.tsv

for station in `tail -n+2 $infile | cut -f1 | cut -f1-2 -d- | sort | uniq`; do
       
	stationNo=`echo $station | cut -f2 -d- | sed 's/S//' | sed 's/^0//g'`
	paddedStationNo=`printf  "%05d" ${stationNo#0}`
	maxDepth=`grep $station $infile | cut -f10 | sort -gr | head -n1`

	latTSV=`grep $station $infile | cut -f7 | sort | uniq`
	lonTSV=`grep $station $infile | cut -f6 | sort | uniq`

	#add loop to account for multiple CTD casts per station
	for inputFile in `ls I8S/33RR20070204_$paddedStationNo*stripped.csv`; do

		filestem=`basename $inputFile .stripped.csv`
		dirname=`dirname $inputFile`
	        latCSV=`grep "LATITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
        	lonCSV=`grep "LONGITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
	
		outfile=CTD-plots/$station.$filestem.CTDprofile.pdf

		./scripts/01-make-plots.R $inputFile $maxDepth "CTD Profile for $station (ASVlatlong=$latTSV,$lonTSV; CTDlatlong=$latCSV,$lonCSV)" $outfile input/I8S.$station.tsv 
	
	done 

done

infile=input/I9N_metadata.tsv
  
for station in `tail -n+2 $infile | cut -f1 | cut -f1-2 -d- | sort | uniq`; do

        stationNo=`echo $station | cut -f2 -d- | sed 's/S//' | sed 's/^0//g'`
        paddedStationNo=`printf  "%05d" ${stationNo#0}`
        maxDepth=`grep $station $infile | cut -f10 | sort -gr | head -n1`

        latTSV=`grep $station $infile | cut -f7 | sort | uniq`
        lonTSV=`grep $station $infile | cut -f6 | sort | uniq`

        #add loop to account for multiple CTD casts per station
        for inputFile in `ls I9N/33RR20070322_$paddedStationNo*stripped.csv`; do

                filestem=`basename $inputFile .stripped.csv`
                dirname=`dirname $inputFile`
                latCSV=`grep "LATITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
                lonCSV=`grep "LONGITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`

                outfile=CTD-plots/$station.$filestem.CTDprofile.pdf

                ./scripts/01-make-plots.R $inputFile $maxDepth "CTD Profile for $station (ASVlatlong=$latTSV,$lonTSV; CTDlatlong=$latCSV,$lonCSV)" $outfile input/I9N.$station.tsv

        done

done
