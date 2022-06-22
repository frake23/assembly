delims = ' ();='
func_words = ['if', 'else']


def empty(f):
    def _w(s: str):
        if s == '':
            return s, False
        return f(s)
    return _w


def first_word(s: str):
    def find_first_delim_index(s: str):
        try:
            res = s.find(next(x for x in s if x in delims))
            return res - 1
        except:
            return len(s) - 1

    return s[:find_first_delim_index(s) + 1]


@empty
def id(s: str):
    s = s.lstrip()
    word = first_word(s)
    valid = word.isalpha() and not (word in func_words)
    if valid:
        print(f'Идентификатор: {word}')
        s = s[len(word):]
        return s, valid
    else:
        raise Exception(f'Неверный идентификатор: {word}')


@empty
def number(s: str):
    s = s.lstrip()

    s1 = s
    if s[0] == '-':
        s1 = s[1:]

    word = first_word(s1)

    if word.isnumeric():
        print(f'Число: {word}')
        return s1[len(word):], True

    return s, False


@empty
def assignment(s: str):
    s = s.lstrip()
    if s == '' or s[0] != '=':
        raise Exception(f'Ожидался терминал: =')

    s1 = s[1:].lstrip()
    s1, valid = number(s1)
    if valid:
        return s1, valid

    s1, valid = id(s1)

    return s1, True


@empty
def else_condition(s: str):
    s = s.lstrip()
    word = first_word(s)
    if word != 'else':
        return s, True
    print('Служебное слово: else')

    s1 = s[len(word):].lstrip()
    s1, valid = expression(s1)

    if not valid:
        return s, False

    return s1, True


@empty
def condition(s: str):
    s = s.lstrip()
    word = first_word(s)
    if word != 'if':
        return s, False
    print('Служебное слово: if')

    s1 = s[len(word):].lstrip()
    if s1 == '' or s1[0] != '(':
        raise Exception('Ожидался терминал: (')

    s1 = s1[1:].lstrip()
    s1, valid = id(s1)

    s1 = s1.lstrip()
    if s1[0] != ')':
        raise Exception('Ожидался терминал: )')

    return s1[1:], True


@empty
def expression(s: str):
    s, valid = condition(s)

    if valid:
        s, valid = expression(s)
        s, valid = else_condition(s)
        return s, valid

    s, valid = id(s)
    s, valid = assignment(s)
    return s, valid


def simple_expression(s: str):
    s, valid = expression(s)
    s = s.strip()

    if s == '' or s[0] != ';':
        raise Exception('Ожидался терминал: ;')

    return valid


print("Вводите строки до exit")
while (s := input()) != 'exit':
    try:
        simple_expression(s)
        print('Строка валидна')
    except Exception as e:
        print(str(e))
        print('Строка не валидна')
