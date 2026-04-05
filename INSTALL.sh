#!/bin/bash

echo "════════════════════════════════════════════════════"
echo "  Formative Feedback System Installation"
echo "════════════════════════════════════════════════════"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. Please log out and back in, then run this script again."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Create directories
echo "📁 Creating directories..."
mkdir -p ollama-data n8n-data n8n-files/submissions n8n-files/feedback

echo "🚀 Starting services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for Ollama to initialize..."
echo "   This may take 5-10 minutes for model download"
echo "   You can monitor progress with: docker logs -f ollama"
echo ""

sleep 20

echo "📥 Pulling qwen2.5:7b model (this takes 5-10 minutes)..."
docker exec ollama ollama pull qwen2.5:7b

echo ""
echo "🔧 Creating optimized formative feedback model..."
cat > /tmp/formative.Modelfile << 'EOF'
FROM qwen2.5:7b
PARAMETER temperature 0.1
PARAMETER top_k 10
PARAMETER top_p 0.3
PARAMETER repeat_penalty 1.1
PARAMETER num_ctx 4096
PARAMETER num_thread 16
EOF

docker cp /tmp/formative.Modelfile ollama:/tmp/Modelfile
docker exec ollama ollama create formative-feedback -f /tmp/Modelfile
rm /tmp/formative.Modelfile

echo ""
echo "════════════════════════════════════════════════════"
echo "  ✅ Installation Complete!"
echo "════════════════════════════════════════════════════"
echo ""
echo "📍 Access n8n at: http://localhost:5678"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:5678 in your browser"
echo "2. Create n8n account (first-time setup)"
echo "3. Import workflow: Workflows → Import from File"
echo "4. Select: workflows/essay-feedback.json"
echo ""
echo "📖 Full documentation: README.md"
echo "════════════════════════════════════════════════════"