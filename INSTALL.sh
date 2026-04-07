#!/bin/bash

# ----------------------------------------------------
# Formative Feedback System - Installation Script
# ----------------------------------------------------

echo "----------------------------------------------------"
echo "  Formative Feedback System Installation"
echo "----------------------------------------------------"
echo ""

# 1. Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed. Please log out and back in, then run this script again."
    exit 1
fi

# 2. Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo "Success: Docker and Docker Compose are installed"
echo ""

# 3. Create required directories (Matching n8n volume mapping)
echo "Creating local data directories..."
mkdir -p ollama-data
mkdir -p n8n-data
mkdir -p n8n-files

# 4. Create a sample data file if it doesn't exist
# This ensures n8n doesn't error out on the first run
if [ ! -f "n8n-files/crm_submissions.xlsx" ]; then
    echo "Generating sample 'crm_submissions.xlsx' template..."
    # Note: We create a CSV that Excel can open for the user to populate.
    echo "student Name,student Id,student Email,submission Text" > n8n-files/crm_submissions.csv
    echo "Sample data template created as .csv"
    echo "Action Required: Rename to .xlsx after adding your student data."
fi

# 5. Launch Infrastructure
echo "Starting services via Docker Compose..."
docker-compose up -d

echo ""
echo "Waiting for Ollama to initialize (approx 30s)..."
# Loop to check if service is healthy could be added here for more lines
sleep 30

# 6. Pulling the base model
echo "Pulling llama3.1:8b model (this takes a few minutes)..."
docker exec -it ollama ollama pull llama3.1:8b

echo ""
echo "Creating optimized formative-feedback model..."
# 7. Create the Modelfile locally first
cat > Modelfile << 'EOF'
FROM llama3.1:8b
PARAMETER temperature 0.1
PARAMETER top_k 10
PARAMETER top_p 0.3
PARAMETER repeat_penalty 1.1
PARAMETER num_ctx 4096
PARAMETER num_thread 16
SYSTEM "You are a professional educational assistant. Provide formative feedback that is supportive, specific, and aligned with provided rubrics."
EOF

# 8. Copy and create the model inside the container
docker cp Modelfile ollama:/tmp/Modelfile
docker exec -it ollama ollama create formative-feedback -f /tmp/Modelfile
rm Modelfile

echo ""
echo "----------------------------------------------------"
echo "  Installation Complete"
echo "----------------------------------------------------"
echo ""
echo "Access n8n at: http://localhost:5678"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:5678 in your browser"
echo "2. Import workflows from the 'workflows/' folder:"
echo "   - workflows/crm-pre-submission.json"
echo "   - workflows/website-feedback.json"
echo "3. In n8n, update the Ollama model node to use: formative-feedback"
echo "4. In n8n, set the Ollama URL to: http://ollama:11434"
echo "5. Add your data to 'n8n-files/crm_submissions.xlsx'"
echo ""
echo "Full documentation is available in README.md"
echo "----------------------------------------------------"
