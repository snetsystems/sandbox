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

  enter (influxdb||kapacitor||etcd) -> enter the specified container
  logs  (influxdb||kapacitor||etcd) -> stream logs for the specified container
  install <Directory path where docker-compose.yml is located> -> create and enable a system service for the sandbox environment. 
  
  delete-data  -> delete all data created by the influxdb and kapacitor and etcd
  docker-clean -> stop and remove all running docker containers and images
```
