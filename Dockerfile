FROM google/cloud-sdk:alpine

MAINTAINER Travis Shen "travishen.tw@gmail.com"

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1

# This variable is required for local cbt tool
ENV BIGTABLE_EMULATOR_HOST 0.0.0.0:8086

ENV BIGTABLE_PROJECT dev

ENV BIGTABLE_INSTANCE dev

RUN gcloud components update -q beta && \
    gcloud components install -q bigtable beta cbt

ADD start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
