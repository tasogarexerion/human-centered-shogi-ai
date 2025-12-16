#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
TASO Local LLM Helper
- stdin から JSON を受け取る
- フェーズ別ルールでプロンプト生成
- llama.cpp (llama-cli) を呼び出す
- 出力は最大3行
"""

import json
import os
import subprocess
import sys
import textwrap

# =============================
# 環境変数
# =============================
LLM_CLI = os.environ.get("TASO_LLM_CLI", "llama-cli")
LLM_MODEL = os.environ.get("TASO_LLM_MODEL")  # 必須
TIMEOUT = float(os.environ.get("TASO_LLM_TIMEOUT_SEC", "0.8"))
MAX_TOKENS = int(os.environ.get("TASO_LLM_MAX_TOKENS", "96"))
TEMPERATURE = float(os.environ.get("TASO_LLM_TEMPERATURE", "0.2"))

if not LLM_MODEL:
    print("ERROR: TASO_LLM_MODEL is not set", file=sys.stderr)
    sys.exit(1)

# =============================
# 日本語プロンプト（固定）
# =============================
PROMPT_BASE = """
あなたは将棋AI「TASO」の解説補助です。
役割は【局面の翻訳】のみです。

共通ルール：
- 出力は最大3行
- 断定しすぎない
- 感情表現は禁止
- 指示・命令は禁止
- 「〜すると良い」ではなく「〜が示唆される」と表現する
"""

PHASE_RULES = {
    "OPENING": """
フェーズ：序盤
- 助言は禁止
- 状況の変化のみを1行で述べる
""",
    "MIDGAME": """
フェーズ：中盤
- 危険・優先・禁止を述べる
- 最大3行
""",
    "ENDGAME": """
フェーズ：終盤
- 警告のみ
- 原則1〜2行
"""
}

# =============================
# JSON受信
# =============================
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

phase = data.get("phase", "MIDGAME").upper()
event = data.get("event", "")

rule = PHASE_RULES.get(phase, PHASE_RULES["MIDGAME"])

# =============================
# 最終プロンプト生成
# =============================
prompt = textwrap.dedent(f"""
{PROMPT_BASE}

{rule}

現在の局面データ（JSON）：
{json.dumps(data, ensure_ascii=False, indent=2)}

出力：
""").strip()

# =============================
# llama.cpp 呼び出し
# =============================
cmd = [
    LLM_CLI,
    "-m", LLM_MODEL,
    "--temp", str(TEMPERATURE),
    "--n-predict", str(MAX_TOKENS),
    "--no-display-prompt"
]

try:
    proc = subprocess.run(
        cmd,
        input=prompt,
        text=True,
        capture_output=True,
        timeout=TIMEOUT
    )
except subprocess.TimeoutExpired:
    sys.exit(0)

out = proc.stdout.strip()
if not out:
    sys.exit(0)

# =============================
# 出力整形（3行制限）
# =============================
lines = [l.strip() for l in out.splitlines() if l.strip()]
lines = lines[:3]

for l in lines:
    print(l)
