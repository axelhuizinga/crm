@echo off

cp -ur bin/* H:\httpdocs

IF  "update"  == "%1" cp -ur lib src H:\src

echo "Done :)"