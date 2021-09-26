#!/bin/bash

# PDF from LaTeX
#
# (c) Raúl Peña Ortiz <raul.penya@uv.es>
#

input_file=$1
prefix=`echo $input_file | sed 's/\.[^.]*$//'`

logfile=/tmp/$prefix.log
pdf_cmd="pdflatex -shell-escape"
bib_cmd=/usr/local/texlive/2020/bin/x86_64-darwin/bibtex
pdf_options="\pdfcompresslevel19 \input"
pdf_options=""
output=$prefix".pdf"


echo "Procesamiento latex inicial ...";
$pdf_cmd "$pdf_options" > $logfile $input_file

bibauxfiles=`ls *.aux`

if [ -n "$bibauxfiles" ]
then
   echo "Procesamiento de bibliografia ...";

   for bibaux in $bibauxfiles
   do
       $bib_cmd $bibaux >> $logfile 
   done
   $pdf_cmd "$pdf_options" > $logfile $input_file
fi

echo "Procesamiento de glosario ...";

makeglossaries $prefix >> $logfile 2>> $logfile

# Para añadirlo al ToC
$pdf_cmd "$pdf_options" >> $logfile 2> $logfile $input_file

echo "Procesamiento de acabado ...";
$pdf_cmd "$pdf_options" >> $logfile 2> $logfile $input_file