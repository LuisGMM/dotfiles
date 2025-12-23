import re


def process_text(
    text,
    text_replace_regex,
    word_replace,
    word_replace_regex,
    trigger_words,  # Lista de palabras activadoras, p.ej. ["inserta"] o ["insert"].
    commands,  # Diccionario { "punto": ".", "nueva línea": "\n", ... }
    do_capitalize_after_punct,  # True/False para capitalizar tras signos (., !, ?)
):
    """
    1) Aplica primero los reemplazos globales con regex (TEXT_REPLACE_REGEX).
    2) Divide en tokens y procesa la secuencia para:
       - Reemplazos de palabra (WORD_REPLACE y WORD_REPLACE_REGEX).
       - Inserción de puntuaciones/saltos de línea SOLO si están precedidos por una palabra activadora.
    3) Si do_capitalize_after_punct=True, capitaliza la letra que sigue a un . ? !
       (o la que decidas) si va en minúscula.
    """

    # 1. Reemplazos globales con regex

    for pattern, replacement in text_replace_regex:
        text = pattern.sub(replacement, text)

    # 2. Tokenizamos para controlar la lógica de "palabra activadora + comando"
    tokens = text.split()
    new_tokens = []
    skip_next = False

    for i, token in enumerate(tokens):
        # Si marcamos skip_next=True, significa que acabamos de procesar un comando
        # y no añadimos la palabra actual (porque era la "palabra activadora").

        if skip_next:
            skip_next = False

            continue

        # Reemplazos directos de palabra (sin relación con la puntuación).
        token_final = apply_word_replacements(token, word_replace, word_replace_regex)

        # Comprobamos si esta palabra es una "palabra activadora" (p.ej. "inserta").
        token_lower = token_final.lower()

        if token_lower in trigger_words and (i + 1) < len(tokens):
            # Miramos el siguiente token para ver si es un comando reconocible
            next_token = tokens[i + 1].lower()

            if next_token in commands:
                # Insertamos el símbolo (puntuación, salto de línea, etc.)
                new_tokens.append(commands[next_token])
                # Marcamos skip_next para no repetir el token siguiente.
                skip_next = True
            else:
                # Si la palabra activadora no va seguida de un comando reconocido,
                # simplemente añadimos la palabra activadora tal cual.
                new_tokens.append(token_final)
        else:
            # En caso de que no sea la palabra activadora, añadimos el token resultante.
            new_tokens.append(token_final)

    # Unimos con espacios. (Si hay saltos de línea, se quedarán como '\n' literal por ahora)
    final_text = " ".join(new_tokens)

    # 3. Capitalizar la letra posterior a '.', '!', '?' (o las que definas).

    if do_capitalize_after_punct:
        final_text = capitalize_after_punctuation(final_text)

    return final_text


def apply_word_replacements(token, word_replace, word_replace_regex):
    """
    Aplica WORD_REPLACE y WORD_REPLACE_REGEX sobre un token dado.
    """
    # Reemplazo exacto

    if token in word_replace:
        return word_replace[token]

    # Reemplazo con regex
    temp = token

    for pattern, repl in word_replace_regex:
        new_val = pattern.sub(repl, temp)

        if new_val != temp:
            temp = new_val

            break

    return temp


def capitalize_after_punctuation(text):
    """
    Busca secuencias tipo: [punto/exclamación/interrogación] + espacio + letra minúscula
    y pone en mayúscula la letra posterior.
    También maneja el caso de salto de línea.
    """
    # Ejemplo de regex que detecta . ? !, seguidos de espacios y una letra a-z
    # y la sustituye por su versión capitalizada.
    # Nota: si usas saltos de línea en el texto final, conviene tratar esos casos también.
    pattern = re.compile(r"([\.!?])(\s+)([a-záéíóú])")
    # \1 -> signo
    # \2 -> espacios
    # \3 -> letra a capitalizar

    def repl_func(match):
        signo = match.group(1)
        espacios = match.group(2)
        letra = match.group(3)

        return f"{signo}{espacios}{letra.upper()}"

    text = pattern.sub(repl_func, text)

    return text


def fix_punctuation_spacing(text):
    """
    1) Elimina espacios antes de , . : ; ! ?
    2) Asegura un espacio después de estos signos si no hay un salto de línea ni es fin de cadena.
    """
    # 1) Eliminar espacios antes de la puntuación
    text = re.sub(r"\s+([,\.\:\;\!\?])", r"\1", text)

    # 2) Asegurar espacio después de la puntuación (si no hay salto de línea ni fin de cadena)
    text = re.sub(r"([,\.\:\;\!\?])([^ \n])", r"\1 \2", text)

    return text
