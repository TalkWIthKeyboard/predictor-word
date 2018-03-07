FROM docker.elastic.co/elasticsearch/elasticsearch:5.1.1
MAINTAINER TalkWithKeyboard
USER root
# Unzip ik and pinyin plugins.
RUN apk update && apk add zip
RUN mkdir -p /usr/share/elasticsearch/plugins/ik
RUN mkdir -p /usr/share/elasticsearch/plugins/pinyin
ADD elasticsearch-analysis-ik-5.1.1.zip /usr/share/elasticsearch/plugins/ik
RUN cd /usr/share/elasticsearch/plugins/ik && unzip elasticsearch-analysis-ik-5.1.1.zip
ADD elasticsearch-analysis-pinyin-5.1.1.zip /usr/share/elasticsearch/plugins/pinyin
RUN cd /usr/share/elasticsearch/plugins/pinyin && unzip elasticsearch-analysis-pinyin-5.1.1.zip
# change the authority of user "elasticsearch"
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk --no-cache add shadow && \
usermod -u 555 -p elasticsearch elasticsearch && \
 groupmod -g 555 elasticsearch && \
	find . -user  1000 -exec chown -h 555 {} \; && \
	find . -group 1000 -exec chgrp -h 555 {} \; && \
	usermod -g 555 elasticsearch
# Switch back 
USER elasticsearch 
