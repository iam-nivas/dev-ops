FROM openjdk:8-jre

RUN cp /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

ENV JBOSS_ARCHIVE_NAME=wildfly

ENV JBOSS_HOME /opt/jboss/wildfly/

# ENV JAVA_HOME /usr/local/openjdk-8

RUN mkdir -p $JBOSS_HOME

RUN groupadd -r saiuser && useradd -r -s /bin/false -g saiuser saiuser

COPY $JBOSS_ARCHIVE_NAME $JBOSS_HOME

RUN chmod +x $JBOSS_HOME/bin/add-user.sh

RUN $JBOSS_HOME/bin/add-user.sh admin admin@401 --silent

EXPOSE  8635 10861

COPY lendperfect.war  $JBOSS_HOME/standalone/deployments

RUN chown -R saiuser:saiuser $JBOSS_HOME

USER root

RUN chmod +x /opt/jboss/wildfly/bin/standalone.sh

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

