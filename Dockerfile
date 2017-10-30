FROM registry.opensource.zalan.do/stups/python:3.5.2-38

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY  . /data

WORKDIR /data
CMD /data/remote.sh
