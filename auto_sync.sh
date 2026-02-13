#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

BASE_DIR="/Users/jy/SKN23"

# Find all subdirectories that have a .git folder
for d in "$BASE_DIR"/*/; do
    if [ -d "${d}.git" ]; then
        cd "$d" || continue
        
        # Check if there are any tracking/untracking changes
        if [ -n "$(git status --porcelain)" ]; then
            git add .
            
            # Extract changed file names (up to 3)
            changed_files=$(git diff --cached --name-only | head -n 3 | tr '\n' ',' | sed 's/,$//')
            file_count=$(git diff --cached --name-only | wc -l | tr -d ' ')
            
            if [ "$file_count" -gt 3 ]; then
                commit_msg="Auto sync: Update $changed_files, etc."
            elif [ -n "$changed_files" ]; then
                commit_msg="Auto sync: Update $changed_files"
            else
                commit_msg="Auto sync: Routine update"
            fi
            
            git commit -m "$commit_msg"
            
            # Check if the 'origin' remote exists before pushing
            if git remote | grep -q "^origin$"; then
                git push origin HEAD
            fi
        fi
    fi
done
