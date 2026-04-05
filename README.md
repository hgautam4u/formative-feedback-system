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

Access n8n at http://localhost:5678

## Features

- Privacy-preserving (all data on your server)
- Zero ongoing costs
- 15-30 second feedback generation  
- Customizable for any discipline
- No programming required

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