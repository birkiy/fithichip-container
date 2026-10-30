# FitHiChIP container

A container image of [FitHiChIP](https://github.com/ay-lab/FitHiChIP) (Bhattacharyya et al., Nat Commun 2019) with every
runtime dependency installed from conda-forge and Bioconda, built for use in Nextflow pipelines such as
[nf-core/hic](https://github.com/nf-core/hic) (`--loops_caller fithichip`). It is published on the GitHub container registry:

```
ghcr.io/birkiy/fithichip:11.0
```

Pin it by digest in a pipeline; the digest of every build is printed in the Actions run summary.

## What is inside

- FitHiChIP at the `11.0` release tag, in `/opt/FitHiChIP` (`FITHICHIP_HOME`), test data and git history removed, on `PATH`.
- Python 3 with numpy, networkx, hic-straw and cooler.
- R with optparse, ggplot2, data.table, fdrtool, plyr, dplyr, RColorBrewer, GenomicRanges and edgeR.
- bedtools, samtools, htslib (bgzip, tabix), UCSC bedToBigBed, MACS2, bc, gawk, gzip.
- `/opt/environment.lock.yml`: the exact conda packages of the build (also attached to every Actions run).

HiC-Pro is **not** included. FitHiChIP needs it only to build the contact matrix from a HiC-Pro validPairs file; give it
the bins and matrix instead (`Interval=` and `Matrix=`, e.g. from `cooler dump`), a `.cool`/`.mcool` (`COOL=`), a `.hic`
(`HIC=`) or a BED interaction file (`Bed=`).

## Running

```bash
docker run --rm -v "$PWD":/data ghcr.io/birkiy/fithichip:11.0 bash /opt/FitHiChIP/FitHiChIP_HiCPro.sh -C /data/config.txt
singularity exec docker://ghcr.io/birkiy/fithichip:11.0 bash /opt/FitHiChIP/FitHiChIP_HiCPro.sh -C config.txt
```

FitHiChIP changes into its own code directory while it runs and R writes `Rplots.pdf` there. In a read-only container
(Singularity/Apptainer) copy `/opt/FitHiChIP` to a writable place first and run that copy; the nf-core/hic module does so.

## Building

GitHub Actions builds the image on every push to `main` (see `.github/workflows/build.yml`): build, smoke test of every tool
and library, push with the tags `11.0`, `11.0-<commit>` and `latest`. To build locally:

```bash
docker build -t fithichip:11.0 .
```

## Licence

FitHiChIP is MIT licensed (copyright ay-lab); this Dockerfile and workflow are MIT licensed as well.
