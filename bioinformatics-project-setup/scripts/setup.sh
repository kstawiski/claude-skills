#!/usr/bin/env bash
set -euo pipefail

# Bioinformatics Project Setup Script
# Usage: bash setup.sh /path/to/project "Study Title"
# Environment: REF_DIR=/path/to/references (default: /home/kgs24/ref)

PROJECT_DIR="${1:?Usage: setup.sh <project_dir> [study_title]}"
STUDY_TITLE="${2:-Untitled Study}"
REF_DIR="${REF_DIR:-/home/kgs24/ref}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Bioinformatics Project Setup ==="
echo "Project:    $PROJECT_DIR"
echo "Title:      $STUDY_TITLE"
echo "References: $REF_DIR"
echo ""

# --- Create project root ---
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# --- Data bucket (mount point for cloud storage) ---
mkdir -p data_bucket/{bam,fastq,dicom}

# --- Metadata ---
mkdir -p metadata/{clinical_data,technical_reports,methodology}

# --- Planning ---
mkdir -p plan

# --- Analysis workspace ---
mkdir -p analysis/{qc,alignment,variant_calling,expression,differential,integration}

# --- Results (shareable, no code/technical files) ---
mkdir -p results/{tables,figures,reports,supplementary}

# --- Code (git-tracked) ---
mkdir -p code/{pipelines,scripts,configs,envs,notebooks}

# --- Temporary / work directories ---
mkdir -p work
mkdir -p temp

# --- Reference directory (shared across projects) ---
if [ ! -d "$REF_DIR" ]; then
    echo "Reference directory $REF_DIR does not exist."
    echo "Creating it now..."
    mkdir -p "$REF_DIR"/{genomes/{GRCh38,GRCh37,mm10},annotations/{gtf,bed,dbsnp},iGenomes,indices/{bwa,star,hisat2,bowtie2}}
    cat > "$REF_DIR/README.md" << 'REFEOF'
# Reference Files

Shared reference genomes, annotations, and aligner indices.

## Structure

- `genomes/` — Reference genome FASTA files and their indices
- `annotations/` — GTF, BED, dbSNP, and other annotation files
- `iGenomes/` — Illumina iGenomes collections
- `indices/` — Pre-built aligner indices (BWA, STAR, HISAT2, Bowtie2)

## Usage

Projects should check this directory before downloading reference files.
If a needed reference is not present, download it here (not into the project).

## Download Log

| Date | File | Source | Downloaded By |
|------|------|--------|---------------|
REFEOF
    echo "Reference directory created at $REF_DIR"
else
    echo "Reference directory exists at $REF_DIR"
    echo "Contents:"
    ls "$REF_DIR/" 2>/dev/null || echo "  (empty)"
fi

# --- Generate CLAUDE.md from template ---
TEMPLATE_FILE="$SKILL_DIR/templates/CLAUDE.md.template"
if [ -f "$TEMPLATE_FILE" ]; then
    sed \
        -e "s|{{STUDY_TITLE}}|$STUDY_TITLE|g" \
        -e "s|{{REF_DIR}}|$REF_DIR|g" \
        -e "s|{{PROJECT_DIR}}|$PROJECT_DIR|g" \
        -e "s|{{SETUP_DATE}}|$(date +%Y-%m-%d)|g" \
        "$TEMPLATE_FILE" > CLAUDE.md
    echo "Generated CLAUDE.md"
else
    echo "WARNING: Template not found at $TEMPLATE_FILE"
    echo "Generating minimal CLAUDE.md..."
    cat > CLAUDE.md << MINEOF
# Project: $STUDY_TITLE

See bioinformatics-project-setup SKILL.md for full directory structure documentation.

## Key Rules
- Raw data in data_bucket/ is READ-ONLY
- All code goes in code/ (git-tracked)
- Shareable results go in results/ (no code, no CLAUDE.md)
- Reference files: check $REF_DIR first, download there if missing
- Temporary files go in work/ or temp/
MINEOF
fi

# --- AGENTS.md symlink ---
ln -sf CLAUDE.md AGENTS.md
echo "Created AGENTS.md -> CLAUDE.md symlink"

# --- Root .gitignore (excludes everything except code/) ---
cat > .gitignore << 'GIEOF'
# Bioinformatics project root .gitignore
# Only code/ is git-tracked; everything else is excluded

# Raw data (mounted cloud storage)
data_bucket/

# Analysis workspace (large intermediate files)
analysis/

# Results (shared separately, not via git)
results/

# Metadata (may contain PHI/sensitive data)
metadata/

# Planning docs (tracked in code/ if needed)
plan/

# Temporary and work directories
work/
temp/
.nextflow/
.nextflow.log*

# Agent config (project-specific, not shared)
CLAUDE.md
AGENTS.md

# OS files
.DS_Store
Thumbs.db

