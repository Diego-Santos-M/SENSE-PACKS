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
    echo "Error: No se ha instalado SENSE."
    exit 1
fi

Salir=0
while [ $Salir -eq 0 ]; do
    	echo "¿Estás seguro que quieres desinstalar SENSE? (si/no)"
    	read Respuesta
    	Respuesta=$(echo "$Respuesta" | tr 'A-Z' 'a-z')  # Convertir a minúsculas
    	if [[ "$Respuesta" == "si" || "$Respuesta" == "no" ]]; then
        	Salir=1
    	else
        	echo "Solo se admite si/no"
    	fi
done

if [ "$Respuesta" = "si" ]; then
    	echo "Eliminando carpetas carpetas..."
	for usuario in /home/*; do
        	rm -rf "$usuario/$NOMBRE_CARPETA"
                ALIAS_CMD="alias uninstall-sense='sudo bash $usuario/SENSE/Program_Files/uninstall.sh'"

                if grep -Fxq "$ALIAS_CMD" /etc/bash.bashrc; then
                        sed -i "\|$ALIAS_CMD|d" /etc/bash.bashrc
                        echo "Alias eliminado de /etc/bash.bashrc"
                fi
	done
        echo "Las carpetas han sido eliminadas"

elif [ "$Respuesta" = "no" ]; then
    	echo "Desinstalación cancelada."
fi

