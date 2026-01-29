---
name: scientific-figures
description: |
  Comprehensive guide for creating publication-ready scientific figures.
  Covers technical requirements (DPI, formats, sizing), best practices for various plot types,
  panel figure assembly, caption writing, color accessibility, and language-specific tips for Python and R.

  Integrates with claude-codex-gemini-consensus skill for figure generation during analysis execution
  and report generation phases. All figures undergo multi-model validation for scientific accuracy.

routing_description: |
  Use this skill when creating figures for scientific publications, manuscripts, posters, or presentations.
  Covers all aspects from technical specifications to aesthetic design and accessibility.

routing_keywords:
  - figure
  - figures
  - plot
  - plots
  - visualization
  - chart
  - graph
  - publication figure
  - manuscript figure
  - scientific figure
  - ggplot
  - matplotlib
  - seaborn
  - panel figure
  - figure caption
  - DPI
  - resolution
---

# Scientific Figures: Publication-Ready Guide

Comprehensive skill for creating publication-quality figures for scientific manuscripts, posters, and presentations.

## Integration with Consensus Workflow

This skill integrates with the **claude-codex-gemini-consensus** workflow:

```
ANALYSIS EXECUTION (from analysis/plan.md)
    │
    ├── [EXECUTE] Run analyses per plan
    │
    ├── [FIGURES] Generate figures using this skill  ← YOU ARE HERE
    │   ├── Create standalone figure scripts (analysis/scripts/fig01_*.py)
    │   ├── Export to analysis/figures/
    │   ├── Write publication-ready captions
    │   └── Validate with Codex + Gemini
    │
    └── [REPORT] Include figures in analysis/report.md
```

**Figure validation requirements:**
- All figures reviewed by Claude + Codex + Gemini before inclusion in report
- Scientific accuracy verified against analysis results
- Technical specifications checked (DPI, format, sizing)
- Accessibility validated (colorblind-safe, readable fonts)

---

## Technical Requirements

### Resolution (DPI) Standards

| Figure Type | Minimum DPI | Recommended DPI | Notes |
|-------------|-------------|-----------------|-------|
| **Line art** (diagrams, graphs with lines) | 600 | 1000 | Black/white only, no grayscale |
| **Halftone** (photographs, images) | 300 | 300-400 | Continuous tone images |
| **Combination** (text + images) | 500 | 600 | Mixed line art and halftone |
| **Color figures** | 300 | 300-400 | CMYK for print, RGB for online |

> **Warning:** Web images (72 DPI) are NOT acceptable for publication. Always capture/export at print resolution.

### File Formats

| Format | Use Case | Pros | Cons |
|--------|----------|------|------|
| **TIFF** | Final submission | Lossless, universally accepted | Large file size |
| **EPS** | Vector graphics | Scalable, editable | Not for photographs |
| **PDF** | Vector + raster combined | Preserves layers, fonts | Variable support |
| **PNG** | Screen/web, drafts | Lossless compression | Not ideal for print |
| **SVG** | Vector graphics, web | Fully scalable, editable | Limited journal support |
| **JPEG** | Never for publication | - | Lossy compression artifacts |

**Recommended workflow:**
1. Create figures in vector format (SVG/PDF)
2. Export final as TIFF (300-600 DPI) for submission
3. Keep source files for revisions

### Figure Dimensions

**Nature family journals:**
- Single column: 88 mm (3.46 inches)
- 1.5 column: 120 mm (4.72 inches)
- Double column: 180 mm (7.09 inches)
- Maximum height: 230 mm (9.06 inches)

