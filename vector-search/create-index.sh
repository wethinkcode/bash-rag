#!/bin/bash
if [ "$#" -ne 2 ] || [ "$1" != "-documents" ]; then
    echo "Usage: $0 -documents <documents_directory>"
    exit 1
fi
documents_dir="$2"
total_documents=$(ls -A "$documents_dir"/*.* 2>/dev/null | wc -l)

if [ ! -d "$documents_dir" ] || [ "$total_documents" -eq 0 ]; then
    echo "Error: No documents found in $documents_dir folder. Please add some documents to continue."
    exit 1
fi

if [ ! -f "./vec0.dylib" ] && [ ! -f "./vec0.so" ]; then
    echo "Error: vec0 extension not found. https://alexgarcia.xyz/sqlite-vec/installation.html"
    exit 1
fi

if [ ! -f "./lembed0.dylib" ] && [ ! -f "./lembed0.so" ]; then
    echo "Error: lembed0 extension not found. https://github.com/asg017/sqlite-lembed"
    exit 1
fi

echo "Downloading embedding model..."
curl -L -o all-MiniLM-L6-v2.e4ce9877.q8_0.gguf https://huggingface.co/asg017/sqlite-lembed-model-examples/resolve/main/all-MiniLM-L6-v2/all-MiniLM-L6-v2.e4ce9877.q8_0.gguf
if [ ! -f "all-MiniLM-L6-v2.e4ce9877.q8_0.gguf" ]; then
    echo "Error: Failed to download embedding model. Please check your internet connection and try again."
    exit 1
fi

rm -rf rag-vecsearch.db

echo "Creating vector database..."
sqlite3 rag-vecsearch.db "
select load_extension('./vec0');
select load_extension('./lembed0');
create virtual table vec_documents using vec0(+path TEXT, document_embeddings float[384]);  
" 

echo "Indexing documents..."
for file in exampledocs/*; do
    path="$file"
    text=$(cat "$file")
    sqlite3 rag-vecsearch.db "
        select load_extension('./vec0');
        select load_extension('./lembed0');
        INSERT INTO lembed_models(name, model)
        select 'all-MiniLM-L6-v2', lembed_model_from_file('all-MiniLM-L6-v2.e4ce9877.q8_0.gguf');

        insert into vec_documents(path, document_embeddings)
        select '$path', lembed('all-MiniLM-L6-v2', '$text');
    "
done

echo "Indexing complete!"
