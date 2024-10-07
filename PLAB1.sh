#!/bin/bash

awk -F, 'BEGIN { OFS = "," } 
NR == 1 { print $0, "Ranking_Views"; next }
{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else if ($8 > 10000000) ranking="Estrella";
    print $0, ranking;
}' sortida.csv > sortida3.csv
