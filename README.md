# OpenStreetMap Tile Server Container

This repository contains instructions for building a
[Docker](https://www.docker.io/) image containing the OpenStreetMap tile
serving software stack.  It is based on the
[Switch2OSM instructions](http://switch2osm.org/serving-tiles/building-a-tile-server-from-packages/).
Based on another docker-container [homme/openstreetmap-tiles](https://registry.hub.docker.com/u/homme/openstreetmap-tiles/)

As well as providing an easy way to set up and run the tile serving software it
also provides instructions for managing the back end database, allowing you to:

* Create the database
* Import OSM data into the database
* Drop the database

Run `docker run homme/openstreetmap-tiles` for usage instructions.

## About

The container runs Ubuntu 14.04 (Trusty) and is based on the
[phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).  It
includes:

* Postgresql 9.3
* Apache 2.2
* The latest [Osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql) code (at
  the time of image creation)
* The latest [Mapnik](http://mapnik.org/) code (at the time of image creation)
* The latest [Mod_Tile](http://wiki.openstreetmap.org/wiki/Mod_tile) code (at
  the time of image creation)

## Usage

Read [help file](help.txt)
