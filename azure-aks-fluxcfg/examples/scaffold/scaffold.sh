#!/bin/bash

# Function to create directories and files based on YAML structure
create_structure() {
    local prefix=$1
    local yaml_file=$2
    local org=$3
    local projects=("${!4}")
    local envs=("${!5}")
    local clusters=("${!6}")
    local files=("${!7}")

    # Process the YAML file
    yq eval "$prefix" "$yaml_file" | while IFS= read -r line; do
        if [[ $line == *:* ]]; then
            # This is a directory
            dir=$(echo "$line" | sed 's/://')
            dir=$(eval echo "$dir")  # Expand any variables
            mkdir -p "$dir"
        elif [[ $line == *-* ]]; then
            # This is a file
            file=$(echo "$line" | sed 's/- //')
            file=$(eval echo "$file")  # Expand any variables
            touch "$file"
        fi
    done
}

# Default YAML content
DEFAULT_YAML="
terraform:
  _common:
    modules:
      aks-cluster:
        - main.tf
        - variables.tf
        - outputs.tf
    - providers.tf
    - backend.tf
  $org_$project:
    $env:
      ${cluster}_$i:
        - $file
gitops:
  _common:
    - flux-system.yaml
  $org_$project:
    $env:
      ${cluster}_$i:
        - $file
"

# Main script
echo "AKS GitOps and Terraform Scaffolding Generator"
echo "----------------------------------------------"

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install yq and try again."
    exit 1
fi

# Prompt for organization name
read -p "Enter organization name: " org_name

# Prompt for project names
read -p "Enter project names (space-separated): " -a project_names

# Prompt for environment names
read -p "Enter environment names (space-separated): " -a env_names

# Prompt for cluster names
read -p "Enter cluster names (space-separated): " -a cluster_names

# Prompt for file resources
read -p "Enter file resources (space-separated): " -a file_resources

# Prompt for custom YAML file
read -p "Enter path to custom YAML file (leave blank for default): " custom_yaml_file

# Create a temporary YAML file
temp_yaml=$(mktemp)

# Set YAML content based on user input
if [[ -n "$custom_yaml_file" && -f "$custom_yaml_file" ]]; then
    cp "$custom_yaml_file" "$temp_yaml"
else
    echo "$DEFAULT_YAML" > "$temp_yaml"
fi

# Generate the structure
for project in "${project_names[@]}"; do
    for env in "${env_names[@]}"; do
        for cluster in "${cluster_names[@]}"; do
            for ((i=1; i<=${#clusters[@]}; i++)); do
                for file in "${file_resources[@]}"; do
                    export org="$org_name" project="$project" env="$env" cluster="$cluster" i="$i" file="$file"
                    
                    echo "Creating Terraform structure..."
                    create_structure "terraform" "$temp_yaml" "$org_name" project_names[@] env_names[@] cluster_names[@] file_resources[@]
                    
                    echo "Creating GitOps structure..."
                    create_structure "gitops" "$temp_yaml" "$org_name" project_names[@] env_names[@] cluster_names[@] file_resources[@]
                done
            done
        done
    done
done

# Clean up
rm "$temp_yaml"

echo "Scaffolding creation complete!"