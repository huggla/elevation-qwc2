ARG TAG="20181204"
ARG CONTENTIMAGE1="huggla/pyinstaller-alpine:$TAG"
ARG CONTENTDESTINATION1="/"
ARG RUNDEPS="py2-future"
ARG BUILDDEPS="dash"
ARG BUILDCMDS=\
"   head -188 /buildfs/src/elevation.py.org > /src/elevation.py "\
"&& tail -26 /buildfs/src/elevation.py.add >> /src/elevation.py "\
"&& sed -i 's/# Copyright 2018, Sourcepole AG/# Copyright 2018, Sourcepole AG, Henrik Uggla/' /src/elevation.py "\
"&& cp /buildfs/src/requirements.txt /src/ "\
"&& cp -a /usr/bin/dash /usr/local/bin/ "\
"&& sed -i 's|shell=True,|shell=True, executable=\"/usr/local/bin/dash\",|g' /usr/local/lib/python2.7/ctypes/util.py "\
"&& cd /src "\
"&& /pyinstaller/pyinstaller.sh --onefile --noconfirm --clean --exclude-module Werkzeug --distpath /imagefs/usr/local/bin elevation.py"
ARG EXECUTABLES="/usr/local/bin/elevation"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_LINUX_USER="elevation" \
    VAR_GUNICORN_PARAMS="bind=0.0.0.0:5002" \
    VAR_FINAL_COMMAND="elevation \$VAR_GUNICORN_PARAMS"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
