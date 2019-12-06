#!/bin/zsh

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

  NUGU SDK environment variables
   - \e[1mNUGU_OAUTH2_URL\e[0m=https://api.sktnugu.com/
   - \e[1mNUGU_REGISTRY_SERVER\e[0m=https://reg-http.sktnugu.com
   - \e[1mNUGU_LOG\e[0m=stderr (stderr, syslog, none)
   - \e[1mNUGU_LOG_MODULE\e[0m=all (default, network, network_trace, audio)

EOF
)

echo "$BANNER"
echo

mkdir -p /var/run/dbus
rm -f /var/run/dbus/pid
dbus-daemon --system

exec "$@"
