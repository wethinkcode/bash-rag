#!/bin/bash

if [ ! -f "rag-vecsearch.db" ]; then
    echo "Error: Vector database not found. Please run create-index.sh first."
    exit 1
fi

prompt=""
limit=3

if [[ "$1" == "-prompt" && -n "$2" ]]; then
  prompt="$2"
  shift 2
fi

if [[ "$1" == "-limit" && -n "$2" ]]; then
  limit="$2"
fi

if [[ -z "$prompt" ]]; then
  echo "Usage: $0 -prompt <search_prompt> [-limit <result_limit>]"
  exit 1
fi

rm -f matches.txt
sqlite3 rag-vecsearch.db "
select load_extension('./vec0');
select load_extension('./lembed0');
INSERT INTO lembed_models(name, model)
  select 'all-MiniLM-L6-v2', lembed_model_from_file('all-MiniLM-L6-v2.e4ce9877.q8_0.gguf');

with matches as (
  select
    path,
    distance
  from vec_documents
  where document_embeddings match lembed('all-MiniLM-L6-v2', '$prompt')
  order by distance
  limit $limit
)
select path from matches
" > matches.txt

# Remove blank lines from matches.txt
grep -v "^$" matches.txt > matches.tmp && mv matches.tmp matches.txt

cat matches.txt

rm -f matches.tmp
rm -f matches.txt






