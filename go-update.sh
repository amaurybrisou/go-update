#!/bin/bash

# Display help if no argument provided
if [ $# -eq 0 ]
then
  echo "Usage: $0 <filename>"
  echo "Extracts the specified file into ${HOME}/go/goX.XX.X/ and creates a symbolic link to its bin directory."
  exit 1
fi

# Get the file path from the first argument
file_path=$1

# Exit if file_path does not exist
if [ ! -f "$file_path" ]
then
  echo "Error: File not found."
  exit 1
fi

# Extract the version from the filename
version=$(echo $file_path | sed -n 's/.*go\([0-9]\+\.[0-9]\+\.[0-9]\+\)\.linux-amd64\.tar\.gz/\1/p')
if [ -z "$version" ]
then
  echo "Error: Could not extract version from filename."
  echo "Filename must be in the format 'goX.XX.X.linux-amd64.tar.gz'."
  exit 1
fi

# Create the directory for the new version of Go
mkdir -p "${HOME}/go/go${version}"

# Decompress the file into the new directory
tar -xzf "${file_path}" -C "${HOME}/go/go${version}" --strip-components=1

# Remove the symbolic link for the current version of Go
rm "${HOME}/go/current"

# Create a new symbolic link pointing to the new version of Go
ln -s "${HOME}/go/go${version}" "${HOME}/go/current"
