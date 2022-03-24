# Simulating a legacy application

These scripts are meant to be run on separate VMs to simulate a typical legacy 3 tier application and send traffic between its tiers.

To get started, on each VM:
* place all files in a directory of their own
* edit the `boxes` file to point to all 3 VM's IP or FQDN
* run the server component
```
./serve.sh <web|app|db>
```
* run the traffic generator component
```
./connect.sh <[c]web|[c]app|db>
```
* to stop the simulation
```
./connect.sh kill && ./serve.sh kill
```

## serve.sh

This script simulates a typical legacy 3-tier application consisting of:
* web - frontend of the application, running on port 8080
* app - middleware / business logic, running on port 2000
* db - database, running on port 3306

## connect.sh

This script simulates traffic between the tiers of the legacy application. There are two different modes of operation:
* every tier talks to the other two tiers (implicit trust)
* strict: web -> app -> db (the `[c]` option)