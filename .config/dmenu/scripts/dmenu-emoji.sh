#!/bin/sh
# ── dmenu-emoji: Emoji picker ──
# Copies selected emoji to clipboard

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

EMOJI_FILE="$SCRIPT_DIR/emoji-list.txt"

# Generate emoji file if it doesn't exist
if [ ! -f "$EMOJI_FILE" ]; then
    cat > "$EMOJI_FILE" << 'EMOJIS'
😀 grinning face
😂 face with tears of joy
🥹 face holding back tears
😎 smiling face with sunglasses
🤔 thinking face
😴 sleeping face
🥺 pleading face
😭 loudly crying face
🔥 fire
❤️ red heart
💀 skull
✨ sparkles
🎉 party popper
👍 thumbs up
👎 thumbs down
👋 waving hand
🙏 folded hands
💪 flexed biceps
🧠 brain
👀 eyes
🗿 moai
💻 laptop
🖥️ desktop computer
⌨️ keyboard
🐧 penguin
🦀 crab (rust btw)
🤡 clown
💯 hundred points
⚡ high voltage
🌙 crescent moon
☀️ sun
🌊 wave
🏠 house
📁 folder
📝 memo
🔒 locked
🔓 unlocked
🔑 key
🔍 magnifying glass
📷 camera
🎵 musical note
🎮 video game
🍕 pizza
🍜 steaming bowl
☕ hot beverage
🍺 beer
🚀 rocket
✅ check mark
❌ cross mark
⚠️ warning
💡 light bulb
📌 pushpin
🏷️ label
📊 chart
💬 speech balloon
🔔 bell
🔇 muted speaker
🔊 speaker high volume
📡 satellite antenna
🌐 globe
🔗 link
📎 paperclip
✏️ pencil
🗑️ wastebasket
📦 package
🎯 direct hit
🏆 trophy
🎨 artist palette
🛠️ hammer and wrench
⚙️ gear
🧪 test tube
📐 triangular ruler
🔧 wrench
🐛 bug
🐍 snake (python)
☁️ cloud
🌈 rainbow
🌸 cherry blossom
🍃 leaf
🦊 fox
🐱 cat
🐶 dog
EMOJIS
fi

SELECTED=$(cat "$EMOJI_FILE" | dmenu_styled -p "  Emoji" -l 15)
[ -z "$SELECTED" ] && exit 0

# Extract just the emoji (first character/grapheme)
EMOJI=$(echo "$SELECTED" | cut -d' ' -f1)

# Copy to clipboard
printf "%s" "$EMOJI" | xclip -selection clipboard

notify "  Emoji" "Copied $EMOJI to clipboard"
