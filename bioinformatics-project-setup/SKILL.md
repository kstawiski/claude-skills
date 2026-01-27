---
name: bioinformatics-project-setup
description: Set up standardized bioinformatics project directory structure with separated data, code, results, and analysis spaces. Enforces reproducible organization for NGS/genomics/imaging pipelines with cloud storage mounting, reference genome management, and collaboration-ready output directories.
routing_description: Use this skill when setting up a new bioinformatics, genomics, NGS, or computational biology project. Handles directory scaffolding, CLAUDE.md/AGENTS.md creation, git initialization for code tracking, and reference genome discovery.
routing_keywords:
  - bioinformatics
  - project setup
  - new project
  - genomics
  - NGS
  - pipeline
  - nextflow
  - fastq
  - bam
  - DICOM
  - project structure
  - analysis setup
  - bioinformatics project
  - sequencing
  - WGS
  - WES
  - RNA-seq
  - GRCh38
  - hg38
  - reference genome
---

# Bioinformatics Project Setup

## Purpose

Scaffold a standardized bioinformatics project with clear separation between:
- **Raw data** (mounted cloud storage — read-only)
- **Metadata** (study metadata, technical reports, methodology docs)
- **Planning** (analysis plans, reviewed via consensus workflow)
- **Analysis** (working analysis space)
- **Results** (shareable outputs: tables, figures, reports — no code or technical files)
- **Code** (git-tracked: scripts, pipelines, configs — everything needed to reproduce)
- **Temporary** (nextflow work dirs, intermediate files — disposable)

## Directory Structure

```
project_root/
├── CLAUDE.md                  # Agent instructions (enforces structure)
├── AGENTS.md -> CLAUDE.md     # Symlink for multi-agent compatibility
│
├── data_bucket/               # Mount point for cloud storage (READ-ONLY)
│                              # Contents come from mounted bucket (bam/, fastq/, etc.)
│                              # Must be empty before mounting
│
├── metadata/                  # Study metadata and documentation
│   ├── sample_sheet.csv       # Sample manifest
│   ├── clinical_data/         # Clinical/phenotype data
│   ├── technical_reports/     # Sequencing QC, lab reports
│   └── methodology/           # Protocol documents, SOPs
│
├── plan/                      # Analysis planning (consensus-reviewed)
│   └── plan.md                # Master analysis plan
│
├── analysis/                  # Active analysis workspace
│   ├── plan.md                # Detailed execution plan (from consensus skill)
│   ├── qc/                    # Quality control outputs
│   ├── alignment/             # Alignment results
│   ├── variant_calling/       # Variant calling outputs
│   ├── expression/            # Expression quantification (RNA-seq)
│   ├── differential/          # Differential analysis
│   └── integration/           # Multi-omic integration
│
├── results/                   # SHAREABLE outputs (collaborator-facing)
│   ├── tables/                # Final tables (CSV, TSV, Excel)
│   ├── figures/               # Publication-ready figures
│   ├── reports/               # Analysis reports (HTML, PDF)
│   └── supplementary/         # Supplementary materials
│
├── code/                      # ALL code lives here (git-tracked)
│   ├── pipelines/             # Nextflow/Snakemake/WDL pipelines
│   ├── scripts/               # Analysis scripts (R, Python, bash)
│   ├── configs/               # Pipeline configs, parameter files
│   ├── envs/                  # Conda/container definitions
│   └── notebooks/             # Jupyter/R notebooks
│
├── work/                      # Nextflow work directory (disposable)
├── temp/                      # Other temporary files (disposable)
│
└── .gitignore                 # Root gitignore (excludes data, work, temp)
```

## Reference Files

Reference genomes and annotation files are managed centrally to avoid duplication across projects.

**Default reference directory:** `/home/kgs24/ref`

