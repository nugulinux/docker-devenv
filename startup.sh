#!/bin/zsh

if [ "$#" -eq 1 ] && [ "$1" = "/bin/zsh" ]; then
	BANNER=$(cat << "EOF"

\e[1;30m -------------------------------------------------- \e[0m
\e[1;36m   _   _ _    _  _____ _    _  _____ _____  _  __   \e[0m
\e[1;36m  | \ | | |  | |/ ____| |  | |/ ____|  __ \| |/ /   \e[0m
\e[1;36m  |  \| | |  | | |  __| |  | | (___ | |  | | ' /    \e[0m
\e[1;36m  | . ` | |  | | | |_ | |  | |\___ \| |  | |  <     \e[0m
\e[1;36m  | |\  | |__| | |__| | |__| |____) | |__| | . \    \e[0m
\e[1;36m  |_| \_|\____/ \_____|\____/|_____/|_____/|_|\_\   \e[0m
\e[1;36m               __            _    _                 \e[0m
\e[1;36m              / _|___ _ _   | |  (_)_ _ _  ___ __   \e[0m
\e[1;36m             |  _/ _ \ '_|  | |__| | ' \ || \ \ /   \e[0m
\e[1;36m             |_| \___/_|    |____|_|_||_\_,_/_\_\   \e[0m
\e[0;37m                                                    \e[0m
\e[0;37m     NUGU SDK for Linux development environment     \e[0m
\e[0;37m                                                    \e[0m
\e[1;30m -------------------------------------------------- \e[0m

Available docker options
 - Share current directory
   \e[1m-v $PWD:$PWD -w $PWD\e[0m

 - Audio in docker (PulseAudio)
   \e[1m-v ~/.config/pulse:/root/.config/pulse \\ \e[0m
   \e[1m-e PULSE_SERVER={your-ip-address}\e[0m

 - NUGU OAuth2 Configurations(http://lvh.me:8080)
   \e[1m-v ~/nugu:/var/lib/nugu -p 8080:8080\e[0m

 - NUGU environment variables
   \e[1m-e NUGU_OAUTH2_URL=https://api.sktnugu.com/ \\ \e[0m
   \e[1m-e NUGU_SERVER_TYPE=PRD\e[0m

EOF
)

	echo "$BANNER"
	echo
fi

mkdir -p /var/run/dbus
rm -f /var/run/dbus/pid
dbus-daemon --system

exec "$@"
