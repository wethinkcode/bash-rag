#!/bin/bash

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -prompt)
            prompt="$2"
            shift 2
            ;;
        -rag_paths)
            rag_paths="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

if [ -z "$prompt" ] || [ -z "$rag_paths" ]; then
    echo "Usage: ./prompt.sh -prompt <search_prompt> -rag_paths <path_to_file_containing_document_paths>"
    exit 1
fi

if [ ! -f "$rag_paths" ]; then
    echo "Error: File $rag_paths not found"
    exit 1
fi

document_contents="Background information:\n"

while IFS= read -r file_path; do
    if [ -f "$file_path" ]; then
        document_contents+="\n\"\"\"\n"
        document_contents+="$(cat "$file_path")"
        document_contents+="\n\"\"\"\n"
    else
        echo "Warning: File $file_path not found"
    fi
done < "$rag_paths"

# Build the final prompt
final_prompt="${document_contents}\nUser query: \"\"\"\n${prompt}\n\"\"\"\n"

# Output the final prompt
echo -e "$final_prompt"
