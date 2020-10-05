FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get install -y curl
RUN apt-get install -y jq
WORKDIR /app
COPY client-x.sh /app
RUN chmod 755 /app/client-x.sh
CMD /app/client-x.sh
