#!/bin/bash


pytest


zip -r demoapp.zip demoapp

scp -i /home/petrch/id_rsa demoapp.zip petrch2@localhost:
