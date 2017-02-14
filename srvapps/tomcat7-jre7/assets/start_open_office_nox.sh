#!/bin/bash
export DISPLAY=:0.0
Xvfb :0.0 2>/dev/null &
xhost + 2>/dev/null &
nohup soffice --headless --nologo --nodefault --norestore --nocrashreport --nolockcheck --nofirststartwizard --accept="socket,host=localhost,port=8100;urp;StarOffice.ServiceManager" & 

