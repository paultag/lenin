# Base image
#
# VERSION   0.1
FROM        paultag/acid:latest
MAINTAINER  Paul R. Tagliamonte <paultag@debian.org>

RUN mkdir -p /opt/hylang/

RUN cd /opt/hylang/; git clone git://github.com/paultag/aiodocker.git
RUN cd /opt/hylang/aiodocker; python3.4 /usr/bin/pip3 install -r requirements.txt
RUN cd /opt/hylang/aiodocker; python3.4 /usr/bin/pip3 install -e .

RUN cd /opt/hylang/; git clone git://github.com/paultag/marx.git
RUN cd /opt/hylang/marx; python3.4 /usr/bin/pip3 install -e .

RUN cd /opt/hylang/; git clone git://github.com/paultag/lenin.git
RUN cd /opt/hylang/lenin; python3.4 /usr/bin/pip3 install -e .

CMD ["hy"]
