FROM tomcat:9-jre8-alpine

MAINTAINER Wu Tao "https://github.com/mimousewu"

ENV MYSQL_JDBC_PACKAGE mysql-connector-java-5.1.36
ENV POSTGRESQL_JDBC_PACKAGE postgresql-9.4-1201.jdbc41


# Install Apache Tomcat 8 and openjdk-8-jdk
RUN apk add --no-cache --virtual  \
	curl && \
	rm -rf /var/cache/apk/* && rm -rf /tmp/*

# Configure Apache Tomcat environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp

# Make sure that the temporary directory exists
RUN mkdir -p $CATALINA_TMPDIR              

# Remove all webapps from the default Tomcat installation
RUN rm -rf $CATALINA_BASE/webapps/*

# Copy tomcat configuration files from the project to the container
#COPY tomcat/setenv.sh  $CATALINA_BASE/bin/setenv.sh    

# Install JDBC drivers
RUN mkdir $CATALINA_HOME/lib/jdbc && \
    wget -nv http://jdbc.postgresql.org/download/$POSTGRESQL_JDBC_PACKAGE.jar -O $CATALINA_HOME/lib/$POSTGRESQL_JDBC_PACKAGE.jar && \
    wget -nv -O - http://dev.mysql.com/get/Downloads/Connector-J/$MYSQL_JDBC_PACKAGE.tar.gz  | tar -C /tmp -xvzf - $MYSQL_JDBC_PACKAGE/$MYSQL_JDBC_PACKAGE-bin.jar && \
    mv /tmp/$MYSQL_JDBC_PACKAGE/$MYSQL_JDBC_PACKAGE-bin.jar $CATALINA_HOME/lib
RUN wget -nv https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases//info/magnolia/bundle/magnolia-community-demo-webapp/5.7/magnolia-community-demo-webapp-5.7.war -O $CATALINA_BASE/webapps/ROOT.war

# Start the tomcat instance
ENTRYPOINT ["/usr/local/tomcat/bin/catalina.sh", "run"]
CMD [""]

# Expose the ports
EXPOSE 8080
