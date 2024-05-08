ARG ELK_TAG

# https://www.docker.elastic.co/
FROM docker.elastic.co/logstash/logstash:${ELK_TAG}

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
RUN logstash-plugin install --version 1.3.1 logstash-input-snmp
RUN logstash-plugin install logstash-filter-mutate
RUN logstash-plugin install logstash-filter-ruby
RUN logstash-plugin install logstash-filter-grok
RUN logstash-plugin install logstash-output-elasticsearch
RUN logstash-plugin install logstash-integration-rabbitmq
RUN logstash-plugin install logstash-output-influxdb