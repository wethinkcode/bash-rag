
if [ "$#" -ne 2 ] || [ "$1" != "-documents" ]; then
    echo "Usage: $0 -documents <documents_directory>"
    exit 1
fi
documents_dir="$2"
total_documents=$(ls -A "$documents_dir"/*.* 2>/dev/null | wc -l)
if [ ! -d "$documents_dir" ] || [ "$total_documents" -eq 0 ]; then
    echo "Error: No documents found in $documents_dir folder. Please add some documents to index to continue."
    exit 1
fi
if ! command -v sqlite3 &> /dev/null; then
    echo "Error: sqlite3 is not installed. Please install sqlite3 to continue."
    exit 1
fi


echo "Creating sqlite text search index database..."
[ -f rag-textsearch.db ] && rm rag-textsearch.db

sqlite3 rag-textsearch.db "
CREATE TABLE rowid_to_path (
    rowid INTEGER PRIMARY KEY,
    path TEXT
);

CREATE VIRTUAL TABLE documents 
    USING fts5(  -- https://www.sqlite.org/fts5.html
        document, -- document text to index
        content='', -- note we can make it smaller by not saving the content https://www.sqlite.org/fts5.html#contentless_tables
        contentless_delete=1,
        tokenize = 'trigram' --to support substring matching in general https://www.sqlite.org/fts5.html#tokenizers
    );
"

echo "Indexing documents..."
count=0
for file in documents/*.txt; do
    # Escape single quotes in content for SQL
    content=$(cat "$file" | sed "s/'/''/g")
    rowid=$(sqlite3 rag-textsearch.db "INSERT INTO rowid_to_path(path) VALUES ('$file') RETURNING rowid;")
    sqlite3 rag-textsearch.db "INSERT INTO documents(rowid, document) VALUES ($rowid, '$content');"
    ((count++))
    if [ $((count % 10)) -eq 0 ]; then
        printf "\rIndexed $count of $total_documents documents"
    fi
done
echo "\nFinished indexing $count documents, you can now prompt"

echo "Checking if search works..."
max_amount_of_docs_to_return=10
rowids=$(sqlite3 rag-textsearch.db "SELECT rowid FROM documents WHERE documents MATCH 'iel tud' ORDER BY rank LIMIT $max_amount_of_docs_to_return;" | tr '\n' ',' | sed 's/,$//')

if [ ! -z "$rowids" ]; then
    echo "Getting document paths..."
    sqlite3 rag-textsearch.db "SELECT path FROM rowid_to_path WHERE rowid IN ($rowids);"
fi