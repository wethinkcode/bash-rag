# bash-rag-sqlite-vect - Simple Terminal SQLite RAG Implementation
TLDR run `./example.sh` to see a RAG prompt in action using ve

## Prerequisites
- Install sqlite-vec and sqlite-lembed SQLite extensions
- Install ollama

## Features
- Matches similar meanings better than keyword search
- No hosted database: uses embedding and vector search with only a SQLite extension
- Well supported open source projects, so should be around for a while

## Limitations
- You have to install the extensions, and also download the embedding model. Not baked into SQLite.
- Keyword search is still better for certain use cases - e.g. only a few keywords without much context.
- A hosted database would be easier to keep up to date.
