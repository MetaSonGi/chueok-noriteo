#!/usr/bin/env bash
# 사용법: ./push.sh <github-아이디> [저장소이름]
set -e
USER="${1:?GitHub 아이디를 넣어주세요}"; REPO="${2:-chueok-noriteo}"
cd "$(dirname "$0")"
git init -q 2>/dev/null || true
git add index.html README.md push.sh
git commit -qm "추억 놀이터: 시대별 놀이 모음" || true
git branch -M main
if command -v gh >/dev/null; then
  gh repo view "$USER/$REPO" >/dev/null 2>&1 || gh repo create "$USER/$REPO" --public --source=. --remote=origin
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER/$REPO.git"
  git push -u origin main
  gh api -X POST "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 && echo "GitHub Pages 켜짐" || true
else
  git remote add origin "https://github.com/$USER/$REPO.git" 2>/dev/null || true
  echo "→ github.com/new 에서 '$REPO' 저장소를 먼저 만든 뒤 Enter"; read -r
  git push -u origin main
fi
echo "완료: https://github.com/$USER/$REPO"
echo "플레이: https://$USER.github.io/$REPO/"
