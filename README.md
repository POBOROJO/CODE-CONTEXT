# 📁 Code Context Generator

A collection of bash scripts to generate comprehensive code context files for different project types. These scripts help you create a single file containing your entire project structure and source code - perfect for sharing with AI assistants, code reviews, or project documentation.

## 🚀 What Does This Do?

These scripts will:
- 📊 Generate a visual directory tree of your project
- 📝 Include all relevant source code files in one organized file
- 🚫 Automatically exclude unnecessary files (node_modules, build folders, images, etc.)
- 📋 Add helpful headers and file organization
- 🔄 Allow easy regeneration when your code changes

## 📂 Available Scripts

```
├── For nextjs based projects/
│   ├── code_context.sh          (✨ With directory tree)
│   └── get_code_context.sh      (📄 Simple version)
├── For nextjs based with src folder/
│   ├── code_context.sh          (✨ With directory tree)
│   └── get_code_context.sh      (📄 Simple version)
├── For nodejs, express, mongodb/
│   ├── code_context.sh          (✨ With directory tree)
│   └── get_code_context.sh      (📄 Simple version)
├── For React file/
│   ├── code_context.sh          (✨ With directory tree)
│   └── get_code_context.sh      (📄 Simple version)
├── For springboot project/
│   ├── code_context.sh          (✨ With directory tree)
│   └── get_code_context.sh      (📄 Simple version)
└── README.md
```

## 🎯 Choose Your Script

### 🌟 **Recommended: `code_context.sh`** (Advanced Version)
- ✅ Includes beautiful directory tree visualization
- ✅ Shows project structure at the top
- ✅ More comprehensive file filtering
- ✅ Professional output format
- ✅ Works without installing additional tools

### 📝 **`get_code_context.sh`** (Simple Version)
- ✅ Lightweight and fast
- ✅ Basic functionality
- ✅ Good for quick context generation
- ❌ No directory tree visualization

## 🛠️ How to Use

### Step 1: Choose Your Project Type
Pick the folder that matches your project:
- **Next.js projects** → `For nextjs based projects/`
- **Next.js with src/ folder** → `For nextjs based with src folder/`
- **Node.js/Express/MongoDB** → `For nodejs, express, mongodb/`
- **React projects** → `For React file/`
- **Spring Boot projects** → `For springboot project/`

### Step 2: Copy the Script
1. Navigate to your project's **root directory** (where package.json or pom.xml is located)
2. Copy either `code_context.sh` (recommended) or `get_code_context.sh` to your project root
3. Rename it to `get_code_context.sh` if needed

### Step 3: Run the Script

#### 🆕 First Time Setup (Required Once)
For the very first time, you need to make the script executable:

```bash
# Make the script executable (only needed once)
chmod +x get_code_context.sh
./get_code_context.sh
```

OR if you chose the advanced version:

```bash
# Make the script executable (only needed once)
chmod +x code_context.sh
./code_context.sh
```

#### 🔄 Every Time After (Simple Updates)
Once you've done the first-time setup, updating your context is super easy:

```bash
# Just run this to update your context file
./get_code_context.sh
```

OR:

```bash
# For the advanced version
./code_context.sh
```

**That's it!** The script will automatically:
- ✅ Update your existing `code_context.txt` file
- ✅ Include any new files you've added
- ✅ Remove content from deleted files
- ✅ Show you a summary of what was processed

### Step 4: Use Your Context File
- ✅ Find the generated `code_context.txt` in your project root
- ✅ Share it with AI assistants, team members, or use for documentation
- ✅ Re-run the script anytime your code changes

## 📋 What Gets Included

### ✅ Included Files:
- Source code files (`.js`, `.jsx`, `.ts`, `.tsx`, `.java`, etc.)
- Configuration files (`package.json`, `tsconfig.json`, `next.config.js`, etc.)
- Documentation files (`README.md`, etc.)
- Environment files (`.env.example`)
- Style files (`.css`, `.scss`, `.sass`)

### ❌ Excluded Files:
- `node_modules/` directory
- Build folders (`dist/`, `build/`, `target/`, `.next/`)
- Image files (`.png`, `.jpg`, `.svg`, etc.)
- Lock files (`package-lock.json`, `yarn.lock`)
- Log files and cache directories
- IDE configuration folders (`.idea/`, `.vscode/`)

## 🎨 Example Output

```
// Next.js Project Code Context
// Generated on: Fri Aug 15 2024 10:30:00
// Project Directory: /Users/yourname/myproject

// --- Project Directory Structure ---
.
├── src/
│   ├── components/
│   │   ├── Header.tsx
│   │   └── Footer.tsx
│   ├── pages/
│   │   ├── index.tsx
│   │   └── about.tsx
│   └── styles/
│       └── globals.css
├── package.json
├── next.config.js
└── README.md

// --- Root Configuration Files ---
// File: package.json
{
  "name": "my-nextjs-app",
  ...
}

// --- Project Files Content ---
// File: src/components/Header.tsx
import React from 'react';
...
```

## 🔧 Troubleshooting

### Permission Denied Error (First Time Only)
If you get a permission error on your first run:
```bash
chmod +x get_code_context.sh
./get_code_context.sh
```

OR for the advanced version:
```bash
chmod +x code_context.sh
./code_context.sh
```

### Script Not Found
Make sure you're in the project root directory where the script is located:
```bash
ls -la get_code_context.sh  # Should show the file
pwd                          # Should show your project root
```

### No Files Generated
Check that you're using the correct script for your project type and that you have source files in the expected directories.

### Large File Size
The generated file might be large for big projects. This is normal - you can always edit the `code_context.txt` file to remove sections you don't need.

## 🎯 Pro Tips

1. **🆕 First Time Setup**: You only need to run `chmod +x` once - after that, just use `./get_code_context.sh` or `./code_context.sh`
2. **🔄 Quick Updates**: After the initial setup, updating your context is as simple as `./get_code_context.sh`
3. **📝 Selective Sharing**: Edit the generated `code_context.txt` to include only relevant sections when sharing
4. **🤖 AI Assistant Ready**: These files are perfectly formatted for sharing with ChatGPT, Claude, or other AI assistants
5. **📊 Project Documentation**: Use the directory tree section for project documentation
6. **🔍 Code Reviews**: Share the context file for comprehensive code reviews
7. **⚡ Lightning Fast**: Once set up, generating updated context takes just seconds

## 🚀 Advanced Features

- **🔧 Auto-permissions**: Scripts automatically set their own executable permissions
- **📊 Statistics**: Shows file count and size after generation
- **🌳 Tree Visualization**: Beautiful directory structure display (in `code_context.sh` versions)
- **🛡️ Smart Filtering**: Comprehensive ignore patterns for clean output
- **🔄 Easy Updates**: Simple re-run for updated context

## 🤝 Contributing

Found a bug or want to add support for another project type? Feel free to submit issues or pull requests!

## 📄 License

Free to use and modify for any purpose.

---

**Happy Coding! 🎉**

*Generated context files make sharing your project structure and code incredibly easy. Perfect for getting help from AI assistants or llms and collaborating with team members!*
