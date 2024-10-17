#!/bin/bash

#Execusió del primer awk
awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

#Pregunta 1
cut -d',' -f12,16 --complement supervivents.csv >> sortida1.csv 

#Pregunta 2
cut -d',' -f 14 sortida1.csv | grep True | wc -l
awk -F, '$14 != "True" {print $0}' sortida1.csv > sortida2.csv

#Pregunta 3
awk -F, 'BEGIN { OFS = "," } 
NR == 1 { print $0, "Ranking_Views"; next }
{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else if ($8 > 10000000) ranking="Estrella";
    print $0, ranking;
}' sortida2.csv > sortida3.csv

#Pregunta 4
n=1
while read lin; do
    if [ $n -eq 1 ]; then
        echo "$lin,Rlikes,Rdislikes"
        n=$((n+1))
    else
        views=$(echo $lin | cut -d',' -f8)
        likes=$(echo $lin | cut -d',' -f9)
        dislikes=$(echo $lin | cut -d',' -f10)
        percent_likes=$(( ($likes*100)/$views ))
        percent_dislikes=$(( ($dislikes*100)/$views )) 
        echo "$lin,$percent_likes,$percent_dislikes"
    fi
done < sortida3.csv > sortida.csv

#Eliminació dels arxius auxiliars
rm sortida1.csv sortida2.csv sortida3.csv

#Pregunta 5
echo "Introdueix el títol o l'identificador del vídeo que desitges buscar"
read video

if [ ! -f "sortida.csv" ]; then
    echo "Error: El fitxer sortida.csv no existeix."
else
	match=$(grep -i "$video" sortida.csv)
	if [ -z "$match" ]; then
		echo "No s'han trobat coincidències per a '$video'."
	else
		grep "$video" sortida.csv | cut -d',' -f3,6,8-10,15-17
	fi
fi
