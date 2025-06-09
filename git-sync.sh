#!/usr/bin/env bash
set -e        # Skript bricht bei erstem Fehler ab
set -u        # undeclared variables sind Fehler

BRANCH="godot-init"

# 1. Aktuellen Branch prüfen
current="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current" != "$BRANCH" ]]; then
  echo "Hinweis:  Du bist auf Branch '$current'. Wechsel mit: git checkout $BRANCH"
  exit 1
fi

echo "Hinweis -  Branch: $BRANCH"

# 2. Lokale Änderungen stagen
echo " git add ."
git add .

# 3. Commit nur, wenn wirklich Änderungen vorhanden sind
if ! git diff --cached --quiet; then
  msg=${1:-"Automatischer Commit"}
  echo " git commit -m \"$msg\""
  git commit -m "$msg"
else
  echo " Keine Änderungen zum Commit."
fi

# 4. Remote holen & rebasen
echo " git pull --rebase origin $BRANCH"
git pull --rebase origin "$BRANCH"

# 5. Pushen
echo " git push origin $BRANCH"
git push origin "$BRANCH"

echo " Fertig!"
