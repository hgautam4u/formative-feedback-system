# Formative Feedback System

Self-hosted AI feedback system for educational formative assessment.

## Overview

This system provides students with AI-generated formative feedback on draft submissions using entirely self-hosted infrastructure. Built with n8n workflow automation and Ollama local language models, it eliminates privacy concerns and subscription costs while preserving instructor control over final grading.

## Quick Start
```bash
git clone https://github.com/hgautam4u/formative-feedback-system
cd formative-feedback-system
chmod +x INSTALL.sh
./INSTALL.sh
```

- Access n8n at http://localhost:5678
- Import: In n8n, click on Workflow > Import from File and select workflows/crm-grading-workflow.json.
- Configure: * Set up your local Ollama credentials in the "AI Agent" node.
- Ensure your source file crm_submissions.xlsx is placed in the project's ./data directory.

## Features

- Privacy-Preserving: All student data stays on your own server. No third-party API processing.
- Zero Ongoing Costs: No per-token fees; utilizes your existing local compute.
- Rapid Turnaround: Approximately 15–30 seconds per student feedback report.
- Plagiarism Detection: Built-in algorithmic logic to flag high-similarity submissions within the current batch.
- Customizable: Easily adjust the grading rubric and prompt instructions for any academic discipline.

## Workflow Architecture

The system follows an automated pipeline:
  - Ingestion: Reads student submissions from an Excel file.
  - Batching: Processes students individually to manage system memory.
  - Integrity Check: Compares current submission text against the rest of the batch for plagiarism.
  - AI Grading: Passes the submission and rubric to a local LLM (e.g., Gemma2 or Llama3).
  - Reporting: Generates a formatted .txt feedback report for each student and compiles a master results spreadsheet.

## Requirements

- Ubuntu 24.04 (or similar Linux)
- 8+ CPU cores
- 32GB+ RAM
- 256GB+ storage
- Docker installed

## Documentation

See `docs/` folder for detailed guides.

## License

MIT License - see LICENSE file
