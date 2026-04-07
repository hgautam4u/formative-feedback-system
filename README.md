## Formative Feedback System

Self-hosted AI feedback system for educational formative assessment.

## Overview

This system provides students with AI-generated formative feedback on draft submissions using entirely self-hosted infrastructure. Built with n8n workflow automation and Ollama local language models, it eliminates privacy concerns and subscription costs while preserving instructor control over final grading.

## Quick Start

```
git clone [https://github.com/hgautam4u/formative-feedback-system](https://github cd formative-feedback-system chmod +x INSTALL.sh ./INSTALL.sh
```

- Access n8n: Open http://localhost:5678 in your browser.
- Import Workflows: In n8n, click on Workflow  &gt;  Import from File and select a file from the workflows/ directory:
- workflows/crm-pre-submission.json (for Excel batch processing)
- workflows/website-feedback.json (for real-time web feedback)
- Configure: Ensure the AI nodes are pointed to the internal Ollama address: http://ollama:11434 .
- Data Input: Place your source file crm\_submissions.xlsx in the project's ./n8n-files directory.

## Features

- Privacy-Preserving: All student data stays on your own server. No third-party API processing.
- Zero Ongoing Costs: No per-token fees; utilizes your existing local compute.
- Rapid Turnaround: Approximately 15-30 seconds per student feedback report.
- Plagiarism Detection: Built-in algorithmic logic to flag high-similarity submissions within the current batch.
- Customizable: Easily adjust the grading rubric and prompt instructions for any academic discipline.

## Workflow Architecture

The system follows an automated pipeline:

- Ingestion: Reads student submissions from an Excel file via the n8n-files shared volume.
- Batching: Processes students individually to manage system memory and ensure stability.
- Integrity Check: Compares current submission text against the rest of the batch for plagiarism markers.
- AI Grading: Passes the submission and rubric to a local LLM (optimized Qwen 2.5 7B).
- Reporting: Generates formatted feedback for each student and compiles a master results spreadsheet.

## Requirements

## Hardware (Recommended)

- CPU: 8 +  cores (AMD Ryzen 7 / Intel i7 or better)
- RAM: 32GB +  (Required to run 7B-9B parameter models smoothly)
- Storage: 256GB +  SSD
- GPU (Optional): NVIDIA GPU with 8GB +  VRAM is highly recommended for faster inference.

## Software

- OS: Ubuntu 24.04 (or similar Linux distribution)
- Engine: Docker  &amp;  Docker Compose
- Inference: Ollama (managed via the included Docker container)

## Data Structure

The system expects an Excel file ( crm\_submissions.xlsx ) with the following columns:

- student Name
- student Id
- student Email
- submission Text
- video Link (optional)

## Documentation

For more information on configuring specific models, modifying the grading rubric, or troubleshooting Docker volumes, please see the docs/ folder.

## License

MIT License - see LICENSE file
