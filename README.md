# bash-rag - Simple Terminal SQLite RAG Implementations
TLDR: 
- run `cd keyword-search && ./setup-and-prompt.sh` to see RAG using only plain SQLite and its text search
- run `cd vector-search && ./setup-and-prompt.sh` to see RAG using SQLite extensions for semantic search

Two lightweight Retrieval-Augmented Generation (RAG) examples using only terminal and SQLite, demonstrating how RAG can be implemented simply and effectively without complex infrastructure.

## Keyword search example
### Features
- Just plain SQLite, no extensions or dependencies.
- Classic text search: Uses SQLite's built-in full-text search with BM25 ranking algorithm.
- Handles typos and partial matches: Uses SQLite's built-in `trigram` tokenizer.
- Source documents aren't stored in the database, only the index, making it space efficient.

###  Limitations
- Doesn't use embeddings or semantic search, so searching for "motor vehicle" wouldn't match "car". Relies on keyword search (BM25), though this is sufficient for many use cases.
- It would be useful to add performance comparisons with other RAG methods.

###  Usage
- Run `cd keyword-search && ./example.sh` to run the full, slow example.
- `search.sh` 

## Vector search example
### Features
- Matches similar meanings better than keyword search
- No hosted database: uses embedding and vector search with only a SQLite extension
- Built on well-supported open source projects for long-term viability

### Limitations
- Requires installation of extensions and downloading the embedding model, as these aren't built into SQLite.
- Keyword search may still perform better for certain queries - especially those with few keywords and limited context.
- A hosted database solution would offer easier maintenance and updates.
