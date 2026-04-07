## Technical Setup  &amp;  Customization Guide

This guide covers the advanced configuration of the Formative Feedback System, including custom model creation and n8n volume mapping.

## 1. Custom AI Model Setup (Ollama)

To ensure consistent, rubric-aligned feedback, we use a custom Ollama model defined in configs/formative-model.Modelfile . This model is based on qwen2.5:7b but is tuned for educational contexts.

## Creating the Model

Run the following command from the root of the repository:

ollama create formative-feedback -f configs/formative-model.Modelfile

## Why use this custom model?

- Low Temperature (0.1): Reduces "hallucinations" and ensures the AI sticks strictly to your rubric.
- System Prompt: Hardcodes the "Educational Assistant" persona so you don't have to repeat instructions in every n8n node.
- JSON Formatting: Pre-configures the model to output structured data that n8n can parse reliably.

## 2. Directory Structure  &amp;  Permissions

The INSTALL.sh script sets up the following structure. If you are configuring manually, ensure the data/ folder has write permissions for the Docker user (UID 1000).

- /data : Place your crm\_submissions.xlsx here. n8n will write .txt feedback files here.
- /workflows : Contains the .json files for import.
- /configs : Contains the Ollama Modelfile.

## 3. Customizing the Rubric

To change the grading criteria:

1.  Open the AI Agent node in n8n.
2. Update the "System Message" or the prompt text to reflect your specific assignment requirements.
3. If you change the number of questions, update the Parse Response (Code Node) to calculate the new total score.

## 4. Troubleshooting

## n8n cannot find the Excel file

Ensure the file is named exactly crm\_submissions.xlsx and is located in the data/ folder. Check that your Docker Compose file correctly maps ./data:/data .

## AI is too slow

If feedback takes longer than 60 seconds, consider:

- Reducing the num\_thread parameter in the Modelfile.
- Using a smaller base model (e.g., phi3 or mistral ).
- Enabling GPU acceleration in Docker.
