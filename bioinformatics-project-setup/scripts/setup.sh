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
# Must remain empty for mounting (gcsfuse, s3fs, etc.)
mkdir -p data_bucket

# --- Metadata ---
mkdir -p metadata

# --- Planning ---
mkdir -p plan

# --- Analysis workspace ---
mkdir -p analysis

# --- Results (shareable, collaborator-facing) ---
mkdir -p results

# --- Code (git-tracked) ---
mkdir -p code

# --- Temporary / work directories ---
mkdir -p work
mkdir -p temp

# --- Reference directory (shared across projects) ---
if [ ! -d "$REF_DIR" ]; then
    echo "Reference directory $REF_DIR does not exist. Creating..."
    mkdir -p "$REF_DIR"
    echo "Reference directory created at $REF_DIR"
else
    echo "Reference directory exists at $REF_DIR"
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

See bioinformatics-project-setup SKILL.md for full documentation.

## Key Rules
- data_bucket/ is READ-ONLY (mounted cloud storage)
- All code goes in code/ (git-tracked)
- Shareable results go in results/ (no code, no CLAUDE.md)
- plan/ and analysis/ follow consensus skill workflow
- Reference files: check $REF_DIR first, download there if missing
- Temporary files go in work/ or temp/
MINEOF
fi

# --- AGENTS.md symlink ---
ln -sf CLAUDE.md AGENTS.md
echo "Created AGENTS.md -> CLAUDE.md symlink"

# --- Root .gitignore ---
cat > .gitignore << 'GIEOF'
# Only code/ is git-tracked via its own repo
data_bucket/
analysis/
results/
metadata/
plan/
work/
temp/
.nextflow/
.nextflow.log*
CLAUDE.md
AGENTS.md
.DS_Store
Thumbs.db
.env
*.log
GIEOF
echo "Created root .gitignore"

# --- Initialize git in code/ ---
if [ ! -d code/.git ]; then
    cd code
    git init

    cat > .gitignore << 'CODEGI'
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

# Large data files (should not be in code/)
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

    cat > README.md << CREADME
# $STUDY_TITLE — Code

All scripts, pipelines, and configuration files for this analysis.

Reference files: \`$REF_DIR\`
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

- **Data type**: [WGS / WES / RNA-seq / scRNA-seq / DICOM / Other]
- **Organism**: [Human / Mouse / Other]
- **Samples**: [N samples, groups, conditions]
- **Data location**: `data_bucket/`

## Reference Files Required

- [ ] [List reference files needed — check ref directory first]

## Planned Analyses

### 1. [Analysis Step]
- **Objective**: [what this answers]
- **Method**: [tool/approach]
- **Input**: [input data]
- **Expected output**: [tables, figures, files]
- **Status**: ☐ Not started

## Deliverables

| Deliverable | Format | Location |
|-------------|--------|----------|
| [Output] | [format] | `results/` |

## Quality Control Checkpoints

- [ ] [Define QC checkpoints for this project]

## Review Notes

[To be filled during consensus review]
PLANEOF
echo "Created plan/plan.md template"

# --- Summary ---
echo ""
echo "=== Setup Complete ==="
echo ""
echo "  $PROJECT_DIR/"
echo "  ├── CLAUDE.md / AGENTS.md"
echo "  ├── data_bucket/    (mount cloud storage here)"
echo "  ├── metadata/"
echo "  ├── plan/plan.md    (analysis plan template)"
echo "  ├── analysis/"
echo "  ├── results/"
echo "  ├── code/           (git initialized)"
echo "  ├── work/"
echo "  └── temp/"
echo ""
echo "Reference files: $REF_DIR"
