#!/bin/bash
# A script to generate a single code context file for a project.
# It includes a directory tree and the contents of relevant files.
#
# Put this in the root folder of your project and run:
# ./code_context.sh
# With file tree structure

# Auto-set executable permissions for this script
if [ ! -x "$0" ]; then
    chmod +x "$0"
    echo "✓ Script permissions updated."
fi

# Use the current directory as the project directory
project_dir=$(pwd)
output_file="${project_dir}/code_context.txt"

# Check if the output file exists and provide feedback
if [ -f "$output_file" ]; then
    echo "📝 Updating existing code_context.txt..."
    # Clear the existing file
    > "$output_file"
else
    echo "📝 Creating new code_context.txt..."
fi

# --- Configuration ---

# Directories to completely ignore.
ignore_dirs=(".git" ".idea" ".vscode" ".mvn" ".gradle" "target" "build" "node_modules" "dist" "out" "bin")

# File patterns to ignore.
ignore_files=("*.ico" "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.jar" "*.war" "*.class" "*.log" "*.tmp" "*.cache" "*.DS_Store" "*.iml" "*.woff" "*.woff2" "*.ttf" "*.eot" "*.pdf" "*.zip" "*.tar" "*.gz" "code_context.txt")

# File patterns to INCLUDE. Only files matching these patterns will be added.
include_files=("*.java" "*.kt" "*.scala" "*.groovy" "*.xml" "*.properties" "*.yml" "*.yaml" "*.sql" "*.json" "*.html" "*.css" "*.js" "*.ts" "*.tsx" "*.md" "pom.xml" "build.gradle" "build.gradle.kts" "Dockerfile" ".gitignore" "README.md")


# --- Functions ---

# Function to check if a file should be included in the context.
# Returns 0 (true) if the file should be included, 1 (false) otherwise.
should_include_file() {
  local file="$1"
  local filename=$(basename "$file")

  # 1. Check against file ignore patterns. If it matches, ignore it.
  for pattern in "${ignore_files[@]}"; do
    if [[ "$filename" == $pattern ]]; then
      return 1 # False: Should not be included.
    fi
  done

  # 2. Check if the file matches any of the include patterns.
  for pattern in "${include_files[@]}"; do
    if [[ "$filename" == $pattern ]]; then
      return 0 # True: Should be included.
    fi
  done

  # 3. If it's not explicitly included, ignore it.
  return 1 # False: Should not be included.
}

# Recursive function to read files and append their content to the output file.
read_and_process_files() {
  # We process all entries in the given directory ($1).
  for entry in "$1"/*; do
    # Ignore non-existent entries that can result from empty directories
    [ -e "$entry" ] || continue

    local dirname=$(basename "$entry")

    # Check if the current entry is a directory that should be ignored.
    local should_skip_dir=false
    if [ -d "$entry" ]; then
        for ignored_dir in "${ignore_dirs[@]}"; do
            if [[ "$dirname" == "$ignored_dir" ]]; then
                should_skip_dir=true
                break
            fi
        done
    fi

    if $should_skip_dir; then
        continue # Skip this directory entirely.
    fi

    if [ -d "$entry" ]; then
      # If it's a directory we don't ignore, recurse into it.
      read_and_process_files "$entry"
    elif [ -f "$entry" ]; then
      # If it's a file, check if it should be included.
      if should_include_file "$entry"; then
        relative_path=${entry#"$project_dir/"}
        echo "// File: $relative_path" >> "$output_file"
        cat "$entry" >> "$output_file"
        echo "" >> "$output_file"
      fi
    fi
  done
}


# --- Main Execution ---

# 1. Add a header to the output file.
echo "// Project Code Context" >> "$output_file"
echo "// Generated on: $(date)" >> "$output_file"
echo "// Project Directory: $project_dir" >> "$output_file"
echo "" >> "$output_file"

# 2. Add the project directory tree structure.
echo "// --- Project Directory Structure ---" >> "$output_file"
if command -v tree &> /dev/null
then
    # Combine all ignore patterns for the tree command.
    all_ignore_patterns=("${ignore_dirs[@]}" "${ignore_files[@]}")
    ignore_arg=""
    for pattern in "${all_ignore_patterns[@]}"; do
        # The tree command's -I pattern needs to be quoted.
        ignore_arg+=" -I '$pattern'"
    done

    # Use eval to correctly process the quoted ignore patterns.
    # Pipe the output through sed to replace non-breaking spaces (\xc2\xa0) with regular spaces.
    eval "tree -aF --dirsfirst ${ignore_arg}" | sed 's/\xc2\xa0/ /g' >> "$output_file"
else
    echo "// 'tree' command not found. Skipping directory structure." >> "$output_file"
    echo "// Install 'tree' on your OS to include the directory structure." >> "$output_file"
fi
echo "" >> "$output_file"
echo "// --- End of Directory Structure ---" >> "$output_file"
echo "" >> "$output_file"

# 3. Start the recursive file processing from the project root.
echo "// --- Project Files Content ---" >> "$output_file"
read_and_process_files "$project_dir"

# 4. Print a summary to the console.
echo "✅ Code context has been generated successfully!"
echo "📁 Output file: $output_file"
echo "📊 Total files processed: $(grep -c "// File:" "$output_file")"
echo "📏 File size: $(du -h "$output_file" | cut -f1)"
echo ""
echo "🔄 To update the context again, simply run: ./get_code_context.sh"

