#!/bin/bash
# A script to generate a single code context file for Node.js, Express, and MongoDB projects
# It includes a directory tree and the contents of relevant files.
#
# Put this in the root folder of your Node.js project and run:
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
ignore_dirs=(".git" ".idea" ".vscode" "node_modules" "build" "dist" "coverage" ".nyc_output" "tmp" "temp" "logs" "uploads" "public/uploads" "storybook-static" ".storybook" "cypress/videos" "cypress/screenshots" ".cache" ".parcel-cache" ".turbo" ".swc")

# List of directories to look for (Node.js/Express/MongoDB specific structure)
directories=("src" "routes" "controllers" "models" "utils" "config" "middleware" "views" "services" "helpers" "db" "database" "schemas" "validators" "auth" "lib" "libs" "tests" "test" "__tests__" "spec")

# File patterns to ignore.
ignore_files=("*.ico" "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.woff" "*.woff2" "*.ttf" "*.eot" "*.pdf" "*.zip" "*.tar" "*.gz" "*.log" "*.tmp" "*.cache" "*.DS_Store" "*.map" "*.min.js" "*.min.css" "code_context.txt" "*.lock" "yarn.lock" "package-lock.json" "*.tsbuildinfo" "pnpm-lock.yaml" "bun.lockb" "*.pid" "*.seed" "*.cover")

# --- Functions ---

# Function to generate directory tree structure using bash (fallback when tree command is not available)
generate_tree_structure() {
  local dir="$1"
  local prefix="$2"
  local is_last="$3"

  local dirname=$(basename "$dir")

  # Check if this directory should be ignored
  for ignored_dir in "${ignore_dirs[@]}"; do
    if [[ "$dirname" == "$ignored_dir" ]]; then
      return # Skip this directory
    fi
  done

  # Print current directory
  if [[ "$dir" != "$project_dir" ]]; then
    if [[ "$is_last" == "true" ]]; then
      echo "${prefix}└── ${dirname}/" >> "$output_file"
      local new_prefix="${prefix}    "
    else
      echo "${prefix}├── ${dirname}/" >> "$output_file"
      local new_prefix="${prefix}│   "
    fi
  else
    echo "." >> "$output_file"
    local new_prefix=""
  fi

  # Get all entries in the directory
  local entries=()
  if [[ -d "$dir" ]]; then
    for entry in "$dir"/*; do
      [ -e "$entry" ] || continue
      entries+=("$entry")
    done
  fi

  # Sort entries - directories first, then files
  local dirs=()
  local files=()
  for entry in "${entries[@]}"; do
    local basename_entry=$(basename "$entry")
    local should_skip=false

    # Check if this entry should be ignored
    if [[ -d "$entry" ]]; then
      for ignored_dir in "${ignore_dirs[@]}"; do
        if [[ "$basename_entry" == "$ignored_dir" ]]; then
          should_skip=true
          break
        fi
      done
      if [[ "$should_skip" == "false" ]]; then
        dirs+=("$entry")
      fi
    else
      for pattern in "${ignore_files[@]}"; do
        if [[ "$basename_entry" == $pattern ]]; then
          should_skip=true
          break
        fi
      done
      if [[ "$should_skip" == "false" ]]; then
        files+=("$entry")
      fi
    fi
  done

  # Combine and process directories first, then files
  local all_entries=("${dirs[@]}" "${files[@]}")
  local total_entries=${#all_entries[@]}

  for i in "${!all_entries[@]}"; do
    local entry="${all_entries[$i]}"
    local is_last_entry="false"

    if [[ $((i + 1)) -eq $total_entries ]]; then
      is_last_entry="true"
    fi

    if [[ -d "$entry" ]]; then
      generate_tree_structure "$entry" "$new_prefix" "$is_last_entry"
    else
      local filename=$(basename "$entry")
      if [[ "$is_last_entry" == "true" ]]; then
        echo "${new_prefix}└── ${filename}" >> "$output_file"
      else
        echo "${new_prefix}├── ${filename}" >> "$output_file"
      fi
    fi
  done
}

# Recursive function to read files and append their content
read_files() {
  for entry in "$1"/* ; do
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
      # If entry is a directory, call this function recursively
      read_files "$entry"
    elif [ -f "$entry" ]; then
      # Check if the file type should be ignored
      should_ignore=false
      local filename=$(basename "$entry")
      for ignore_pattern in "${ignore_files[@]}"; do
        if [[ "$filename" == $ignore_pattern ]]; then
          should_ignore=true
          break
        fi
      done
      # If the file type should not be ignored, append its relative path and content to the output file
      if ! $should_ignore; then
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
echo "// Node.js Express MongoDB Project Code Context" >> "$output_file"
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
    echo "// 'tree' command not found. Generating directory structure using bash..." >> "$output_file"
    generate_tree_structure "$project_dir" "" "true"
fi
echo "" >> "$output_file"
echo "// --- End of Directory Structure ---" >> "$output_file"
echo "" >> "$output_file"

# Include important root files
echo "// --- Root Configuration Files ---" >> "$output_file"
root_files=("package.json" "server.js" "app.js" "index.js" "main.js" ".env" ".env.local" ".env.example" ".env.development" ".env.production" "nodemon.json" "tsconfig.json" "jsconfig.json" ".eslintrc.js" ".eslintrc.json" ".prettierrc" ".prettierrc.js" ".prettierrc.json" "README.md" "Dockerfile" "docker-compose.yml" ".gitignore" ".dockerignore" "ecosystem.config.js" "pm2.config.js" "jest.config.js" "babel.config.js" ".babelrc" "webpack.config.js")
for file in "${root_files[@]}"; do
  if [ -f "${project_dir}/${file}" ]; then
    echo "// File: $file" >> "$output_file"
    cat "${project_dir}/${file}" >> "$output_file"
    echo "" >> "$output_file"
  fi
done
echo "// --- End of Root Files ---" >> "$output_file"
echo "" >> "$output_file"

# 3. Start the recursive file processing from specified directories.
echo "// --- Project Files Content ---" >> "$output_file"
for dir in "${directories[@]}"; do
  if [ -d "${project_dir}/${dir}" ]; then
    read_files "${project_dir}/${dir}"
  fi
done

# 4. Print a summary to the console.
echo "✅ Node.js Express MongoDB code context has been generated successfully!"
echo "📁 Output file: $output_file"
echo "📊 Total files processed: $(grep -c "// File:" "$output_file")"
echo "📏 File size: $(du -h "$output_file" | cut -f1)"
echo ""
echo "🔄 To update the context again, simply run: ./code_context.sh"
