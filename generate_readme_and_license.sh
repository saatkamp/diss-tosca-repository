#!/bin/bash

LICENSE_FILE_PATH=$1
COPYRIGHT_OWNER=${2:-"University of Stuttgart"}
CURRENT_YEAR=$(date +"%Y")

if [ ! -f "$LICENSE_FILE_PATH" ]; then
    echo "LICENSE file not found at $LICENSE_FILE_PATH. Downloading from Apache website..."
    wget -O LICENSE https://www.apache.org/licenses/LICENSE-2.0.txt
    LICENSE_FILE_PATH="./LICENSE"
fi

folders=$(find . -mindepth 3 -maxdepth 3 -type d)

for dir in $folders; do
    cp $LICENSE_FILE_PATH $dir
    sed -i "s/Copyright \[yyyy\] \[name of copyright owner\]/Copyright $CURRENT_YEAR $COPYRIGHT_OWNER/" $dir/LICENSE
    current_folder=$(basename $dir)
    echo "# $current_folder [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)" > $dir/README.md
    echo "" >> $dir/README.md
    tosca_files=$(find $dir -name '*.tosca')
    if [ $(echo $tosca_files | wc -w) -gt 0 ]; then
        echo "## Properties" >> $dir/README.md
        echo "" >>$dir/README.md
        keys=$(awk -F '<|>' '/<[^:]*:key>/ {print $3}' $tosca_files)
        for key in $keys; do
            echo "* \`$key\`" >> $dir/README.md
        done
        echo "" >> $dir/README.md
    fi
    echo "## Haftungsausschluss" >> $dir/README.md
    echo "" >> $dir/README.md
    echo "Dies ist ein Forschungsprototyp und enthält insbesondere Beiträge von Studenten.
Diese Software enthält möglicherweise Fehler und funktioniert möglicherweise, insbesondere bei variierten oder neuen
  Anwendungsfällen, nicht richtig.
Insbesondere beim Produktiveinsatz muss 1. die Funktionsfähigkeit geprüft und 2. die Einhaltung sämtlicher Lizenzen geprüft werden.
Die Haftung für entgangenen Gewinn, Produktionsausfall, Betriebsunterbrechung, entgangene Nutzungen, Verlust von Daten
 und Informationen, Finanzierungsaufwendungen sowie sonstige Vermögens- und Folgeschäden ist, außer in Fällen von grober
 Fahrlässigkeit, Vorsatz und Personenschäden ausgeschlossen." >> $dir/README.md
    echo "" >> $dir/README.md
    echo "## Disclaimer of Warranty" >> $dir/README.md
    echo "Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor
 provides its Contributions) on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT,
 MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE.
You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks
 associated with Your exercise of permissions under this License." >> $dir/README.md
done
