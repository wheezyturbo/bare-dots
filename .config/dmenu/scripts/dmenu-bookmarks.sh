#!/bin/sh
# ── dmenu-bookmarks: Quick bookmark launcher ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

BOOKMARKS_FILE="$SCRIPT_DIR/bookmarks.txt"

# Create default bookmarks if none exist
if [ ! -f "$BOOKMARKS_FILE" ]; then
    cat > "$BOOKMARKS_FILE" << 'BOOKMARKS'
  GitHub               | https://github.com
  Reddit               | https://reddit.com
  YouTube              | https://youtube.com
  Arch Wiki            | https://wiki.archlinux.org
  Suckless             | https://suckless.org
  Stack Overflow       | https://stackoverflow.com
  HackerNews           | https://news.ycombinator.com
  ChatGPT              | https://chat.openai.com
BOOKMARKS
fi

choice=$(printf "  Add Bookmark\n%s" "$(cat "$BOOKMARKS_FILE")" | dmenu_styled -p "  Bookmarks")
[ -z "$choice" ] && exit 0

case "$choice" in
    *"Add Bookmark"*)
        NAME=$(echo "" | dmenu_styled -p "  Name")
        [ -z "$NAME" ] && exit 0
        URL=$(echo "" | dmenu_styled -p "  URL")
        [ -z "$URL" ] && exit 0
        printf "  %-20s | %s\n" "$NAME" "$URL" >> "$BOOKMARKS_FILE"
        notify "  Bookmarks" "Added: $NAME" ;;
    *)
        URL=$(echo "$choice" | awk -F'|' '{print $2}' | xargs)
        if [ -n "$URL" ]; then
            xdg-open "$URL" 2>/dev/null &
        fi ;;
esac
