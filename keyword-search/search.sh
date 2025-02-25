if [ "$#" -ne 4 ] || [ "$1" != "-prompt" ] || [ "$3" != "-limit" ]; then
    echo "Usage: $0 -prompt <search_prompt> -limit <max_results>"
    exit 1
fi
search_prompt=$(echo "$2" | tr -d '[:punct:]')
max_amount_of_docs_to_return="$4"
rowids_list=$(sqlite3 rag-textsearch.db "SELECT rowid FROM documents WHERE documents MATCH '$search_prompt' ORDER BY rank LIMIT $max_amount_of_docs_to_return;")
rowids_count=$(echo "$rowids_list" | wc -l)
if [ $rowids_count -lt 1 ]; then
    echo "Error: No matching documents found for search prompt: $search_prompt"
    exit 1
fi
rowidsCsv=$(echo "$rowids_list" | tr '\n' ',' | sed 's/,$//')
sqlite3 rag-textsearch.db "SELECT path FROM rowid_to_path WHERE rowid IN ($rowidsCsv);"
