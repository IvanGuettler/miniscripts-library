#!/bin/bash
#03.08.2017. Dodan slovenski radar

#---
#--- Define date
#---
export  DATUM=(`(date -u)`)
export DATUM2=${DATUM[5]}'_'${DATUM[1]}'_'${DATUM[2]}'_'${DATUM[3]}


#---
#--- Select directory
#---
 cd /home/guettler/Crontab_WEB_RADAR
mkdir -p ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}

#---
#--- Get from the meteo.hr
#---
    DIR[1]=arsoradar
    FILEIN[1]=radar.gif

for F in 1 ; do

#Skidam datoteku
    URL=http://www.arso.gov.si/vreme/napovedi%20in%20podatki/${FILEIN[$F]}
    FILEOT=${DATUM2}_${FILEIN[$F]}
    echo $URL
    wget ${URL}

#Ako je datoteke skinuta nastavljam te mala varijacija za pocetak skidanja ili pocetak mjeseca
    if [ -f ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}/grga.txt ]; then
        if [ -f ${FILEIN[$F]} ]; then
             mv ${FILEIN[$F]} ${FILEOT}
             touch ${FILEOT}
             mkdir -p            ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}
#Provjeravam jel ista datoteka vec skinuta
             export  datoteke=(`(ls -t ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}/*${FILEIN[$F]})`)
             export   duljina=${#datoteke[@]}
             export usporedba=(`(diff ${datoteke[0]} ${FILEOT})`)
                 if [ "${usporedba[0]}" = "Binary" ]; then
                    echo "Datoteke se razlikuju pa sve OK"
                    echo ${datoteke[0]}
                    echo ${FILEOT}
                    mv  ${FILEOT} ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}
                 else
                    echo "Datoteke su jedanke pa brisem"
                    echo ${datoteke[0]} 
                    echo ${FILEOT}
                    rm -v ./${FILEOT}
                 fi
        fi
    else
        if [ -f ${FILEIN[$F]} ]; then
             touch               ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}/grga.txt
             mv ${FILEIN[$F]} ${FILEOT}
             touch ${FILEOT}
             mkdir -p            ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}
#Provjeravam jel ista datoteka vec skinuta
             mv  ${FILEOT} ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}/${DIR[$F]}
        fi
    fi
done
