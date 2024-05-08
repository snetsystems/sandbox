# Snetsystems Sandbox

This repo is a quick way to get the InfluxDB and Kapacitor Stack spun up and working together with CloudHub.

### Running

To run the `sandbox`, simply use the convenient cli:

```bash
$ ./sandbox1 # if docker-compose <= version1
$ ./sandbox2 # if docker-compose-v2 <= version2
sandbox commands:
  up       -> spin up the sandbox environment
  down     -> tear down the sandbox environment
  restart  -> restart the sandbox
  influxdb -> attach to the influx cli
  flux     -> attach to the flux REPL

  enter (influxdb||kapacitor||logstash||etcd) -> enter the specified container
  logs  (influxdb||kapacitor||logstash||etcd) -> stream logs for the specified container or all
  install <Directory path where docker-compose.yml is located> -> create and enable a system service for the sandbox environment. 
  
  delete-data  -> delete all data created by the influxdb and kapacitor and etcd
  docker-clean -> stop and remove all running docker containers and images
```
