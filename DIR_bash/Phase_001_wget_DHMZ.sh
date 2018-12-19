#!/bin/bash
#13.11.2013. dodana kamera na Zavizanu
#20.11.2014. dodana CHyM prognoza
#11.02.2016. maknuto dosta materijala. Ostaju web kamere i radari. 
#11.02.2016. precao na novo racunalo

#---
#--- Define date
#---
export  DATUM=(`(date -u)`)
export DATUM2=${DATUM[5]}'_'${DATUM[1]}'_'${DATUM[2]}'_'${DATUM[3]}


#---
#--- Select directory
#---
#cd /home/ivan/Desktop/2013_DownloadMeteo
 cd /home/guettler/Crontab_WEB_RADAR
mkdir -p ${DATUM[5]}/${DATUM[1]}/${DATUM[2]}

#---
#--- Get from the meteo.hr
#---
    DIR[1]=bradar
    DIR[2]=oradar
#   DIR[3]=kradar
    DIR[4]=zggric
    DIR[5]=split
#   DIR[6]=irc-sat
    DIR[7]=zavizan
#   DIR[8]=chym
    FILEIN[1]=bradar.gif
    FILEIN[2]=oradar.gif
#   FILEIN[3]=kradar.gif
    FILEIN[4]=zggric.jpg
    FILEIN[5]=split.jpg
#   FILEIN[6]=irc-sat.gif
    FILEIN[7]=zav.jpg
#   FILEIN[8]=alg3001.gif

for F in 1 2 4 5 7 ; do

#Skidam datoteku
    if [ ${F} != 8 ]; then
    URL=http://vrijeme.hr/${FILEIN[$F]}
    fi
    if [ ${F} = 8 ]; then
    URL=http://cetemps.aquila.infn.it/chymop/domain11/${FILEIN[$F]}
    fi
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
