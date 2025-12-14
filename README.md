TASO – Human-Oriented Shogi Engine Wrapper

本リポジトリは将棋AI研究・実験目的のコードです。
dlshogi本体および学習済みモデルは含まれておらず、
各自でライセンスを確認の上、用意してください。

TASO is not a stronger shogi engine.
TASO is an engine that wins the way humans lose.

⸻

Overview

TASO is a wrapper-based shogi AI framework designed to explore
how humans actually lose winning positions.

Instead of always selecting the objectively strongest move,
TASO dynamically chooses between:
	•	Safe conversion (winning without risk)
	•	Pressure play (forcing difficult decisions)
	•	Comeback / sudden-death attempts when losing

The core idea is simple:

In real games, humans do not lose because a position is lost.
They lose because they make mistakes under pressure.

TASO is built to model and exploit that pressure.

⸻

What This Repository Contains

This repository provides only original code written for TASO:
	•	USI-compatible engine wrapper (taso_engine.sh)
	•	Position / dataset generator for “bunker” (cliff-edge) situations
	•	Scripts for self-play and automated data generation
	•	Diagnostic tools (doctor.sh)

What This Repository Does NOT Contain

To avoid license and redistribution issues, this repository does NOT include:
	•	Any shogi engine binaries (e.g. dlshogi, YaneuraOu)
	•	Any neural network model files (e.g. model.onnx)
	•	Any third-party evaluation code

You must obtain and place those components yourself.

⸻

External Dependencies (User-Provided)

TASO expects the following external components to be installed separately:
	•	dlshogi (engine binary)
	•	dlshogi neural network model (model.onnx)
	•	(Optional) YaneuraOu (used for forced mate / endgame conversion)

Each of these components is subject to its own license.
Users are responsible for complying with the respective licenses.

This repository does not redistribute them.

⸻

Design Philosophy

1. Human-Centered Evaluation

TASO introduces a concept called HumanScore,
which estimates how difficult a position is for a human to handle,
even if it is objectively winning or losing.

Examples of factors:
	•	Evaluation spread between best and second-best moves
	•	Low number of safe legal moves
	•	Volatility of evaluation over short sequences
	•	Delayed collapse after an inaccuracy

⸻

2. Bunker (Cliff-Edge) Positions

A bunker position is defined as:

A position that is still objectively playable,
but where one mistake immediately collapses the game.

TASO automatically detects and records such positions
to build training datasets focused on human error patterns,
not perfect play.

⸻

3. Attack / Defense Switching

TASO dynamically switches its behavior based on estimated human difficulty:
	•	“Attack to win” – increase pressure and complexity
	•	“Defend to win” – reduce risk and simplify
	•	Balanced – when neither extreme is optimal

This is not randomness —
it is policy switching based on human vulnerability.

⸻

4. Comeback & Sudden Death Modes

When objectively losing, TASO does not resign immediately.

Instead it may:
	•	Attempt accident-inducing play
	•	Enter Sudden Death mode, deliberately choosing
non-optimal but dangerous variations from multi-PV candidates

This reflects real-world competitive play,
where the goal is not correctness, but survival.

⸻

Dataset Generation

The included dataset generator produces JSON files describing:
	•	Board position (USI startpos moves ...)
	•	Evaluation metrics (normalized to Black’s perspective)
	•	Volatility and pressure indicators
	•	Estimated collapse probability

These datasets are intended for:
	•	Training HumanScore models
	•	Analyzing where humans most frequently fail
	•	Research and experimentation

They are not ground truth labels.

⸻

Reproducibility & Limitations
	•	Evaluation values depend heavily on engine, model, hardware, and time limits
	•	Generated datasets are noisy by design
	•	TASO does not aim for perfect reproducibility across systems

This project prioritizes behavioral realism over theoretical optimality.

⸻

Intended Use

TASO is intended for:
	•	Research into human error in shogi
	•	Experimental AI behavior design
	•	Educational and analytical purposes

It is not intended for:
	•	Competitive rating benchmarks
	•	Claims of engine strength
	•	Cheating in online play

⸻

License

All original code in this repository is released under the MIT License
(unless stated otherwise in individual files).

Third-party engines and models are not covered by this license.

⸻

Disclaimer

This project is an experimental research tool.
	•	No guarantees of strength, correctness, or stability
	•	No liability for misuse
	•	Use at your own risk

⸻

Acknowledgements

This project is inspired by the idea that:

The most interesting mistakes are not made by weak players,
but by strong players under pressure.
