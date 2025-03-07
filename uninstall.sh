#!/bin/bash
NOMBRE_CARPETA="SENSE"
EXISTE=0

for usuario in /home/*; do
    if [ -d "$usuario/$NOMBRE_CARPETA" ]; then
        EXISTE=1
        break
    fi
done

if [ $EXISTE -eq 0 ]; then
    echo "Error: SENSE is not installed."
    exit 1
fi

Salir=0
while [ $Salir -eq 0 ]; do
    	echo "Are you sure you want to uninstall SENSE (y/n)?”"
    	read Respuesta
    	Respuesta=$(echo "$Respuesta" | tr 'A-Z' 'a-z')  # Convertir a minúsculas
    	if [[ "$Respuesta" == "y" || "$Respuesta" == "n" ]]; then
        	Salir=1
    	else
        	echo "Only y/n is allowed"
    	fi
done

if [ "$Respuesta" = "y" ]; then
    	echo "Deleting folders, subfolders, files and images....."
	echo "Removing aliases...."
	for usuario in /home/*; do
        	rm -rf "$usuario/$NOMBRE_CARPETA"
                ALIAS_CMD="alias uninstall-sense='sudo bash $usuario/SENSE/Program_Files/uninstall.sh'"
		ALIAS_CMD_SENSE="alias SENSE='bash $usuario/SENSE/Program_Files/comandossc.sh'"

                if grep -Fxq "$ALIAS_CMD" /etc/bash.bashrc; then
                        sudo sed -i "\|$ALIAS_CMD|d" /etc/bash.bashrc
                fi
		if grep -Fxq "$ALIAS_CMD_SENSE" /etc/bash.bashrc; then
        		sudo sed -i "\|$ALIAS_CMD_SENSE|d" /etc/bash.bashrc
    		fi
	done
        echo "SENSE has been uninstalled"

elif [ "$Respuesta" = "n" ]; then
    	echo "Uninstallation cancelled."
fi

