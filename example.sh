echo "Unzipping example documents..."
rm -rf exampledocs
unzip -q exampledocuments.zip -d exampledocs

./create-index.sh -documents exampledocs
echo "Searching for documents..."
./search.sh -prompt "ield stud" -limit 10 > temp-matched-documentpaths.txt
echo "Number of matched documents:" $(wc -l < temp-matched-documentpaths.txt)

echo "Read files and append to a single file..."
# ./prompt.sh -query "What is the capital of France?" -documentPaths "exampledocs/france.txt"
