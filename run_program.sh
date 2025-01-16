#!/bin/bash

# User Input
base_dir="/home/blasteroid03/code/df/sys_data"

source_files=("sk2_hd.png" "ad.png" "sp_hd.png")
target_files=("video/v5.mp4")

# Activate the virtual environment
source env/bin/activate

target_dir="$base_dir/target"
source_dir="$base_dir/source"
output_dir="$base_dir/output"

execution_provider="--execution-provider cuda"

# Function to extract filename without extension
get_filename_without_extension() {
    local filepath=$1
    echo "$(basename "$filepath" | sed 's/\(.*\)\..*/\1/')"
}

get_filename_with_extension() {
    local filepath=$1
    echo "$(basename "$filepath")"
}

params=()  # Initialize the array for parameters
for source_file in "${source_files[@]}"; do
    # Extract target filename without extension
    target_filename=$(get_filename_without_extension "$source_file")
    
    for target_file in "${target_files[@]}"; do
        # Extract source filename with extension
        source_filename=$(get_filename_with_extension "$target_file")
        
        # Construct the output file path
        output_file="$output_dir/${target_filename}_${source_filename}"

        # Construct the parameter set for this pair of files
        params+=(
            "-s $source_dir/$source_file -t $target_dir/$target_file -o $output_file $execution_provider --execution-threads 2"
        )
    done
done

# Loop through each set of parameters and run the program
for param in "${params[@]}"
do
    echo "Running with parameters: $param"
    python run.py $param
    if [ $? -ne 0 ]; then
        echo "Execution failed for parameters: $param"
        exit 1
    fi
done

echo "All runs completed successfully."
