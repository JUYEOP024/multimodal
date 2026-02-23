#!/bin/bash
cd /Users/jy/SKN23/multimodal || exit

# 변경사항이 있는지 확인 (tracked, untracked 모두 포함)
if [ -n "$(git status --porcelain)" ]; then
    git add .
    
    # 변경된 파일 목록 추출 (최대 3개까지만 표기, 그 이상은 etc 처리)
    changed_files=$(git diff --cached --name-only | head -n 3 | tr '\n' ', ' | sed 's/, $//')
    file_count=$(git diff --cached --name-only | wc -l | tr -d ' ')
    
    if [ "$file_count" -gt 3 ]; then
        commit_msg="Auto sync: Update $changed_files, etc."
    else
        commit_msg="Auto sync: Update $changed_files"
    fi
    
    git commit -m "$commit_msg"
    git push origin main
fi
