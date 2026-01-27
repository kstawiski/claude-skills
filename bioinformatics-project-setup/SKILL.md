---
name: bioinformatics-project-setup
description: Set up standardized bioinformatics/computational project directory structure. Enforces separation of raw data (cloud-mounted), code (git-tracked), analysis workspace, shareable results, and temporary files. Integrates with consensus skill for planning and analysis execution.
routing_description: Use this skill when setting up a new bioinformatics, genomics, imaging, or computational biology project. Handles directory scaffolding, CLAUDE.md/AGENTS.md creation, git initialization for code tracking, and reference file discovery.
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
  - imaging
  - reference genome
---

# Bioinformatics Project Setup

## Purpose

Scaffold a project with clear separation of concerns:

| Directory | Role | Git-tracked | Shareable with collaborators |
|-----------|------|-------------|------------------------------|
| `data_bucket/` | Mounted cloud storage (raw data) | No | No |
| `metadata/` | Sample metadata, clinical data, SOPs, technical reports | No | Yes |
| `plan/` | Analysis plans (consensus-reviewed) | No (copy to code/ if needed) | Yes |
| `analysis/` | Active analysis workspace | No | No |
| `results/` | Final outputs only — tables, figures, reports | No | **Yes** |
| `code/` | All code, pipelines, configs, notebooks | **Yes** | Via git repo |
| `work/` | Pipeline work directories (Nextflow etc.) | No | No |
| `temp/` | Other temporary/intermediate files | No | No |

## Core Rules

These are the rules enforced by the generated CLAUDE.md / AGENTS.md:

### 1. `data_bucket/` is a mount point — READ-ONLY

This directory is mounted from cloud object storage (GCS, S3, Wasabi, Hyperstack, etc.). It must be **empty before mounting**. Never write to it. The contents depend on the project — could be FASTQ, BAM, CRAM, VCF, DICOM, or any other format.

| Provider | Tool | Example |
|----------|------|---------|
| GCS | gcsfuse | `gcsfuse bucket-name data_bucket/` |
| AWS S3 | s3fs / goofys | `s3fs bucket-name data_bucket/ -o url=https://s3.amazonaws.com` |
| Wasabi | s3fs | `s3fs bucket-name data_bucket/ -o url=https://s3.wasabisys.com` |
| Hyperstack | s3fs | `s3fs bucket-name data_bucket/ -o url=https://s3.hyperstack.cloud` |

### 2. `plan/` and `analysis/` follow the consensus skill workflow

These directories integrate with the `claude-codex-gemini-consensus` skill:

- **`plan/plan.md`** — Master analysis plan. Created using the consensus planning workflow. Must be reviewed and marked APPROVED before execution begins.
- **`analysis/plan.md`** — Execution copy of the approved plan. Each analysis step has a status checkbox (☐ / ☑) that gets updated during execution.
- **`analysis/report.md`** — Generated after analysis completion (Methods, Results, Discussion).
- **`analysis/`** subdirectories — Created as needed by the analysis (e.g., `analysis/qc/`, `analysis/figures/`, `analysis/tables/`, `analysis/scripts/`).

The consensus skill expects this structure. See `claude-codex-gemini-consensus/SKILL.md` for the full `analysis/plan.md` template and the planning → execution → reporting workflow.

### 3. `code/` is the git repository

All code, pipelines, configuration files, environment definitions, and notebooks live in `code/`. This directory is initialized with `git init` and has its own `.gitignore`.

This is the **only** directory tracked with version control. Everything needed to review methodology and recreate the analysis must be here.

### 4. `results/` is collaborator-facing

Only final deliverables go here — tables, figures, reports, supplementary materials. Structure as needed for the project (`results/tables/`, `results/figures/`, `results/reports/`, etc.).

**Never put in results/:** source code, CLAUDE.md, AGENTS.md, log files, intermediate data, git metadata.

### 5. Temporary files go in `work/` or `temp/`

- `work/` — Pipeline work directories (Nextflow `-work-dir`, Snakemake temp, etc.)
- `temp/` — Any other intermediate or scratch files

Both are disposable and can be cleaned at any time.

### 6. Reference files — check before downloading

Reference files (genomes, annotations, indices, iGenomes, etc.) are stored in a shared directory outside the project. Default: `/home/kgs24/ref`

**Protocol for agents:**
1. **Check** if the needed reference file already exists in the reference directory
2. **Reuse** it if found — symlink into the project if a pipeline needs a local path
3. **Download** to the reference directory (not the project) if missing
4. **Document** new downloads so others know what's available

This avoids duplicating large reference files across projects.

## Usage

### Setup Script

```bash
# Basic usage:
bash setup.sh /path/to/project "My Study Title"

# Custom reference directory:
REF_DIR=/data/references bash setup.sh /path/to/project "My Study Title"
```

The script creates the directory structure, generates CLAUDE.md from a template, creates the AGENTS.md symlink, initializes git in `code/`, and creates a `plan/plan.md` template.

### Typical Workflow

1. Run `setup.sh` to scaffold the project
2. Mount raw data to `data_bucket/`
3. Add metadata to `metadata/`
4. Create analysis plan in `plan/plan.md` → review with consensus skill
5. Execute analysis in `analysis/` using code from `code/`
6. Place final outputs in `results/` for sharing
