# Snetsystems Sandbox

This repo is a quick way to get the InfluxDB and Kapacitor Stack spun up and working together with CloudHub.

## Docker Compose Profiles (Recommended)

The `docker-compose.profiles.yml` file integrates both CPU and GPU versions using Docker Compose profiles. This is the recommended way to run the sandbox.

### Usage

**Start services with CPU profile:**

```bash
docker compose -f docker-compose.profiles.yml --profile cpu up -d
```

**Start services with GPU profile:**

```bash
docker compose -f docker-compose.profiles.yml --profile gpu up -d
```

**Stop services:**

```bash
docker compose -f docker-compose.profiles.yml down
```

**Stop services with specific profile:**

```bash
docker compose -f docker-compose.profiles.yml --profile cpu down
docker compose -f docker-compose.profiles.yml --profile gpu down
```

### Systemd Service Installation

To install the sandbox as a systemd service that automatically starts on boot:

**Install with CPU profile (default):**

```bash
sudo ./install-service.sh /path/to/sandbox
# or explicitly
sudo ./install-service.sh /path/to/sandbox cpu
```

**Install with GPU profile:**

```bash
sudo ./install-service.sh /path/to/sandbox gpu
```

**Service management:**

```bash
# Start service
sudo systemctl start snet-sandbox

# Stop service
sudo systemctl stop snet-sandbox

# Check status
sudo systemctl status snet-sandbox

# View logs
sudo journalctl -u snet-sandbox -f

# Disable service (remove from auto-start)
sudo systemctl disable snet-sandbox
```

### Deprecated Files

The following files are deprecated and will be removed in a future version:

- `docker-compose.yml` - Use `docker-compose.profiles.yml --profile cpu` instead
- `docker-compose-gpu.yml` - Use `docker-compose.profiles.yml --profile gpu` instead

### Legacy CLI (Deprecated)

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
