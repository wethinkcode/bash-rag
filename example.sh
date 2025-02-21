echo "Unzipping example documents..."
rm -rf exampledocs
unzip -q exampledocuments.zip -d exampledocs

./create-index.sh -documents exampledocs
echo "Searching for documents..."

user_prompt="ield stud"
./search.sh -prompt "$user_prompt" -limit 10 > temp-matched-documentpaths.txt
echo "Number of matched documents:" $(wc -l < temp-matched-documentpaths.txt)

echo "Read files and append to a single file..."
prompt_with_rag=$(./build-prompt.sh -prompt "$user_prompt" -rag_paths "temp-matched-documentpaths.txt")
echo "Prompt with RAG:"
echo "$prompt_with_rag"

echo "\n\nRunning the model..."
if ! command -v ollama &> /dev/null; then
    echo "Error: ollama is not installed. Please install ollama to continue."
    exit 1
fi
ollama run deepseek-r1:1.5b "$prompt_with_rag"

# R1:1.5B GAVE ME THIS! THE DOCUMENTS HELPED THE SMALL MODEL TO FIGURE IT OUT WHAT I WAS ASKING
# <think>
# Okay, so I need to figure out what "ield stud" means. Let me break it down. The user wrote that as a field study. Hmm, but wait, 
# fields are usually in biology or geography. Maybe there's a translation issue.

# Wait, the original text mentions pharmacology, genetics, environmental science, robotics, nutrition, and other fields. So maybe 
# "ield stud" is a typo for "field of study." That would make more sense because those are all academic fields. 

# So if it's about a field of study in pharmacology, that's where drugs are studied on biological systems. If it's genetics, it's 
# heredity and genes. Environmental science looks at how environment affects living things. Robotics is about machines in various 
# fields. Nutrition studies food and health.

# But the user wrote "ield stud," which might be a mix-up of "field" and "study." So probably meant field of study. If that's the 
# case, I should explain each of these academic areas briefly, highlighting their focus areas.
# </think>

# It seems like you may have entered "ield stud," which is likely a typo or mix-up in wording. The correct term to use is "field of 
# study" (or "field of study"). A field of study refers to an area of knowledge or expertise, such as pharmacology, genetics, 
# environmental science, robotics, nutrition, and others.

# For example:

# - **Pharmacology**: Focuses on the effects of drugs on biological systems.
# - **Genetics**: Studies heredity and variation in inherited characteristics.
# - **Environmental Science**: Examines interactions between the environment and living organisms.
# - **Robotics**: Involves design, construction, and operation of machines or robots across various applications.

# Let me know if you'd like more details on any specific field!