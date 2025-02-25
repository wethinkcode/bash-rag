# Default prompt if none provided
user_prompt="${1:-"ield stud"}"

echo "Unzipping example documents..."
rm -rf exampledocs
unzip -q ../exampledocuments.zip -d exampledocs

./create-index.sh -documents exampledocs

echo "Do example prompt..."
./prompt.sh "$user_prompt"