# Environment
.env
*.log
GIEOF
echo "Created root .gitignore"

# --- Initialize git in code/ ---
if [ ! -d code/.git ]; then
    cd code
    git init
    cat > .gitignore << 'CODEGI'
# Code directory .gitignore

# Environment and secrets
.env
*.log

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/

# R
.Rhistory
.RData
.Rproj.user/

# Nextflow
.nextflow/
.nextflow.log*
work/

# Containers
*.sif
*.img

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Large files (use git-lfs or don't track)
*.bam
*.bai
*.cram
*.crai
*.fastq
*.fastq.gz
*.fq
*.fq.gz
*.vcf
*.vcf.gz
*.bcf
*.bed
*.fa
*.fasta
*.gtf
*.gff
*.sam
*.h5
*.hdf5
*.rds
*.RData
CODEGI

    # Initial README in code/
    cat > README.md << CREADME
# $STUDY_TITLE — Code

All scripts, pipelines, and configuration files for this analysis.

## Structure

- \`pipelines/\` — Nextflow/Snakemake/WDL pipeline definitions
- \`scripts/\` — Analysis scripts (R, Python, bash)
- \`configs/\` — Pipeline configuration and parameter files
- \`envs/\` — Conda environment YAML / container definitions
- \`notebooks/\` — Jupyter / R notebooks

## Reproducibility

This repository contains everything needed to reproduce the analysis.
Raw data and reference files are not included — see the project CLAUDE.md
for directory structure and data locations.

## Reference Files

Reference genomes and annotations are stored in: \`$REF_DIR\`
Check there before downloading any reference files.
CREADME

    git add -A
    git commit -m "Initial project setup: $STUDY_TITLE"
    cd "$PROJECT_DIR"
    echo "Initialized git repository in code/"
else
    echo "Git already initialized in code/"
fi

# --- Analysis plan template ---
cat > plan/plan.md << 'PLANEOF'
# Analysis Plan

## Metadata
- **Study title**: [TITLE]
- **Created**: [DATE]
- **Status**: DRAFT | PENDING REVIEW | APPROVED
- **PI / Lead**: [NAME]

## Objectives

1. **Primary**: [Main research question]
2. **Secondary**: [Additional questions]

## Data Description

- **Data type**: WGS / WES / RNA-seq / scRNA-seq / ATAC-seq / Other
- **Organism**: Human (GRCh38) / Mouse (mm10) / Other
- **Samples**: [N samples, groups, conditions]
- **Data location**: `data_bucket/`
- **Format**: FASTQ / BAM / CRAM / VCF / Other

## Reference Files Required

- [ ] Reference genome: [build]
- [ ] Gene annotations: [GTF version]
- [ ] Known variants: [dbSNP version]
- [ ] Target regions: [capture kit BED]
- [ ] Other: [specify]

## Planned Analyses

### 1. Quality Control
- **Tool**: FastQC, MultiQC
- **Input**: `data_bucket/fastq/`
- **Output**: `analysis/qc/`
- **Status**: ☐ Not started

### 2. [Next Analysis Step]
- **Tool**: [tool name and version]
- **Input**: [input location]
- **Output**: [output location]
- **Status**: ☐ Not started

## Deliverables

| Deliverable | Format | Location |
|-------------|--------|----------|
| QC report | HTML | `results/reports/` |
| Sample summary table | CSV | `results/tables/` |
| [Other] | [format] | `results/[subdir]/` |

## Quality Control Checkpoints

- [ ] Raw data QC passed
- [ ] Alignment QC passed (mapping rate, coverage)
- [ ] Analysis-specific QC passed
- [ ] Results reviewed by PI / collaborator

## Review Notes

[To be filled during consensus review]
PLANEOF
echo "Created plan/plan.md template"

# --- Summary ---
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Project structure:"
echo "  $PROJECT_DIR/"
echo "  ├── CLAUDE.md              (agent instructions)"
echo "  ├── AGENTS.md -> CLAUDE.md"
echo "  ├── data_bucket/           (mount cloud storage here)"
echo "  ├── metadata/              (sample sheets, clinical data)"
echo "  ├── plan/plan.md           (analysis plan template)"
echo "  ├── analysis/              (working analysis space)"
echo "  ├── results/               (shareable outputs)"
echo "  ├── code/                  (git-tracked, initialized)"
echo "  ├── work/                  (nextflow work dir)"
echo "  └── temp/                  (temporary files)"
echo ""
echo "Next steps:"
echo "  1. Mount data to data_bucket/"
echo "  2. Add sample metadata to metadata/"
echo "  3. Edit plan/plan.md with your analysis plan"
echo "  4. Use consensus skill to review the plan"
echo "  5. Start analysis in analysis/ using code from code/"
echo "  6. Place final outputs in results/"
echo ""
echo "Reference files: $REF_DIR"
