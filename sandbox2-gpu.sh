#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v docker compose)" ]; then
  echo 'Error: docker compose is not installed.' >&2
  exit 1
fi

sandbox () {
  source .env

  up () {
    case $2 in
      influxdb)
        echo "Up the influxdb container..."
        docker compose -f docker-compose-gpu.yml up -d --build influxdb
        ;;
      kapacitor)
        echo "Up the kapacitor container..."
        docker compose -f docker-compose-gpu.yml up -d --build kapacitor
        ;;
      logstash)
        echo "Up the logstash container..."
        docker compose -f docker-compose-gpu.yml up -d --build logstash
        ;;
      etcd)
        echo "Up the etcd container..."
        docker compose -f docker-compose-gpu.yml up -d --build etcd
        ;;
      *)
        echo "Up all containers..."
        docker compose -f docker-compose-gpu.yml up -d --build
        ;;
    esac
  }

  down () {
    case $2 in
      influxdb)
        echo "Down the influxdb container..."
        docker compose -f docker-compose-gpu.yml down influxdb
        ;;
      kapacitor)
        echo "Down the kapacitor container..."
        docker compose -f docker-compose-gpu.yml down kapacitor
        ;;
      logstash)
        echo "Down the logstash container..."
        docker compose -f docker-compose-gpu.yml down logstash
        ;;
      etcd)
        echo "Down the etcd container..."
        docker compose -f docker-compose-gpu.yml down etcd
        ;;
      *)
        echo "Down all containers..."
        docker compose -f docker-compose-gpu.yml down
        ;;
    esac
  }

  # Enter attaches users to a shell in the desired container
  enter () {
    case $2 in
      influxdb)
        echo "Entering /bin/bash session in the influxdb container..."
        docker compose -f docker-compose-gpu.yml exec influxdb /bin/bash
        ;;
      kapacitor)
        echo "Entering /bin/bash session in the kapacitor container..."
        docker compose -f docker-compose-gpu.yml exec kapacitor /bin/bash
        ;;
      logstash)
        echo "Entering /bin/sh session in the logstash container..."
        docker compose -f docker-compose-gpu.yml exec logstash /bin/bash
        ;;
      etcd)
        echo "Entering /bin/sh session in the etcd container..."
        docker compose -f docker-compose-gpu.yml exec etcd /bin/sh
        ;;
      *)
        echo "sandbox enter (influxdb||kapacitor||logstash||etcd)"
        ;;
    esac
  }

  # Logs streams the logs from the container to the shell
  logs () {
    case $2 in
      influxdb)
        echo "Following the logs from the influxdb container..."
        docker compose -f docker-compose-gpu.yml logs -f --tail $3 influxdb
        ;;
      kapacitor)
        echo "Following the logs from the kapacitor container..."
        docker compose -f docker-compose-gpu.yml logs -f --tail $3 kapacitor
        ;;
      logstash)
        echo "Following the logs from the logstash container..."
        docker compose -f docker-compose-gpu.yml logs -f --tail $3 logstash
        ;;
      etcd)
        echo "Following the logs from the etcd container..."
        docker compose -f docker-compose-gpu.yml logs -f --tail $3 etcd
        ;;
      all)
        docker compose -f docker-compose-gpu.yml logs -f --tail $3
        ;;
      *)
        echo "sandbox2.sh logs (influxdb||kapacitor||logstash||etcd||all) [preview counts]"
        ;;
    esac
  }


  # Install creates and enables a service file
  install () {
    if [ -z "$2" ]; then
      echo "Error: No working directory specified." >&2
      exit 1
    fi

    local servicePath="/etc/systemd/system/snet-sandbox.service"
    echo "Creating service file at $servicePath..."

    cat << EOF > "$servicePath"
[Unit]
Description=Snet Sandbox Service
After=network-online.target

[Service]
User=root
Group=root
WorkingDirectory=$2
ExecStart=/usr/local/bin/docker compose -f docker-compose-gpu.yml up -d

KillMode=control-group
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable snet-sandbox
    systemctl start snet-sandbox
    echo "Snet Sandbox Service has been enabled and started."
  }

  case $1 in
    up)
      up $@
      ;;
    down)
      down $@
      ;;
    restart)
      docker compose -f docker-compose-gpu.yml restart $2
      ;;
    delete-data)
      echo "deleting all influxdb, kapacitor, etcd data..."
      rm -rf kapacitor/data influxdb/data etcd/data
      ;;
    docker-clean)
      echo "Stopping and removing running sandbox containers..."
      docker compose -f docker-compose-gpu.yml down
      echo "Removing influxdb and kapacitor images..."
      docker rmi ch/influxdb:$INFLUXDB_TAG ch/kapacitor:$KAPACITOR_TAG ch/logstash:$ELK_TAG quay.io/coreos/etcd:$ETCD_TAG > /dev/null 2>&1
      docker rmi $(docker images -f "dangling=true" -q)
      docker images
      ;;
    influxdb)
      echo "Entering the influx cli..."
      docker compose -f docker-compose-gpu.yml exec influxdb /usr/bin/influx
      ;;
    flux)
      echo "Entering the flux repl..."
      docker compose -f docker-compose-gpu.yml exec influxdb /usr/bin/influx -type flux
      ;;
    enter)
      enter $@
      ;;
    logs)
      logs $@
      ;;
    install)
      install "$@"
      ;;
    *)
      cat <<-EOF
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
EOF
      ;;
  esac
}

pushd `dirname $0` > /dev/null
    sandbox $@
popd > /dev/null
