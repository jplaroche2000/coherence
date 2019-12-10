# Copyright (c) 2019 TELUS Communicaiton inc. All rights reserved.
#

FROM oracle/coherence:12.2.1-3-2

MAINTAINER Jean-Philippe Laroche <jean-philippe.laroche@telus.com>

USER root

# Tools - iconfig required to grep bridge subnet provisionned IP
RUN set -eux; \
	yum install -y \
		net-tools \
		iputils \
	; \
	rm -rf /var/cache/yum

# Users and groups
RUN groupadd -g 500 ec2-user && groupadd -g 497 docker && useradd -M -g 500 -G 497 -u 500 -s /bin/bash ec2-user && usermod -a -G docker oracle

# Cluster domain
RUN mkdir -p /u01/oracle/domain

# Copy local files required to build this image
COPY start-coherence.sh /u01/oracle/domain/start-coherence.sh
COPY bin /u01/oracle/domain/bin
COPY config /u01/oracle/domain/config
COPY libCache /u01/oracle/domain/libCache
COPY lib /u01/oracle/domain/lib
COPY log /u01/oracle/domain/log
COPY reports /u01/oracle/domain/reports
COPY test /u01/oracle/domain/test

RUN  chown -R oracle:oracle /u01/oracle/domain && chmod a+rx /u01/oracle/domain/start-coherence.sh && chmod a+rx /u01/oracle/domain/bin/*.sh

USER oracle

WORKDIR /u01/oracle/domain

ENV COHERENCE_DOMAIN=/u01/oracle/domain

ENTRYPOINT ["./start-coherence.sh"]
