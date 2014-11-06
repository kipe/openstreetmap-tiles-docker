## -*- docker-image-name: "homme/openstreetmap-tiles:latest" -*-

##
# The OpenStreetMap Tile Server
#

FROM phusion/baseimage:0.9.15
MAINTAINER Avin Grape <carcinogen75@gmail.com>

# Set the locale. This affects the encoding of the Postgresql template
# databases.
ENV LANG C.UTF-8
RUN update-locale LANG=C.UTF-8

# Ensure `add-apt-repository` is present
RUN apt-get update -y
RUN apt-get install -y software-properties-common python-software-properties

# Add the repository containing the packages
RUN add-apt-repository ppa:kakrueger/openstreetmap

# Update the local package list to pick up the new repository
RUN apt-get update -y

# Install the package libapache2-mod-tile and its dependencies
RUN apt-get install -y libapache2-mod-tile

# Ensure the webserver user can connect to the gis database
RUN sed -i.bak -e 's/local   all             all                                     peer/local gis www-data peer/' /etc/postgresql/9.3/main/pg_hba.conf

# Tune postgresql
ADD postgresql.conf.sed /tmp/
RUN sed --file /tmp/postgresql.conf.sed --in-place /etc/postgresql/9.3/main/postgresql.conf

# Define the application logging logic
ADD syslog-ng.conf /etc/syslog-ng/conf.d/local.conf
RUN rm -rf /var/log/postgresql

# Create the files required for the renderd system to run
RUN mkdir /var/run/renderd && chown www-data: /var/run/renderd

# Increase ModTileMissingRequestTimeout (prevent red-squares on map on long render)
RUN sed -i.bak 's/ModTileMissingRequestTimeout 10/ModTileMissingRequestTimeout 1800/'  /etc/apache2/sites-available/tileserver_site.conf

# Use custom html-map-page
RUN rm /var/www/osm/slippymap.html
ADD www/slippymap.html /var/www/osm/

# Create a `postgresql` `runit` service
ADD postgresql /etc/sv/postgresql
RUN update-service --add /etc/sv/postgresql

# Create an `apache2` `runit` service
ADD apache2 /etc/sv/apache2
RUN update-service --add /etc/sv/apache2

# Create a `renderd` `runit` service
ADD renderd /etc/sv/renderd
RUN update-service --add /etc/sv/renderd

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the webserver and database ports
EXPOSE 80 5432

# We need the volume for importing data from
VOLUME ["/data"]

# Set the osm2pgsql import cache size in MB. Used in `run import`.
ENV OSM_IMPORT_CACHE 1000

# Add the README
ADD README.md /usr/local/share/doc/

# Add the help file
RUN mkdir -p /usr/local/share/doc/run
ADD help.txt /usr/local/share/doc/run/help.txt

# Add the entrypoint
ADD run.sh /usr/local/sbin/run
ENTRYPOINT ["/sbin/my_init", "--", "/usr/local/sbin/run"]
#ENTRYPOINT ["/bin/bash", "-c"]

# Default to showing the usage text
CMD ["help"]
