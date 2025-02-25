
user_prompt="${1:-"study"}"
./search.sh -prompt "$user_prompt" -limit 10 > temp-matched-documentpaths.txt
echo "Number of matched documents:" $(wc -l < temp-matched-documentpaths.txt)

echo "Read files and append to a single file..."
prompt_with_rag=$(../build-prompt.sh -prompt "$user_prompt" -rag_paths "temp-matched-documentpaths.txt")
echo "Prompt with RAG:"
echo "$prompt_with_rag"

echo "\n\nRunning the model..."
if ! command -v ollama &> /dev/null; then
    echo "Error: ollama is not installed. Please install ollama to continue."
    exit 1
fi
ollama run deepseek-r1:1.5b "$prompt_with_rag"
