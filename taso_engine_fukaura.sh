cat > ~/shogi/wrapper/taso_engine_fukaura.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail

# ==========================
# TASO Engine — FUKAURAOU ONLY (32GB SAFE)
# USI wrapper + HumanScore(estimate)
# ==========================

TASO_SHOW="${TASO_SHOW:-1}"
ENGINE_READ_TIMEOUT="${ENGINE_READ_TIMEOUT:-2}"

# ★ここを実際のふかうら王に
FUKA_BIN="${FUKA_BIN:-__PUT_FUKAURAOU_PATH_HERE__}"

say(){ [ "$TASO_SHOW" = "1" ] && echo "info string $*"; }

estimate_hws(){
  awk -v cp="${1:-0}" 'BEGIN{
    x = cp / 450.0
    h = 1.0 / (1.0 + exp(-x))
    if (h<0.01) h=0.01
    if (h>0.99) h=0.99
    printf "%.2f\n", h
  }'
}

if [ ! -x "$FUKA_BIN" ]; then
  echo "id name TASO (fukauraou missing)"
  echo "id author taso"
  echo "usiok"
  exit 0
fi

coproc ENG { "$FUKA_BIN"; }
exec 3>&"${ENG[1]}" 4<"${ENG[0]}"

cleanup(){ echo quit >&3 2>/dev/null || true; }
trap cleanup EXIT INT TERM

CURRENT_POS=""
TURN_SIGN=1   # +1:先手 / -1:後手

while IFS= read -r line; do

  if [[ "$line" == position* ]]; then
    CURRENT_POS="$line"
    # moves数で手番判定
    moves="$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="moves"){print NF-i; exit} print 0}')"
    if (( moves % 2 == 0 )); then TURN_SIGN=1; else TURN_SIGN=-1; fi
    echo "$line" >&3
    continue
  fi

  if [[ "$line" == usi* ]]; then
    echo "$line" >&3
    while IFS= read -r o <&4; do
      echo "$o"
      [[ "$o" == usiok* ]] && break
    done
    continue
  fi

  if [[ "$line" == isready* ]]; then
    echo "$line" >&3
    while IFS= read -r o <&4; do
      [[ "$o" == readyok* ]] && break
    done
    echo readyok
    continue
  fi

  if [[ "$line" == setoption* ]] || [[ "$line" == usinewgame* ]]; then
    echo "$line" >&3
    continue
  fi

  if [[ "$line" == go* ]]; then
    echo "$line" >&3

    best_cp="0"
    bestmove_line="bestmove resign"

    while IFS= read -r o <&4; do
      if [[ "$o" == info* ]]; then
        echo "$o"
        if [[ "$o" == *"score cp"* ]]; then
          cp="$(echo "$o" | sed 's/.*score cp //' | awk '{print $1}')"
          best_cp="$cp"
        fi
        continue
      fi

      if [[ "$o" == bestmove* ]]; then
        bestmove_line="$o"
        break
      fi
    done

    # 手番補正
    adj_cp=$(( best_cp * TURN_SIGN ))
    HWS="$(estimate_hws "$adj_cp")"
    say "🧠 人間勝率: $HWS (cp=$adj_cp)"
    echo "$bestmove_line"
    continue
  fi

  echo "$line" >&3
done
SH

chmod +x ~/shogi/wrapper/taso_engine_fukaura.sh
