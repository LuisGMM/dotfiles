import re
from nerd_dictation_common import process_text, fix_punctuation_spacing

# 1) Reemplazos globales de frases
TEXT_REPLACE_REGEX = (
    (re.compile(r"\bdata type\b"), "data-type"),
    (re.compile(r"\bcopy on write\b"), "copy-on-write"),
    (re.compile(r"\bkey word\b"), "keyword"),
)

# 2) Reemplazo de palabras individuales
WORD_REPLACE = {
    "linux": "Linux",
    # Agrega aquí otros reemplazos que quieras.
}
WORD_REPLACE_REGEX = ((re.compile(r"^i'(.*)"), r"I'\1"),)

# 3) Palabras activadoras y comandos de puntuación/acción
#    Solo se reemplazan si van precedidos de "inserta" (o "insertar", etc.)
TRIGGER_WORDS = ["inserta", "insertar"]

COMMANDS = {
    # Signos de puntuación
    "punto": ".",
    "coma": ",",
    "signo": "",  # un ejemplo: "inserta signo" (podrías usarlo de otra forma)
    "exclamación": "!",
    "interrogación": "?",
    "dos": ":",  # si dices "inserta dos puntos" -> ":", se vería algo raro, conviene "dos puntos": ":"
    "puntos": ":",
    "puntoycoma": ";",  # si usas "inserta puntoycoma"
    "puntoy coma": ";",  # a veces lo dices separado
    # Paréntesis
    "abre": "(",  # "inserta abre paréntesis"
    "paréntesis": "(",  # para que "inserta paréntesis" -> "("
    "cierra": ")",
    "cerrar": ")",
    # Comillas
    "comillas": '"',
    # Salto de línea
    "nueva": "\n",  # "inserta nueva línea"
    "línea": "\n",
    "linea": "\n",
}

# 4) Activar capitalización después de ., !, ?
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
