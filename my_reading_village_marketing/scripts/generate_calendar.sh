#!/usr/bin/env bash
# Generates all calendar content for Jun–Jul 2026 and organizes by date.
# Run from the my_reading_village_marketing/ directory:
#   bash scripts/generate_calendar.sh
set -e
PYTHON=".venv/bin/python3"
GEN="scripts/generate.py"

mkdir -p output/jun_21 output/jun_22 output/jun_23 output/jun_24 output/jun_25 \
         output/jun_26 output/jun_28 output/jun_30 \
         output/jul_01 output/jul_02 output/jul_03 output/jul_04 output/jul_05 \
         output/jul_06 output/jul_07

echo "=== Jun 21 · Villager Reveal: Cat (bg 1) ==="
$PYTHON $GEN --template villager_reveal_reel --villager cat --lang en --background 1
mv output/villager_reveal_reel_cat_en.mp4 output/jun_21/

echo "=== Jun 22 · Reading Tip: Phone Face-Down (bg 1, tip 14, dog) ==="
$PYTHON $GEN --template reading_tip --lang en --background 1 --tip 14 --villager dog
mv output/reading_tip_en.png output/jun_22/

echo "=== Jun 23 · Gameplay Showcase (bg 2) ==="
$PYTHON $GEN --template gameplay_showcase --lang en --background 2
mv output/gameplay_showcase_en.mp4 output/jun_23/

echo "=== Jun 24 · Countdown: Dog (bg 5) ==="
$PYTHON $GEN --template countdown_story --villager dog --lang en --background 5
mv output/countdown_story_dog_en.mp4 output/jun_24/

echo "=== Jun 25 · Villager Reveal: Dog (bg 3) ==="
$PYTHON $GEN --template villager_reveal_reel --villager dog --lang en --background 3
mv output/villager_reveal_reel_dog_en.mp4 output/jun_25/

echo "=== Jun 26 · Excuses Not to Read (bg 5) ==="
$PYTHON $GEN --template excuses_not_to_read --lang en --background 5
mv output/excuses_not_to_read_en.png output/jun_26/

echo "=== Jun 28 · Feature Highlight: 5 Rarity Tiers (bg 4, fact 1, lion) ==="
$PYTHON $GEN --template feature_highlight --lang en --background 4 --fact 1 --villager lion
mv output/feature_highlight_en_1.png output/jun_28/

echo "=== Jun 30 · Villager Spotlight: Rabbit (bg 5) ==="
$PYTHON $GEN --template villager_spotlight --villager rabbit --lang en --background 5
mv output/villager_spotlight_rabbit_en.png output/jun_30/

echo "=== Jul 01 · Reading Challenge Story (bg 4) ==="
$PYTHON $GEN --template reading_challenge_story --lang en --background 4
mv output/reading_challenge_story_en.mp4 output/jul_01/

echo "=== Jul 02 · Countdown: Rabbit (bg 1) ==="
$PYTHON $GEN --template countdown_story --villager rabbit --lang en --background 1
mv output/countdown_story_rabbit_en.mp4 output/jul_02/

echo "=== Jul 03 · Villager Reveal: Rabbit (bg 6) ==="
$PYTHON $GEN --template villager_reveal_reel --villager rabbit --lang en --background 6
mv output/villager_reveal_reel_rabbit_en.mp4 output/jul_03/

echo "=== Jul 04 · Feature Highlight: Memory (bg 2, fact 3) ==="
$PYTHON $GEN --template feature_highlight --lang en --background 2 --fact 3
mv output/feature_highlight_en_3.png output/jul_04/

echo "=== Jul 05 · What if Reading Was a Game? (bg 3) ==="
$PYTHON $GEN --template what_if_reading --lang en --background 3
mv output/what_if_reading_en.png output/jul_05/

echo "=== Jul 06 · Excuses Not to Read (bg 6) ==="
$PYTHON $GEN --template excuses_not_to_read --lang en --background 6
mv output/excuses_not_to_read_en.png output/jul_06/

echo "=== Jul 07 · Who Should Read More (bg 2) ==="
$PYTHON $GEN --template who_should_read --lang en --background 2
mv output/who_should_read_en.png output/jul_07/

echo ""
echo "Done! All files organized under output/<date>/"
