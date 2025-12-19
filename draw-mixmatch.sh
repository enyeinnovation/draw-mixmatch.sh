#!/bin/bash

TEXT="MIXMATCH"

# LUNES UTC – inicio limpio 2025
START_DATE="2025-01-06T00:00:00Z"

COMMITS_PER_DOT=1
DAY=86400
START_TS=$(date -u -d "$START_DATE" +%s)

declare -A FONT

FONT[M]="1 0 0 0 1
1 1 0 1 1
1 0 1 0 1
1 0 0 0 1
1 0 0 0 1
1 0 0 0 1
1 0 0 0 1"

FONT[I]="1 1 1 1 1
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
1 1 1 1 1"

FONT[X]="1 0 0 0 1
0 1 0 1 0
0 0 1 0 0
0 1 0 1 0
1 0 0 0 1
0 0 0 0 0
0 0 0 0 0"

FONT[A]="0 1 1 1 0
1 0 0 0 1
1 0 0 0 1
1 1 1 1 1
1 0 0 0 1
1 0 0 0 1
1 0 0 0 1"

FONT[T]="1 1 1 1 1
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0
0 0 1 0 0"

FONT[C]="0 1 1 1 1
1 0 0 0 0
1 0 0 0 0
1 0 0 0 0
1 0 0 0 0
1 0 0 0 0
0 1 1 1 1"

FONT[H]="1 0 0 0 1
1 0 0 0 1
1 0 0 0 1
1 1 1 1 1
1 0 0 0 1
1 0 0 0 1
1 0 0 0 1"

commit_at() {
  local ts=$1
  GIT_AUTHOR_DATE="$ts" \
  GIT_COMMITTER_DATE="$ts" \
  git commit --allow-empty -m "draw"
}

week_offset=0

for ((i=0; i<${#TEXT}; i++)); do
  char="${TEXT:$i:1}"
  row=0

  while read -r line; do
    col=0
    for bit in $line; do
      if [[ "$bit" == "1" ]]; then
        ts=$((START_TS + (week_offset + col) * 7 * DAY + row * DAY))
        for ((c=0; c<COMMITS_PER_DOT; c++)); do
          commit_at "$ts"
        done
      fi
      ((col++))
    done
    ((row++))
  done <<< "${FONT[$char]}"

  # espacio exacto entre letras
  week_offset=$((week_offset + 6))
done

echo "OK. Push con:"
echo "git push origin main --force"

