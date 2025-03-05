
#!/bin/bash

# Cambiar el prompt temporalmente
export PS1="Sense@$(whoami)> "
HISTFILE="/home/$(whoami)/SENSE/Program_Files/SHELL_HISTORY"
HISTSIZE=1000
SAVEHIST=1000

if [ ! -d "/home/$(whoami)/SENSE/Program_Files" ]; then
    	mkdir -p "/home/$(whoami)/SENSE/Program_Files"
fi

# Verificar si el archivo de historial existe, si no, crearlo
if [ ! -f "$HISTFILE" ]; then
    	touch "$HISTFILE"
fi

# Cargar el historial si existe
history -r "$HISTFILE"
echo "Bienvenido a SENSE"
trap 'echo " Proceso interrumpido"; continue' SIGINT

space() {
    	echo "Espacio en disco disponible:"
    	df -h
}
memory() {
    	echo "Uso de la memoria:"
    	free -h
}
services() {
    	echo "Estado de los servicios:"
    	systemctl --type=service --state=running
}
cpu() {
    	echo "Uso de la CPU:"
    	top -n 1 | grep "Cpu(s)"
}
find-file() {
    	echo "Introduce el nombre del archivo a buscar:"
    	read archivo
    	find / -name "$archivo" 2>/dev/null
	if [ -z "$resultados" ]; then
        	echo "Error: No se encontró el archivo '$archivo'."
    	else
        	echo "Archivo(s) encontrado(s):"
        	echo "$resultados"
    	fi
}
processes() {
    	echo "Procesos en ejecución del usuario $(whoami) con su PID:"
    	ps aux --sort=%mem | grep "$(whoami)" | awk '{print $1, $2, $11}'  # Filtra por el usuario actual
}
order-66() {
    	pid=$1  # Se pasa el PID como argumento de la función
    	if [ -z "$pid" ]; then
        	echo "Error: No se ha proporcionado un PID."
        	return 1
    	fi
    	if kill -0 $pid 2>/dev/null; then  # Verifica si el proceso existe
        	kill $pid
        	echo "Proceso $pid eliminado."
    	else
        	echo "Error: El PID $pid no existe o no se puede eliminar."
    	fi
}
system-run() {
    	echo "El sistema ha estado en funcionamiento durante:"
    	uptime -p
}
active-connections() {
    	echo "Conexiones de red activas:"
    	netstat -tuln  # Muestra todas las conexiones de red activas
}
processes-memory() {
    	echo "Procesos más intensivos en memoria:"
    	ps aux --sort=-%mem | head -n 10  # Muestra los 10 procesos que más memoria consumen
}
processes-cpu() {
    	echo "Procesos más intensivos en CPU:"
    	ps aux --sort=-%cpu | head -n 10  # Muestra los 10 procesos que más CPU consumen
}
help-sense() {
    	# Obtener el nombre del usuario actual
    	user=$(whoami)

    	# Verificar si el archivo index.html existe
    	if [ -f "/home/$user/SENSE/index.html" ]; then
        	# Abrir el archivo en el navegador predeterminado
        	lynx "/home/$user/SENSE/index.html"
        	echo "Abriendo el archivo index.html..."
    	else
        	echo "Error: El archivo /home/$user/SENSE/index.html no se encuentra."
    	fi
}
# Bucle para ejecutar comandos
while true; do
    	# Leer entrada del usuario
    	read -e -p "$PS1" cmd
    	case "$cmd" in
        "space") space ;;
        "memory") memory ;;
        "services") services ;;
        "cpu") cpu ;;
        "find-file") find-file ;;
	"processess") processess ;;
	"order-66"*) 	pid=$(echo $cmd | awk '{print $2}')
            		order-66 $pid
			;;
	"system-run") system-run ;;
	"active-connections") active-connections ;;
	"processes-memory") processes-memory ;;
	"processes-cpu") processes-cpu ;;
	"help-sense") help-sense ;;
        "exit") break ;;
        *)
            # Guardar comando en el historial y ejecutar cualquier otro comando
            echo "$cmd" >> "$HISTFILE"
            history -s "$cmd"
            eval "$cmd"
            ;;
    esac
done

# Restaurar el prompt original
export PS1="\u@\h:\w$ "
