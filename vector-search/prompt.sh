#!/bin/bash
# Default prompt if none provided
user_prompt="${1:-"social science"}"

# Perform vector search
echo "Performing vector search to match documents..."
matched_paths=$(./search.sh -prompt "$user_prompt" -limit 4)
echo "$matched_paths" > temp-matched-documentpaths.txt
echo "Number of matched documents:" $(wc -l < temp-matched-documentpaths.txt)

# Build RAG prompt
echo "Building prompt with retrieved documents..."
prompt_with_rag=$(../build-prompt.sh -prompt "$user_prompt" -rag_paths "temp-matched-documentpaths.txt")
echo "Prompt with RAG:"
echo "$prompt_with_rag"

# Run inference
echo -e "\nRunning the model..."
if ! command -v ollama &> /dev/null; then
    echo "Error: ollama is not installed. Please install ollama to continue."
    exit 1
fi
ollama run deepseek-r1:1.5b "$prompt_with_rag"