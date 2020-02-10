FROM quay.io/vektorcloud/oracle-jre:latest

ENV SPARK_HOME="/opt/spark"
ENV SPARK_VERSION="2.4.5"
ENV HADOOP_VERSION="2.7"
ENV PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"

WORKDIR "${SPARK_HOME}"

EXPOSE 18080 8080 8081 7077 6066 4040 10000

RUN curl -Ls "https://www-us.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | tar -zxvf - -C "${SPARK_HOME}" --strip=1 && \
    apk add --no-cache python3 && \
    curl "https://bootstrap.pypa.io/get-pip.py" | python3 && \
    ln -sv /usr/bin/python3 /usr/bin/python && \
    apk add --no-cache supervisor

COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]