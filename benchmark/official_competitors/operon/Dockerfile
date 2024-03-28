FROM docker.flatironinstitute.org/mcranmer/srbench-core:latest
# Install operon
COPY . /tmp/operon
WORKDIR /tmp/operon
RUN --mount=type=cache,target=/opt/conda/pkgs mamba env create -n method -f environment.yml
RUN mamba run -n method /bin/bash install.sh