Expected reference structure:
```
/home/kgs24/ref/
├── genomes/
│   ├── GRCh38/               # Human genome build 38
│   │   ├── genome.fa
│   │   ├── genome.fa.fai
│   │   ├── genome.dict
│   │   └── bwa_index/
│   ├── GRCh37/               # Human genome build 37 (hg19)
│   ├── mm10/                  # Mouse
│   └── ...
├── annotations/
│   ├── gtf/                   # Gene annotations
│   ├── bed/                   # Target/capture regions
│   └── dbsnp/                 # Known variants
├── iGenomes/                  # Illumina iGenomes (if downloaded)
└── indices/                   # Pre-built aligner indices
    ├── bwa/
    ├── star/
    ├── hisat2/
    └── bowtie2/
```

### Reference Lookup Protocol

When a pipeline or analysis needs reference files:

1. **Check** if the file exists in the reference directory first
2. **Reuse** existing files — never re-download what already exists
3. **Download** missing files to the reference directory (not the project)
4. **Symlink** from the project if a local reference is needed for pipeline compatibility
5. **Document** any new downloads in the reference directory's README

## Cloud Storage Mounting

The `data_bucket/` directory is typically a mount point for cloud object storage:

| Provider | Tool | Example Mount Command |
|----------|------|----------------------|
| GCS | gcsfuse | `gcsfuse bucket-name data_bucket/` |
| AWS S3 | s3fs / goofys | `s3fs bucket-name data_bucket/ -o url=https://s3.amazonaws.com` |
| Wasabi | s3fs | `s3fs bucket-name data_bucket/ -o url=https://s3.wasabisys.com` |
| Hyperstack | s3fs | `s3fs bucket-name data_bucket/ -o url=https://s3.hyperstack.cloud` |

**Important:** `data_bucket/` should be treated as READ-ONLY. Never write pipeline outputs to the data bucket.

## Usage

### Quick Setup (Interactive)

```bash
# From the skill scripts directory:
bash setup.sh /path/to/new/project "My Study Title"

# With custom reference directory:
REF_DIR=/data/references bash setup.sh /path/to/new/project "My Study Title"
```

### Manual Setup

1. Create project root and run setup script
2. Mount data bucket to `data_bucket/`
3. Add sample metadata to `metadata/`
4. Create analysis plan in `plan/plan.md` (use consensus skill for review)
5. Initialize git in `code/` directory
6. Begin analysis work in `analysis/`
7. Copy final outputs to `results/` for sharing

### What Goes Where

| Content | Directory | Git-tracked | Shareable |
|---------|-----------|-------------|-----------|
| Raw sequencing data (FASTQ, BAM, CRAM) | `data_bucket/` | No | No |
| DICOM imaging files | `data_bucket/dicom/` | No | No |
| Sample sheets, clinical data | `metadata/` | Optional | Yes |
| Technical reports, SOPs | `metadata/technical_reports/` | Optional | Yes |
| Analysis plan | `plan/plan.md` | Yes (in code/) | Yes |
| Analysis working files | `analysis/` | No | No |
| Final tables, figures | `results/` | No | Yes |
| Analysis reports (HTML/PDF) | `results/reports/` | No | Yes |
| Scripts, pipelines | `code/` | Yes | Yes |
| Pipeline configs | `code/configs/` | Yes | Yes |
| Nextflow work dir | `work/` | No | No |
| Temp/intermediate files | `temp/` | No | No |
| CLAUDE.md / AGENTS.md | project root | No | No |
| Reference genomes | `/home/kgs24/ref/` | No | No |

### Sharing With Collaborators

To share results with collaborators, provide access to:
- `results/` — all final outputs (tables, figures, reports)
- `metadata/` — study context and documentation

**Do NOT share:** `code/`, `CLAUDE.md`, `AGENTS.md`, `work/`, `temp/`, `analysis/`

To share methodology for reproducibility, share `code/` separately (e.g., as a git repository).

## Integration with Consensus Skill

This skill works with the `claude-codex-gemini-consensus` skill:

1. **Planning phase:** Create `plan/plan.md` using the consensus analysis planning workflow
2. **Execution phase:** Work in `analysis/` following the approved plan
3. **Review phase:** Use consensus code review on `code/` directory
4. **Reporting phase:** Generate reports to `results/reports/` using the scientific analysis workflow
