import re
from nerd_dictation_common import fix_punctuation_spacing, process_text

TEXT_REPLACE_REGEX = (
    (re.compile(r"\bdata type\b"), "data-type"),
    (re.compile(r"\bcopy on write\b"), "copy-on-write"),
    (re.compile(r"\bkey word\b"), "keyword"),
)

WORD_REPLACE = {
    "i": "I",
    "api": "API",
    "linux": "Linux",
    "um": "",
}
WORD_REPLACE_REGEX = ((re.compile(r"^i'(.*)"), r"I'\1"),)

# The user must say "insert" then a recognized command to trigger punctuation
TRIGGER_WORDS = ["insert"]

COMMANDS = {
    # Basic punctuation
    "period": ".",
    "comma": ",",
    "exclamation": "!",
    "exclamation mark": "!",
    "question": "?",
    "question mark": "?",
    # More punctuation
    "colon": ":",
    "semicolon": ";",
    "dash": "-",
    # Parentheses
    "open": "(",
    "parenthesis": "(",
    "close": ")",
    "closing": ")",
    # Quotes
    "quote": '"',
    # New line
    "new": "\n",  # if user says "insert new line"
    "line": "\n",
}

CAPITALIZE_AFTER_PUNCT = True


def nerd_dictation_process(text):
    t = process_text(
        text=text,
        text_replace_regex=TEXT_REPLACE_REGEX,
        word_replace=WORD_REPLACE,
        word_replace_regex=WORD_REPLACE_REGEX,
        trigger_words=TRIGGER_WORDS,
        commands=COMMANDS,
        do_capitalize_after_punct=CAPITALIZE_AFTER_PUNCT,
    )

    t = fix_punctuation_spacing(t)

    return t