**General guidelines:**
- Design at FINAL print size (don't scale down later)
- Square subplots: ~3 x 3 inches each
- Aspect ratios: 4:3 or 16:9 for presentations

### Font Specifications

| Element | Size Range | Recommended |
|---------|------------|-------------|
| Axis labels | 8-12 pt | 9-10 pt |
| Tick labels | 7-10 pt | 8-9 pt |
| Legend text | 7-10 pt | 8-9 pt |
| Panel labels (A, B, C) | 10-14 pt | 12 pt bold |
| Figure title | 10-12 pt | 10 pt bold |

**Font families:**
- **Sans-serif** (Arial, Helvetica): Cleaner for figures, better screen readability
- **Serif** (Times): Match manuscript body text
- Keep consistent throughout all figures

---

## Panel Figures (Multi-Panel Layout)

### Panel Labeling Conventions

| Journal Style | Format | Example |
|---------------|--------|---------|
| Nature, Science | Lowercase bold | **(a)**, **(b)**, **(c)** |
| Cell, NEJM | Uppercase bold | **A**, **B**, **C** |
| AHA journals | Uppercase bold Arial 12.6pt | **A**, **B**, **C** |
| JMR | Lowercase, lower-left | (a), (b), (c) |

**Best practices:**
- Position labels consistently (typically upper-left corner)
- Do not box labels or add periods after them
- Use 12 pt bold sans-serif (Arial/Helvetica)
- Maintain 2-3 mm padding from plot edges

### Hierarchy for Complex Figures

When panels have sub-components:

```
Preferred: A, B, C → i, ii, iii → (1), (2), (3)
           Ai, Aii, Bi, Bii

Avoid:     Aa, Ab, Ba, Bb (confusing hierarchy)
```

### Layout Guidelines

```
GOOD: Horizontal reading order         BAD: Vertical-first layout
┌─────┬─────┬─────┐                    ┌─────┬─────┐
│  A  │  B  │  C  │                    │  A  │  D  │
├─────┼─────┼─────┤                    ├─────┼─────┤
│  D  │  E  │  F  │                    │  B  │  E  │
└─────┴─────┴─────┘                    ├─────┼─────┤
                                       │  C  │  F  │
                                       └─────┴─────┘
```

- Arrange panels left-to-right, top-to-bottom
- Align baselines and axes where appropriate
- Use consistent spacing between panels (3-5 mm)
- Submit multi-panel figures as ONE file

---

## Figure Types: When to Use What

### Categorical Comparisons

| Plot Type | Use When | Avoid When |
|-----------|----------|------------|
| **Bar chart** | Comparing categories, counts, proportions | >10 categories, showing distributions |
| **Grouped bar** | Comparing categories across groups | Many groups (cluttered) |
| **Stacked bar** | Part-to-whole relationships | Comparing middle segments |
| **Dot plot** | Few categories, precise values | Large datasets |

**Bar chart requirements:**
- Start y-axis at zero (unless log scale)
- Include error bars with clear definition (SD, SEM, 95% CI)
- Order bars meaningfully (by value or logical grouping)

### Distributions

| Plot Type | Use When | Avoid When |
|-----------|----------|------------|
| **Histogram** | Single distribution shape | Comparing groups |
| **Box plot** | Comparing distributions across groups | Need to see all data points |
| **Violin plot** | Distribution shape + comparison | Few data points per group |
| **Density plot** | Smooth distribution estimate | Discrete data |
| **Beeswarm/strip plot** | Small-n, show all points | Large datasets |

**Box plot conventions:**
- Box: IQR (25th-75th percentile)
- Line: Median
- Whiskers: 1.5×IQR or min/max
- Points: Outliers beyond whiskers
- Always define in caption

### Relationships & Correlations

| Plot Type | Use When | Avoid When |
|-----------|----------|------------|
| **Scatter plot** | Two continuous variables | Overplotting (>1000 points) |
| **Line plot** | Time series, connected observations | Unordered data |
| **Heatmap** | Matrix data, correlations, expression | Few variables |
| **Bubble chart** | Three variables (x, y, size) | Too many bubbles |

**Scatter plot requirements:**
- Include correlation coefficient if relevant (r or ρ)
- Add regression line with confidence band if showing relationship
- Consider jittering for overlapping discrete values
- Use transparency (alpha) for dense data

### Survival Analysis (Kaplan-Meier)

**Required elements:**
1. Step function curves for each group
2. Censoring marks (tick marks or dots) — define in caption
3. Number at risk table below x-axis
4. P-value from log-rank test (or specify test used)
5. Hazard ratio with 95% CI if comparing groups
6. Median survival with 95% CI for each group

**Example structure:**
```
┌────────────────────────────────────────┐
│  [Kaplan-Meier curves with CI bands]   │
│  [Censoring tick marks on curves]      │
├────────────────────────────────────────┤
│  Number at risk:                       │
│  Group A: 120  98  76  54  32  18  8   │
│  Group B: 115  85  62  41  25  12  4   │
│           0   12  24  36  48  60  72   │
│                 Time (months)          │
└────────────────────────────────────────┘
```

### Forest Plots (Meta-analysis, Subgroups)

**Required elements:**
1. Study/subgroup labels on left
2. Effect sizes (HR, OR, RR) with 95% CI
3. Horizontal lines spanning CI
4. Vertical line at null effect (HR=1, OR=1)
5. Point size proportional to weight/sample size
6. Summary diamond for pooled estimate
7. Heterogeneity statistics (I², Q, p-value)

### Volcano Plots (Differential Expression)

**Required elements:**
1. X-axis: log2 fold change
2. Y-axis: -log10(p-value) or -log10(FDR)
3. Horizontal threshold line (significance cutoff)
4. Vertical threshold lines (fold change cutoffs)
5. Color coding: up (red), down (blue), NS (gray)
6. Label top significant genes/features
7. Report total counts in each category

### Heatmaps

**Required elements:**
1. Clear row and column labels (or clustering dendrogram)
2. Color bar with scale and units
3. Appropriate color palette (see Accessibility section)
4. Clustering method stated in caption if used
5. Normalization/scaling method stated

---

## Color Guidelines

### Colorblind-Accessible Palettes

> **~8% of men and ~0.5% of women have color vision deficiency.**
> Half of published biological figures are partially or fully inaccessible.

**Recommended palettes:**

| Palette | Type | Use Case | Package |
|---------|------|----------|---------|
| **viridis** | Sequential | Continuous data | matplotlib, viridis (R) |
| **cividis** | Sequential | Colorblind-optimized viridis | matplotlib |
| **plasma** | Sequential | High contrast continuous | matplotlib |
| **RdBu** (diverging) | Diverging | Centered data (z-scores) | ColorBrewer |
| **Okabe-Ito** | Qualitative | Categorical (8 colors) | Manual definition |

**Colors to AVOID:**
- Red + Green combinations (most common CVD)
- Red + Black combinations
- Rainbow color schemes
- Pure red for important elements

**Okabe-Ito palette (8 colorblind-safe colors):**
```
#E69F00  Orange
#56B4E9  Sky Blue
#009E73  Bluish Green
#F0E442  Yellow
#0072B2  Blue
#D55E00  Vermillion
#CC79A7  Reddish Purple
#999999  Gray
```

### Additional Accessibility Strategies

1. **Use shapes** in addition to colors (circles, squares, triangles)
2. **Use line styles** (solid, dashed, dotted) with colors
3. **Test in grayscale** — figure should still be interpretable
4. **Add direct labels** instead of relying on color legends
5. **Use thick lines** (1.5-2 pt minimum)

### Testing Tools

- **Viz Palette** (online): https://projects.susielu.com/viz-palette
- **colorblindr** (R): Simulates CVD on ggplot figures
- **Color Oracle** (desktop): System-wide CVD simulation

---

## Caption Writing

### Structure (IMRAD for Figures)

```
Figure X. [TITLE — bold, one sentence describing the figure]

[DESCRIPTION — what is shown, not the results]
(a) Description of panel a. (b) Description of panel b.

[DEFINITIONS — all abbreviations, symbols, colors]
Error bars represent mean ± SEM (n = X per group).
*P < 0.05, **P < 0.01, ***P < 0.001 (test name).

[STATISTICS — exact values]
HR = 0.65 (95% CI: 0.48–0.88), P = 0.005 (log-rank test).

[SOURCE — if adapted from published work]
Adapted from [Reference] with permission.
```

### Caption Checklist

- [ ] Brief title (bold) summarizes the entire figure
- [ ] Each panel described in order (a, b, c...)
- [ ] All abbreviations defined (even if defined in text)
- [ ] All symbols explained (*, †, ‡)
- [ ] Color coding explained
- [ ] Error bar definition (SD, SEM, 95% CI) with n
- [ ] Statistical test named with degrees of freedom
- [ ] Exact P-values (not just <0.05)
- [ ] Sample sizes for each group
- [ ] Scale bars defined (for images/microscopy)
- [ ] Figure is understandable without reading main text

### Examples

**Good caption (Kaplan-Meier):**
```
Figure 2. Overall survival by treatment group.

Kaplan-Meier curves showing overall survival for patients receiving
treatment A (blue, n = 120) versus treatment B (orange, n = 115).
Shaded areas represent 95% confidence intervals. Tick marks indicate
censored observations. HR = 0.65 (95% CI: 0.48–0.88), P = 0.005
(log-rank test). Median survival: treatment A, 18.3 months
(95% CI: 15.2–21.4); treatment B, 12.1 months (95% CI: 9.8–14.4).
```

**Good caption (multi-panel):**
```
Figure 3. Immune cell infiltration predicts treatment response.

(a) Representative immunohistochemistry images showing CD8+ T cell
infiltration in responders (top) and non-responders (bottom).
Scale bars, 100 μm. (b) Quantification of CD8+ cells per mm²
(n = 45 responders, n = 38 non-responders). Box plots show median
and IQR; whiskers extend to 1.5× IQR. ***P < 0.001 (Mann-Whitney U test).
(c) ROC curve for CD8+ density as predictor of response. AUC = 0.82
(95% CI: 0.74–0.90). Dashed line indicates random classifier.
```

---

## Python Implementation

### Setup: Publication Style

```python
import matplotlib.pyplot as plt
import matplotlib as mpl
import seaborn as sns
import numpy as np

# Publication-quality defaults
def set_publication_style():
    """Configure matplotlib for publication-quality figures."""
    plt.style.use('seaborn-v0_8-whitegrid')

    mpl.rcParams.update({
        # Figure
        'figure.figsize': (3.5, 3.5),  # Single column width
        'figure.dpi': 300,
        'figure.facecolor': 'white',
        'savefig.dpi': 300,
        'savefig.bbox': 'tight',
        'savefig.pad_inches': 0.05,

        # Font
        'font.family': 'sans-serif',
        'font.sans-serif': ['Arial', 'Helvetica'],
        'font.size': 9,
        'axes.labelsize': 9,
        'axes.titlesize': 10,
        'xtick.labelsize': 8,
        'ytick.labelsize': 8,
        'legend.fontsize': 8,

        # Lines
        'lines.linewidth': 1.5,
        'lines.markersize': 5,
        'axes.linewidth': 0.8,
        'xtick.major.width': 0.8,
        'ytick.major.width': 0.8,

        # Grid
        'axes.grid': True,
        'grid.alpha': 0.3,
        'grid.linewidth': 0.5,

        # Legend
        'legend.frameon': False,
        'legend.loc': 'best',

        # Math text
        'mathtext.fontset': 'stix',
        'mathtext.default': 'regular',
    })

set_publication_style()
```

### Creating Figures

```python
# ALWAYS explicitly set figure size
fig, ax = plt.subplots(figsize=(3.5, 3.5))

# Use constrained_layout for multi-panel figures
fig, axes = plt.subplots(2, 2, figsize=(7, 7), constrained_layout=True)

# Add panel labels
for i, ax in enumerate(axes.flat):
    ax.text(-0.15, 1.05, chr(65 + i),  # A, B, C, D...
            transform=ax.transAxes,
            fontsize=12, fontweight='bold',
            va='bottom', ha='right')
```

### Colorblind-Safe Palettes

```python
# Viridis (sequential)
cmap = plt.cm.viridis
colors = cmap(np.linspace(0, 1, 5))

# Okabe-Ito (categorical)
okabe_ito = ['#E69F00', '#56B4E9', '#009E73', '#F0E442',
             '#0072B2', '#D55E00', '#CC79A7', '#999999']
sns.set_palette(okabe_ito)

# Or use seaborn's colorblind palette
sns.set_palette('colorblind')
```

### Saving Figures

```python
def save_publication_figure(fig, filename, formats=['svg', 'tiff', 'pdf']):
    """Save figure in multiple formats for publication."""
    for fmt in formats:
        fig.savefig(
            f'{filename}.{fmt}',
            format=fmt,
            dpi=300,
            bbox_inches='tight',
            pad_inches=0.05,
            facecolor='white',
            edgecolor='none'
        )
        print(f"Saved: {filename}.{fmt}")

# Usage
save_publication_figure(fig, 'analysis/figures/fig01_survival')
```

### Common Plot Templates

```python
# Kaplan-Meier survival plot
from lifelines import KaplanMeierFitter
from lifelines.plotting import add_at_risk_counts

fig, ax = plt.subplots(figsize=(4, 4))
kmf = KaplanMeierFitter()

for group, color in zip(['A', 'B'], ['#0072B2', '#D55E00']):
    mask = data['group'] == group
    kmf.fit(data.loc[mask, 'time'],
            data.loc[mask, 'event'],
            label=f'Group {group}')
    kmf.plot_survival_function(ax=ax, ci_show=True, color=color)

ax.set_xlabel('Time (months)')
ax.set_ylabel('Survival probability')
ax.set_ylim(0, 1.05)
add_at_risk_counts(kmf, ax=ax)
ax.legend(frameon=False, loc='lower left')
```

```python
# Box plot with individual points
fig, ax = plt.subplots(figsize=(3.5, 4))

# Box plot
sns.boxplot(data=df, x='group', y='value', ax=ax,
            palette='colorblind', width=0.5,
            fliersize=0)  # Hide outlier points from boxplot

# Overlay individual points
sns.stripplot(data=df, x='group', y='value', ax=ax,
              color='black', alpha=0.5, size=4, jitter=0.2)

ax.set_xlabel('')
ax.set_ylabel('Measurement (units)')
```

```python
# Heatmap with proper colorbar
fig, ax = plt.subplots(figsize=(5, 4))

im = ax.imshow(matrix, cmap='viridis', aspect='auto')
cbar = plt.colorbar(im, ax=ax, shrink=0.8)
cbar.set_label('Expression (z-score)', fontsize=9)

ax.set_xticks(range(len(x_labels)))
ax.set_xticklabels(x_labels, rotation=45, ha='right')
ax.set_yticks(range(len(y_labels)))
ax.set_yticklabels(y_labels)
```

### Rasterization for Dense Plots

```python
# Rasterize only the scatter points (many points), keep axes as vector
fig, ax = plt.subplots(figsize=(4, 4))

scatter = ax.scatter(x, y, alpha=0.5, s=10, rasterized=True)
# rasterized=True prevents huge file sizes while keeping text as vector

fig.savefig('figure.pdf', dpi=300)  # Rasterized elements at 300 DPI
```

---

## R Implementation

### Setup: Publication Style

```r
library(ggplot2)
library(ggpubr)
library(viridis)
library(cowplot)

# Publication theme
theme_publication <- function(base_size = 9, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      # Panel
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.3, color = "grey90"),
      panel.border = element_rect(linewidth = 0.8),

      # Axes
      axis.text = element_text(size = rel(0.9), color = "black"),
      axis.title = element_text(size = rel(1.0)),
      axis.ticks = element_line(linewidth = 0.5),

      # Legend
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.title = element_text(size = rel(0.9)),
      legend.text = element_text(size = rel(0.8)),

      # Strip (facets)
      strip.background = element_rect(fill = "grey95", color = NA),
      strip.text = element_text(size = rel(0.9), face = "bold"),

      # Plot
      plot.title = element_text(size = rel(1.1), face = "bold", hjust = 0),
      plot.subtitle = element_text(size = rel(0.9), hjust = 0),
      plot.margin = margin(5, 5, 5, 5)
    )
}

# Set as default
theme_set(theme_publication())
```

### Colorblind-Safe Palettes

```r
# Okabe-Ito palette
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#999999")

scale_color_okabe <- function(...) {
  scale_color_manual(values = okabe_ito, ...)
}

scale_fill_okabe <- function(...) {
  scale_fill_manual(values = okabe_ito, ...)
}

# Viridis for continuous
# scale_color_viridis_c() / scale_fill_viridis_c()

# Viridis for discrete
# scale_color_viridis_d() / scale_fill_viridis_d()
```

### Creating Multi-Panel Figures

```r
library(patchwork)  # or cowplot

# Create individual plots
p1 <- ggplot(data, aes(x, y)) +
  geom_point() +
  labs(tag = "A")

p2 <- ggplot(data, aes(group, value)) +
  geom_boxplot() +
  labs(tag = "B")

p3 <- ggplot(data, aes(time, survival, color = treatment)) +
  geom_line() +
  labs(tag = "C")

# Combine with patchwork
combined <- (p1 | p2) / p3 +
  plot_annotation(
    title = "Figure 1",
    theme = theme(plot.title = element_text(face = "bold"))
  )

# Or with cowplot
combined <- plot_grid(p1, p2, p3,
                      labels = "AUTO",  # A, B, C...
                      label_size = 12,
                      label_fontface = "bold",
                      ncol = 2)
```

### Saving Figures

```r
save_publication_figure <- function(plot, filename,
                                    width = 3.5, height = 3.5,
                                    units = "in", dpi = 300) {
  # Save as multiple formats
  ggsave(paste0(filename, ".pdf"), plot,
         width = width, height = height, units = units, dpi = dpi)
  ggsave(paste0(filename, ".tiff"), plot,
         width = width, height = height, units = units, dpi = dpi,
         compression = "lzw")
  ggsave(paste0(filename, ".svg"), plot,
         width = width, height = height, units = units)

  message("Saved: ", filename, " (.pdf, .tiff, .svg)")
}

# Usage
save_publication_figure(p, "analysis/figures/fig01_survival",
                        width = 4, height = 4)
```

### Common Plot Templates

```r
# Kaplan-Meier survival plot
library(survival)
library(survminer)

fit <- survfit(Surv(time, status) ~ group, data = data)

p <- ggsurvplot(fit,
  data = data,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = TRUE,
  palette = c("#0072B2", "#D55E00"),
  xlab = "Time (months)",
  ylab = "Survival probability",
  legend.title = "Group",
  legend.labs = c("A", "B"),
  risk.table.height = 0.25,
  ggtheme = theme_publication()
)

# Add HR annotation
hr <- summary(coxph(Surv(time, status) ~ group, data = data))
hr_text <- sprintf("HR = %.2f (95%% CI: %.2f-%.2f)",
                   hr$conf.int[1], hr$conf.int[3], hr$conf.int[4])
p$plot <- p$plot +
  annotate("text", x = Inf, y = 0.9, label = hr_text,
           hjust = 1.1, size = 3)
```

```r
# Box plot with statistics
library(ggpubr)

p <- ggboxplot(data, x = "group", y = "value",
               color = "group", palette = "colorblind",
               add = "jitter", add.params = list(size = 2, alpha = 0.5)) +
  stat_compare_means(method = "wilcox.test",
                     label = "p.signif",
                     comparisons = list(c("A", "B"), c("B", "C"))) +
  labs(x = "", y = "Measurement (units)") +
  theme(legend.position = "none")
```

```r
# Volcano plot
library(ggrepel)

p <- ggplot(de_results, aes(x = log2FC, y = -log10(padj))) +
  geom_point(aes(color = significance), alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("Up" = "#D55E00",
                                "Down" = "#0072B2",
                                "NS" = "grey60")) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey40") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "grey40") +
  geom_text_repel(
    data = subset(de_results, padj < 0.001 & abs(log2FC) > 2),
    aes(label = gene),
    size = 2.5, max.overlaps = 20
  ) +
  labs(x = expression(log[2]~"fold change"),
       y = expression(-log[10]~"adjusted p-value"),
       color = "") +
  theme(legend.position = c(0.9, 0.9))
```

```r
# Heatmap with ComplexHeatmap
library(ComplexHeatmap)
library(circlize)

col_fun <- colorRamp2(c(-2, 0, 2), c("#0072B2", "white", "#D55E00"))

ht <- Heatmap(matrix,
  name = "Z-score",
  col = col_fun,
  show_row_names = TRUE,
  show_column_names = TRUE,
  row_names_gp = gpar(fontsize = 8),
  column_names_gp = gpar(fontsize = 8),
  clustering_distance_rows = "euclidean",
  clustering_method_rows = "ward.D2",
  row_dend_width = unit(10, "mm"),
  column_dend_height = unit(10, "mm"),
  heatmap_legend_param = list(
    title_gp = gpar(fontsize = 9),
    labels_gp = gpar(fontsize = 8)
  )
)

# Save
pdf("analysis/figures/fig_heatmap.pdf", width = 6, height = 8)
draw(ht)
dev.off()
```

---

## Standalone Figure Scripts

For consensus workflow integration, create **standalone scripts** for each figure:

```
analysis/
├── plan.md
├── scripts/
│   ├── fig01_survival.py      # Generates fig01
│   ├── fig02_volcano.R        # Generates fig02
│   ├── fig03_heatmap.py       # Generates fig03
│   └── tab01_baseline.R       # Generates table 01
├── figures/
│   ├── fig01_survival.pdf
│   ├── fig01_survival.tiff
│   ├── fig02_volcano.pdf
│   └── ...
└── report.md
```

**Script template (Python):**

```python
#!/usr/bin/env python3
"""
Figure 01: Overall survival by treatment group

Generates: analysis/figures/fig01_survival.{pdf,tiff,svg}
Data source: data/clinical_data.csv
"""

import matplotlib.pyplot as plt
import pandas as pd
from pathlib import Path

# Configuration
OUTPUT_DIR = Path("analysis/figures")
FIGURE_NAME = "fig01_survival"

def create_figure(data):
    """Create the survival figure."""
    fig, ax = plt.subplots(figsize=(4, 4))
    # ... plotting code ...
    return fig

def main():
    # Load data
    data = pd.read_csv("data/clinical_data.csv")

    # Create figure
    fig = create_figure(data)

    # Save in multiple formats
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for fmt in ['pdf', 'tiff', 'svg']:
        fig.savefig(OUTPUT_DIR / f"{FIGURE_NAME}.{fmt}",
                    dpi=300, bbox_inches='tight')

    print(f"Saved: {OUTPUT_DIR / FIGURE_NAME}")
    plt.close(fig)

if __name__ == "__main__":
    main()
```

**Script template (R):**

```r
#!/usr/bin/env Rscript
#' Figure 02: Volcano plot of differential expression
#'
#' Generates: analysis/figures/fig02_volcano.{pdf,tiff,svg}
#' Data source: results/de_analysis.csv

library(ggplot2)
library(ggrepel)

# Configuration
OUTPUT_DIR <- "analysis/figures"
FIGURE_NAME <- "fig02_volcano"

create_figure <- function(data) {
  p <- ggplot(data, aes(x = log2FC, y = -log10(padj))) +
    # ... plotting code ...
    theme_publication()
  return(p)
}

main <- function() {
  # Load data
  data <- read.csv("results/de_analysis.csv")

  # Create figure
  p <- create_figure(data)

  # Save in multiple formats
  dir.create(OUTPUT_DIR, showWarnings = FALSE, recursive = TRUE)

  ggsave(file.path(OUTPUT_DIR, paste0(FIGURE_NAME, ".pdf")), p,
         width = 4, height = 4, dpi = 300)
  ggsave(file.path(OUTPUT_DIR, paste0(FIGURE_NAME, ".tiff")), p,
         width = 4, height = 4, dpi = 300, compression = "lzw")
  ggsave(file.path(OUTPUT_DIR, paste0(FIGURE_NAME, ".svg")), p,
         width = 4, height = 4)

  message("Saved: ", file.path(OUTPUT_DIR, FIGURE_NAME))
}

main()
```

---

## Validation Checklist

Before submitting figures through the consensus workflow, verify:

### Technical Requirements
- [ ] Resolution: ≥300 DPI for images, ≥600 DPI for line art
- [ ] Format: TIFF or PDF for final submission
- [ ] Dimensions: Within journal limits
- [ ] Fonts: 8-12 pt, embedded, sans-serif preferred
- [ ] File size: Under journal limit (typically 10-50 MB)

### Scientific Accuracy
- [ ] Data correctly represented (values match source)
- [ ] Appropriate plot type for data type
- [ ] Error bars correctly calculated and labeled
- [ ] Statistical tests appropriate and correctly reported
- [ ] Axes start at appropriate values (zero for bar charts)
- [ ] No misleading truncation or scaling

### Accessibility
- [ ] Colorblind-safe palette used
- [ ] Figure interpretable in grayscale
- [ ] Shapes/patterns used in addition to colors
- [ ] Sufficient contrast between elements
- [ ] Font size readable at final print size

### Caption Completeness
- [ ] Brief title describes figure content
- [ ] All panels described in order
- [ ] All abbreviations defined
- [ ] Error bar definition included (with n)
- [ ] Statistical test and exact P-values reported
- [ ] Color/symbol coding explained
- [ ] Scale bars defined (for images)
- [ ] Sample sizes stated

### Consensus Integration
- [ ] Figure script is standalone and reproducible
- [ ] Output saved to `analysis/figures/`
- [ ] Source data traceable
- [ ] Caption written and ready for report.md
- [ ] Submitted for Codex + Gemini validation

---

## Quick Reference: Journal Requirements

| Journal | Column Width | DPI | Format | Panel Labels |
|---------|--------------|-----|--------|--------------|
| **Nature** | 88/180 mm | 300-600 | TIFF/EPS | lowercase (a,b,c) |
| **Science** | 86/180 mm | 300-600 | EPS/TIFF | UPPERCASE (A,B,C) |
| **Cell** | 85/174 mm | 300-1000 | TIFF/EPS | UPPERCASE (A,B,C) |
| **NEJM** | 86/178 mm | 300 | TIFF/EPS | UPPERCASE (A,B,C) |
| **PNAS** | 86/178 mm | 300-600 | TIFF/EPS | UPPERCASE italic |
| **PLOS** | 83/173 mm | 300 | TIFF/EPS | UPPERCASE (A,B,C) |
| **Elsevier** | 90/190 mm | 300-1000 | TIFF/EPS | varies |

**Always verify with target journal's current author guidelines.**

---

## Sources and References

- [Nature Figure Guidelines](https://www.nature.com/nature/for-authors/formatting-guide)
- [Science Author Instructions](https://www.science.org/content/page/instructions-preparing-initial-manuscript)
- [Wiley Figure Preparation](https://authorservices.wiley.com/author-resources/Journal-Authors/Prepare/manuscript-preparation-guidelines.html/figure-preparation.html)
- [CalTech Figure Caption Handout](https://writing.caltech.edu/documents/27629/HWC-FigureCaptionHandout.1-2024.pdf)
- [Viridis R Package](https://sjmgarnier.github.io/viridis/)
- [ggpubr Package](https://rpkgs.datanovia.com/ggpubr/)
- [Matplotlib for Papers (GitHub)](https://github.com/jbmouret/matplotlib_for_papers)
- [Publication-Ready Figures Tutorial](https://github.com/ICWallis/tutorial-publication-ready-figures)
- [Colorblind-Friendly Figures Guidelines](https://www.nki.nl/about-us/responsible-research/guidelines-color-blind-friendly-figures)
- [Crameri et al. (2024) - Choosing Suitable Color Palettes](https://currentprotocols.onlinelibrary.wiley.com/doi/full/10.1002/cpz1.1126)
