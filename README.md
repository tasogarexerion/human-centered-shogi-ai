# Human-Centered Shogi AI

**Human-centered shogi AI wrapper for amateur players**

⚠️ **This is a research prototype (work in progress).**

---

## Overview

This repository contains an experimental shogi AI system designed to make
**strong existing shogi engines usable for amateur players**.

Instead of improving engine strength itself, this project focuses on:

- Translating strong AI decisions into **human-executable strategies**
- Reducing typical human errors around winning and losing positions
- Supporting *how humans actually play*, not how AIs play

The system acts as a **wrapper layer** on top of existing engines such as
dlshogi and YaneuraOu.

---

## Core Concept

> **Do not make AI stronger.  
> Make strong AI usable by humans.**

Modern shogi engines already surpass human performance.
However, many amateur players struggle because:

- Best moves are hard to understand or reproduce
- Winning positions collapse due to a single mistake
- Defensive or comeback strategies are unclear

This project introduces a lightweight decision-support layer called
**HumanScore AI**, which estimates:

> *How likely a human player can continue playing accurately
> in the current position.*

Based on this estimate, the AI adapts its behavior and explanations.

---

## Key Features

### 🧠 HumanScore AI
- Estimates *human playability*, not position strength
- Outputs a value between `0.0 – 1.0`
- Used only to **guide decision selection**, not search itself

### 🛡 / ⚖ / 🔥 Strategy Modes
The system explicitly shows the current strategic intent:

- 🛡 **Defend to win** – stable winning positions
- ⚖ **Balance** – unclear or transitional positions
- 🔥 **Attack to win** – unstable or no-safe-defense positions

### 🏖 Bunker (Cliff) Position Detection
Detects positions where:
- Evaluation looks good
- One wrong move causes collapse

These are highlighted as **high-risk human error zones**.

### ☠️ Comeback & Sudden Death Modes
When losing:
- Prioritizes positions where the opponent is likely to fail
- Allows controlled deviation from strict best-move play
- Focuses on *practical* rather than theoretical survival

### 🔄 Automatic Self-Play & Learning
- Self-play detects human-error-prone positions
- Generates lightweight training data automatically
- Updates HumanScore AI without retraining engines

---

## What This Project Is NOT

- ❌ Not an AI-vs-AI competition engine
- ❌ Not designed for Denryusen or Elo benchmarking
- ❌ Not a replacement for existing shogi engines

This project intentionally sacrifices theoretical optimality
for **practical human usability**.

---

## Target Users

- Amateur shogi players (around 1-dan level)
- Developers interested in human-centered AI design
- Researchers exploring explainable or assistive AI systems

---

## Repository Structure
├── 本体/              # Core engine wrapper
├── 自動対局/          # Self-play and data generation
├── 頓死筋モード/      # Sudden-death / comeback logic
└── README.md
Each directory is designed to be readable and modifiable independently.

---

## Usage (Conceptual)

This system works as a **USI-compatible wrapper**.

Typical flow:

1. Existing engine performs normal search
2. Lightweight preflight analysis extracts key indicators
3. HumanScore AI estimates human playability
4. Strategy mode is selected and displayed
5. Final move is chosen from acceptable candidates

Detailed setup instructions will be added incrementally.

---

## Article (Design Explanation)

Design philosophy and detailed explanation (Japanese):

👉 https://note.com/（ここにあなたの記事URL）

The article is written in a *paper-style technical essay format*.

---

## Status

- Experimental / research prototype
- Actively evolving
- Interfaces and parameters may change

Feedback and discussion are welcome.

---

## License

Copyright (c) 2025 tasogarexerion

This code is released **free of charge for research and educational use**.  
Commercial use requires permission from the author.

---

## Closing Note

This project explores a simple idea:

> **AI should not only be strong.  
> AI should be usable by humans.**

If this repository helps stimulate discussion about
human-centered AI design, it has already succeeded.
