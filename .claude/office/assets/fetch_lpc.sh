#!/bin/bash
# Downloads the LPC/OpenGameArt asset packs used by build_assets2.py into office/assets/lpc/.
# See CREDITS.md for licenses and attribution. Run from office/assets/.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p lpc/tiles lpc/chars

cd lpc/tiles
for u in lpc-walls.zip lpc-floors.zip lpc_-_the_office.zip; do
  [ -f "$u" ] || curl -fsSL -o "$u" "https://opengameart.org/sites/default/files/$u"
done
[ -f furniture-dark-wood.png ] || curl -fsSL -o furniture-dark-wood.png https://opengameart.org/sites/default/files/dark-wood_4.png
[ -f office-appliances.png ]   || curl -fsSL -o office-appliances.png https://opengameart.org/sites/default/files/office-tilemap_0.png
[ -d walls ]  || unzip -q lpc-walls.zip -d walls
[ -d floors ] || unzip -q lpc-floors.zip -d floors
[ -d office ] || unzip -q lpc_-_the_office.zip -d office

cd ../chars
B=https://raw.githubusercontent.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator/master/spritesheets
for p in body/bodies/male body/bodies/female head/heads/human/male head/heads/human/female \
  torso/clothes/longsleeve/longsleeve/male torso/clothes/longsleeve/longsleeve/female \
  legs/pants/male legs/pants/thin feet/shoes/basic/male feet/shoes/basic/thin \
  hair/bob/adult hair/buzzcut/adult hair/curly_short/adult hair/afro/adult \
  hair/balding/adult hair/pixie/adult hair/long/adult; do
  n=$(echo "$p" | tr / _)
  for a in walk sit; do
    [ -f "${n}__${a}.png" ] || curl -fsSL -o "${n}__${a}.png" "$B/$p/$a.png"
  done
done
echo "LPC assets ready."
