# bash-rag - Simple Terminal SQLite RAG Implementation
TLDR run `./example.sh` to see a simple rag in action.

A lightweight Retrieval-Augmented Generation (RAG) example using only terminal and plain sqlite text search.

This project demonstrates how RAG can be implemented simply and effectively.

## Features
- Uses SQLite's built-in full-text search with BM25 ranking algorithm
- We don't store the document content in the database, only index and path, so quite space efficient

## Limitations
- Just plain old keyword search (BM25), which should be good enough for most cases. I.e. no embeddings orsymantic search, so searching for "motorvehicle" wouldn't match "car".
- The prompt example uses Ollama to prompt the LLM with the documents, but you can use any LLM API.
- As in other methods, creating the index is slowish, but searching is fast.

## Usage
### Step 1: Create a search index for documents
```create-index.sh -documents "documents"``` creates a sqlite text search index for the text files in the documents folder. 

### Step 2: Seach for doc paths with a prompt
```search.sh -prompt "myprompt" -limit "10"``` returns the top 10 ranked document paths from the text search

### Step 3: Prompt LLM with the documents (example)
```prompt.sh -query "myprompt" -documentPaths "mydocpaths"``` read the documents at these paths, and inject it before your prompt to an LLM.

