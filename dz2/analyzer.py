delims = ' ();='
func_words = ['if', 'else']


def first_word(s: str):
    def find_first_delim_index(s: str):
        res = s.find(next(x for x in s if x in delims))
        return res if res != -1 else len(s) - 1

    return s[:find_first_delim_index(s) + 1]


def id(s: str):
    s = s.lstrip()
    word = first_word(s)
    valid = word.isalpha() and not (word in func_words)
    if valid:
        print(f'Identifier: #{word}')
        s = s[len(word):]
    return s, valid


def assignment(s: str):
    pass


def else_condition(s: str):
    s = s.lstrip()
    word = first_word(s)
    if word != 'else':
        return s, True

    s1 = s[len(word):].lstrip()
    s1, valid = expression(s)

    if not valid:
        return s, False

    return s1, True


def condition(s: str):
    s = s.lstrip()
    word = first_word(s)
    if word != 'if':
        return s, False

    s1 = s[len(word):].lstrip()
    if s1[0] != '(':
        return s, False

    s1 = s1[1:].lstrip()
    s1, valid = id(s1)
    if not valid:
        return s, False

    s1 = s1.lstrip()
    if s1[0] != ')':
        return s, False

    return s1[1:], True


def expression(s: str):
    s, valid = condition(s)

    if valid:
        s, valid = expression(s)
        if not valid:
            return s, valid
        s, valid = else_condition(s)
        return s, valid

    s, valid = id(s)
    if not valid:
        return s, valid
    s, valid = assignment(s)
    return s, valid


def simple_expression(s: str):
    s, valid = expression(s)
    s = s.strip()

    if s[0] != ';':
        return False

    return valid


while s := input() != 'exit':
    if simple_expression(s):
        print('Строка валидна')
    else:
        print('Строка не валидна')
