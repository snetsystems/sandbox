# Snetsystems Sandbox

This repo is a quick way to get the InfluxDB and Kapacitor Stack spun up and working together with CloudHub.

### Running

To run the `sandbox`, simply use the convenient cli:

```bash
$ ./sandbox
sandbox commands:
  up       -> spin up the sandbox environment
  down     -> tear down the sandbox environment
  restart  -> restart the sandbox
  influxdb -> attach to the influx cli
  flux     -> attach to the flux REPL

  enter (influxdb||kapacitor) -> enter the specified container
  logs  (influxdb||kapacitor) -> stream logs for the specified container

  delete-data  -> delete all data created by the influxdb and kapacitor
  docker-clean -> stop and remove all running docker containers and images
```
