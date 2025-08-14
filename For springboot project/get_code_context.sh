#!/bin/bash
# This works for Spring Boot projects
# Put this in your root folder of your project
# Simply run: ./get_code_context.sh or bash get_code_context.sh
# The script will auto-set permissions and update the context file

# Auto-set executable permissions for this script
if [ ! -x "$0" ]; then
    chmod +x "$0"
    echo "✓ Script permissions updated"
fi

# Use the current directory as the project directory
project_dir=$(pwd)

# Use a fixed name for the output file in the current directory
output_file="${project_dir}/code_context.txt"

# Check if the output file exists and provide feedback
if [ -f "$output_file" ]; then
    echo "📝 Updating existing code_context.txt..."
    rm "$output_file"
else
    echo "📝 Creating new code_context.txt..."
fi

# List of directories to look for (Spring Boot specific structure)
directories=("src/main/java" "src/main/resources" "src/test/java" "src/test/resources")

# List of file types to ignore
ignore_files=("*.ico" "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.jar" "*.war" "*.class" "*.log" "*.tmp" "*.cache" "*.DS_Store" "*.idea" "*.iml" "*.mvn" "*.gradle" "target" "build" "*.woff" "*.woff2" "*.ttf" "*.eot" "*.pdf" "*.zip" "*.tar" "*.gz")

# Function to check if a file should be ignored
should_ignore_file() {
  local file="$1"
  local filename=$(basename "$file")

  # Check against ignore patterns
  for ignore_pattern in "${ignore_files[@]}"; do
    if [[ "$file" == *"$ignore_pattern"* ]] || [[ "$filename" == $ignore_pattern ]]; then
      return 0  # Should ignore
    fi
  done

  # Ignore specific directories
  if [[ "$file" == *"/target/"* ]] || [[ "$file" == *"/build/"* ]] || [[ "$file" == *"/.idea/"* ]] || [[ "$file" == *"/.gradle/"* ]] || [[ "$file" == *"/.mvn/"* ]]; then
    return 0  # Should ignore
  fi

  # Only include certain file types for Spring Boot
  if [[ "$file" == *.java ]] || [[ "$file" == *.xml ]] || [[ "$file" == *.properties ]] || [[ "$file" == *.yml ]] || [[ "$file" == *.yaml ]] || [[ "$file" == *.sql ]] || [[ "$file" == *.json ]] || [[ "$file" == *.html ]] || [[ "$file" == *.css ]] || [[ "$file" == *.js ]] || [[ "$file" == *.ts ]] || [[ "$file" == *.md ]]; then
    return 1  # Should not ignore
  fi

  return 0  # Ignore by default
}

# Recursive function to read files and append their content
read_files() {
  for entry in "$1"/* ; do
    if [ -d "$entry" ]; then
      # Skip certain directories entirely
      local dirname=$(basename "$entry")
      if [[ "$dirname" == "target" ]] || [[ "$dirname" == "build" ]] || [[ "$dirname" == ".idea" ]] || [[ "$dirname" == ".gradle" ]] || [[ "$dirname" == ".mvn" ]]; then
        continue
      fi
      # If entry is a directory, call this function recursively
      read_files "$entry"
    elif [ -f "$entry" ]; then
      # Check if the file should be ignored
      if ! should_ignore_file "$entry"; then
        relative_path=${entry#"$project_dir/"}
        echo "// File: $relative_path" >> "$output_file"
        cat "$entry" >> "$output_file"
        echo "" >> "$output_file"
      fi
    fi
  done
}

# Add project structure info to the output file
echo "// Spring Boot Project Code Context" >> "$output_file"
echo "// Generated on: $(date)" >> "$output_file"
echo "// Project Directory: $project_dir" >> "$output_file"
echo "" >> "$output_file"

# Include important root files
root_files=("pom.xml" "build.gradle" "build.gradle.kts" "application.properties" "application.yml" "application.yaml" "README.md" "Dockerfile" ".gitignore")
for file in "${root_files[@]}"; do
  if [ -f "${project_dir}/${file}" ]; then
    echo "// File: $file" >> "$output_file"
    cat "${project_dir}/${file}" >> "$output_file"
    echo "" >> "$output_file"
  fi
done

# Call the recursive function for each specified directory in the project directory
for dir in "${directories[@]}"; do
  if [ -d "${project_dir}/${dir}" ]; then
    read_files "${project_dir}/${dir}"
  fi
done

echo "✅ Code context has been generated successfully!"
echo "📁 Output file: $output_file"
echo "📊 Total files processed: $(grep -c "// File:" "$output_file")"
echo "📏 File size: $(du -h "$output_file" | cut -f1)"
echo ""
echo "🔄 To update the context again, simply run: ./get_code_context.sh"
