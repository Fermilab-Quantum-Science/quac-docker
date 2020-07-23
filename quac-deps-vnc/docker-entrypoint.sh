#!/bin/bash

mkdir -p /root/.vnc
cat << EOF > /root/.vnc/xstartup
export XKL_XMODMAP_DISABLE=1
exec /usr/bin/startlxde
EOF
chmod a+x /root/.vnc/xstartup

touch /root/.vnc/passwd
/bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > /root/.vnc/passwd
chmod 400 /root/.vnc/passwd
chmod go-rwx /root/.vnc

touch /root/.Xauthority

echo "Starting VNC server..."
export USER=root
vncserver :1 -geometry "${GEOM}"  -depth 24
echo "Running until killed"
exec tail -f /dev/null
