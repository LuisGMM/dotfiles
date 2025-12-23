# Whisper‑Dictation (Ubuntu +i3)

Local, offline speech‑to‑text for Linux using [Whisper](https://github.com/openai/whisper) via **faster‑whisper**, with global hotkeys and on‑the‑fly typing through `xdotool`.

---

## ✨ Features

* **Offline** – no cloud API keys.
* **GPU accelerated** (CUDA 11.8+/12.1) or **CPU‑only** fallback.
* **Toggle with one shortcut** – start/stop dictation anywhere.
* Voice Activity Detection (VAD) to cut silences automatically.
* Writes text at the current cursor location (any window).
* Easy to extend with punctuation post‑processing.

---

## 🖥 Prerequisites

| Layer                 | Package(s)                                          | Notes                                              |
| --------------------- | --------------------------------------------------- | -------------------------------------------------- |
| APT (≈ 5 MB)          | `libportaudio2` `xdotool` `ffmpeg`<br>`python3-pip` | PortAudio runtime, keystroke injection, audio I/O. |
| NVIDIA GPU (optional) | Proprietary driver ≥ 545                            | Gives `CUDA Version ≥ 11.8` in `nvidia-smi`.       |
| Python (pip)          | `faster-whisper` `sounddevice` `webrtcvad` `numpy`  | Core dictation stack.                              |
| **GPU build**         | `torch torchvision torchaudio` `+cu121`             | Choose **one** of GPU or CPU wheel.                |
| **CPU build**         | `torch torchvision torchaudio` `+cpu`               | Smaller, slower, works everywhere.                 |
| *(optional)*          | `transformers` `sentencepiece`                      | For punctuation restoration.                       |

> **Tip:** create a virtualenv: `python3 -m venv ~/venvs/whisper && source ~/venvs/whisper/bin/activate`.

---

## 🔧 Installation

```bash
# 1 – System libs
sudo apt update && sudo apt install -y \
    libportaudio2 xdotool ffmpeg python3-pip

# 2 – Python wheels (core)
pip install --upgrade \
    faster-whisper sounddevice webrtcvad numpy

# 3 – PyTorch
#    GPU (driver shows CUDA 12.x → use cu121)
pip install --upgrade torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121
#    ── OR ──  CPU‑only
# pip install --upgrade torch torchvision torchaudio \
#     --index-url https://download.pytorch.org/whl/cpu

# 4 – (Optional) punctuation model
# pip install --upgrade transformers sentencepiece
```

---

## 📄 Script setup

```bash
mkdir -p ~/.local/bin ~/.cache
curl -o ~/.local/bin/whisper-dictation \
     https://raw.githubusercontent.com/yourrepo/whisper-dictation/main/whisper-dictation
chmod +x ~/.local/bin/whisper-dictation
```

*Edit the header variables if you want a different default language (`LANG`), VAD aggressiveness, etc.*

---

## ⌨️ i3 hotkeys

```i3
# Dictation Spanish
bindsym $mod+Ctrl+b exec --no-startup-id ~/.local/bin/whisper-dictation toggle es
# Dictation English
bindsym $mod+Ctrl+v exec --no-startup-id ~/.local/bin/whisper-dictation toggle en
# Force‑stop (fallback)
bindsym $mod+Ctrl+c exec --no-startup-id ~/.local/bin/whisper-dictation stop
```

Reload i3: **Mod + Shift + c**.

---

## 🚀 Usage

```bash
# Start continuous dictation (Spanish)
whisper-dictation start es

# Stop dictation
whisper-dictation stop

# Single hotkey workflow (recommended)
whisper-dictation toggle es   # toggles on / off
```

While running, speak; when you pause ≥ 0.8 s the transcribed text (with punctuation) is typed at the cursor.

---

## 🛠 Troubleshooting

| Symptom                                | Fix                                                                                          |
| -------------------------------------- | -------------------------------------------------------------------------------------------- |
| `OSError: PortAudio library not found` | `sudo apt install libportaudio2`                                                             |
| Hotkey does nothing                    | Ensure path in `bindsym` is correct; reload i3.                                              |
| No punctuation                         | Increase `SEG_MAX_MS`, pass `initial_prompt`, or enable the **transformers** post‑processor. |
| `CUDA available: False`                | Install propr. NVIDIA driver (`sudo ubuntu-drivers install && reboot`).                      |
| Mic busy / no input                    | Kill old dictation processes: `pkill -f whisper-dictation` or `pkill -f nerd-dictation`.     |

---

## ✍️ Punctuation restoration (optional)

```python
from transformers import pipeline
rest = pipeline("token-classification", \
    model="VOCALINLP/spanish_capitalization_punctuation_restoration_sanivert", \
    aggregation_strategy="plain")
text_fixed = get_result_text_es_pt(rest(raw_text), raw_text, "es")
```

Call `text_fixed` instead of the raw output before piping to `xdotool`.

---

## 📦 Uninstall

```bash
rm ~/.local/bin/whisper-dictation ~/.cache/whisper-dictation.pid
pip uninstall faster-whisper sounddevice webrtcvad torch
sudo apt remove libportaudio2 xdotool ffmpeg
```

---

© 2025 Your Name — MIT License
