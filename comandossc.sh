
#!/bin/bash

export PS1="Sense@$(whoami)> "
HISTFILE="/home/$(whoami)/SENSE/Program_Files/SHELL_HISTORY"
HISTSIZE=1000
SAVEHIST=1000

if [ ! -d "/home/$(whoami)/SENSE/Program_Files" ]; then
    	mkdir -p "/home/$(whoami)/SENSE/Program_Files"
fi

if [ ! -f "$HISTFILE" ]; then
    	touch "$HISTFILE"
fi

history -r "$HISTFILE"
echo "Welcome to SENSE"
trap 'echo " Process interrupted"; continue' SIGINT

space() {
    	echo "Available disk space:"
    	df -h
}
memory() {
    	echo "Use of memory:"
    	free -h
}
services() {
    	echo "Services in progress:"
    	systemctl --type=service --state=running
}
cpu() {
    	echo "CPU usage:"
    	top -n 1 | grep "Cpu(s)"
}
find-file() {
    	echo "Enter the name of the file to search for:"
    	read archivo
    	find / -name "$archivo" 2>/dev/null
	if [ -z "$resultados" ]; then
        	echo "Error: File not found  '$archivo'."
    	else
        	echo "File(s) found:"
        	echo "$resultados"
    	fi
}
processes() {
    	echo "Running processes of the user $(whoami) with their PID:"
    	ps aux --sort=%mem | grep "$(whoami)" | awk '{print $1, $2, $11}'
}
order-66() {
    	pid=$1
    	if [ -z "$pid" ]; then
        	echo "Error: PID not provided."
        	return 1
    	fi
    	if sudo kill -0 $pid 2>/dev/null; then
        	sudo kill -9 $pid
        	echo "Process $pid eliminated."
    	else
        	echo "Error: The PID $pid does not exist."
    	fi
}
system-run() {
    	echo "The system has been in operation during:"
    	uptime -p
}
active-connections() {
    	echo "Active network connections:"
    	netstat -tuln
}
processes-memory() {
    	echo "Processes with higher memory usage::"
    	ps aux --sort=-%mem | head -n 10
}
processes-cpu() {
    	echo "Processes with higher CPU usage::"
    	ps aux --sort=-%cpu | head -n 10
}
help-sense() {
    	user=$(whoami)
        lynx "/home/$user/SENSE/index.html"
}
bye() {
	sudo shutdown -h now
}
miguel() {
	echo "                                                        "
	echo "███    ███  █████╗ ████████╗ █████╗ ███╗   ███╗███████╗ "
	echo "████  ████ ██╔══██╗╚══██╔══╝██╔══██╗████╗ ████║██╔════╝ "
	echo "██╔████╔██║███████║   ██║   ███████║██╔████╔██║█████╗   "
	echo "██║╚██╔╝██║██╔══██║   ██║   ██╔══██║██║╚██╔╝██║██╔══╝   "
	echo "██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║ ╚═╝ ██║███████╗ "
	echo "╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ "
	echo "════════════════════════════════════════════════════════"
	echo "    ██████╗ █████╗ ███╗   ███╗██╗ ██████╗ ███╗   ██╗   "
	echo "   ██╔════╝██╔══██╗████╗ ████║██║██╔═══██╗████╗  ██║   "
	echo "   ██║     ███████║██╔████╔██║██║██║   ██║██╔██╗ ██║   "
	echo "   ██║     ██╔══██║██║╚██╔╝██║██║██║   ██║██║╚██╗██║   "
	echo "   ╚██████╗██║  ██║██║ ╚═╝ ██║██║╚██████╔╝██║ ╚████║   "
	echo "    ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝   "
	echo "═══════════════════════════════════════════════════════"
}
example() {
    	USERNAME=$(whoami)
    	DIR="/home/$USERNAME/SENSE/example"

    	sudo mkdir -p "$DIR"

    	echo '#!/bin/bash' | sudo tee "$DIR/example.sh" > /dev/null
    	echo 'while true; do sleep 1; done' | sudo tee -a "$DIR/example.sh" > /dev/null

    	sudo chmod +x "$DIR/example.sh"
    	sudo "$DIR/example.sh" &

    	sleep 1
    	pid=$(pgrep -o -f "$DIR/example.sh")
    	echo "The PID of the process created by running example.sh file is: $pid"
}

no-example() {
    	USERNAME=$(whoami)
    	DIR="/home/$USERNAME/SENSE/example"

    	if [ -d "$DIR" ]; then
        	sudo rm -rf "$DIR"
    	else
        	echo "Error: example has not been created previously."
    	fi
}

while true; do
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
	"bye") bye;;
	"miguel") miguel ;;
	"example") example ;;
	"no-example") no-example ;;
        "exit") break ;;
        *)
            echo "$cmd" >> "$HISTFILE"
            history -s "$cmd"
            eval "$cmd"
            ;;
    esac
done

export PS1="\u@\h:\w$ "
