# bash-rag-sqlite - Simple Terminal SQLite RAG Implementation
TLDR run `./example.sh` to see a RAG prompt in action.

A lightweight Retrieval-Augmented Generation (RAG) example using only terminal and plain sqlite text search, to show how RAG can be implemented simply and effectively.

## Features
- Classic text search: Uses SQLite's built-in full-text search with BM25 ranking algorithm.
- Handles typos and partial matches: Uses SQLite's built-in `trigram tokenizer.
- Source documents aren't stored in the database, only the index, so quite space efficient.

## Limitations
- Doesn't use embeddings or symantic search, so searching for "motorvehicle" wouldn't match "car". Just uses plain old keyword search (BM25), but this might be good enough for most cases.
- It would be useful to add some performance comparisons with other RAG methods.

## Usage
### First create the index
```create-index.sh -documents "documents"``` creates a sqlite text search index for the text files in the documents folder. 

### Then create & run prompt
#### Step 1: Seach for documents that match the user prompt
```search.sh -prompt "myprompt" -limit "10" > temp-matched-documentpaths.txt``` returns the top 10 ranked document paths from the text search

#### Step 2: Prepend the matching documents to the user prompt
```prompt_with_rag=$(./build-prompt.sh -prompt "$user_prompt" -rag_paths "temp-matched-documentpaths.txt")``` reads the documents at these paths, and injects them into the prompt before your prompt to an LLM.

#### Step 3: Run prompt on the model
```ollama run deepseek-r1:1.5b "$prompt_with_rag"``` runs the model with the prompt
