# FitHiChIP with every runtime dependency from conda-forge / Bioconda, for Nextflow pipelines
# (Docker, Singularity/Apptainer, Podman). HiC-Pro is not included: give FitHiChIP the bins and
# matrix (Interval= / Matrix=), a .cool/.mcool (COOL=), a .hic (HIC=) or a BED interaction file.
FROM mambaorg/micromamba:2.0.5

ARG FITHICHIP_VERSION=11.0

LABEL org.opencontainers.image.source="https://github.com/birkiy/fithichip-container"
LABEL org.opencontainers.image.description="FitHiChIP ${FITHICHIP_VERSION} (ay-lab) with its dependencies from conda-forge and Bioconda"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${FITHICHIP_VERSION}"

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates procps \
    && rm -rf /var/lib/apt/lists/*

COPY environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml \
    && micromamba clean -afy \
    && micromamba env export -n base > /opt/environment.lock.yml

# FitHiChIP itself, at the release tag; test data and git history left out
RUN git clone --depth 1 --branch "${FITHICHIP_VERSION}" https://github.com/ay-lab/FitHiChIP.git /opt/FitHiChIP \
    && rm -rf /opt/FitHiChIP/.git /opt/FitHiChIP/TestData \
    && chmod -R a+rwX /opt/FitHiChIP

ENV MAMBA_ROOT_PREFIX=/opt/conda \
    PATH=/opt/conda/bin:/opt/FitHiChIP:$PATH \
    FITHICHIP_HOME=/opt/FitHiChIP \
    FITHICHIP_VERSION=${FITHICHIP_VERSION} \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR /data
CMD ["/bin/bash"]
