events = [
    {'name': 'a/0', 'from': 's0', 'to': 's1'},
    {'name': 'c/3', 'from': 's1', 'to': 's0'},
    {'name': 'e/0', 'from': 's1', 'to': 's0'},
    {'name': 'e/0', 'from': 's0', 'to': 's0'},
    {'name': 'd/3', 'from': 's1', 'to': 's4'},
    {'name': 'e/1', 'from': 's4', 'to': 's0'},
    {'name': 'b/0', 'from': 's0', 'to': 's2'},
    {'name': 'd/4', 'from': 's2', 'to': 's0'},
    {'name': 'e/0', 'from': 's2', 'to': 's0'},
    {'name': 'c/0', 'from': 's2', 'to': 's3'},
    {'name': 'e/1', 'from': 's3', 'to': 's0'},
    {'name': 'c/4', 'from': 's3', 'to': 's0'},
    {'name': 'd/4', 'from': 's3', 'to': 's4'}
]

current_state = 's0'


def next_state(msg: str):
    match msg:
        case 'A' | 'B' as type:
            fun = lambda e: e['from'] == current_state and e['name'][0] == type.lower()
            event = list(filter(fun, events))[0]
            return {'state': event['to'], 'msg': f'\nВыбран товар {type}\n'}
        case '1' | '2' as num:
            prefix = 'c' if num == '1' else 'd'
            fun = lambda e: e['from'] == current_state and e['name'][0] == prefix
            event = list(filter(fun, events))[0]
            match event['name'][-1]:
                case '3' | '4' as good_num:
                    return {'state': event['to'], 'msg': f'\nВыдан товар {"A" if good_num == "3" else "B"}\n'}
                case '0':
                    return {'state': event['to'], 'msg': f'\nПолучено {num} рублей\n'}
        case 'cancel' | '' as action:
            fun = lambda e: e['from'] == current_state and e['name'][0] == 'e'
            event = list(filter(fun, events))[0]
            msg = '\nПокупка отменена\n' if action == 'cancel' else ''
            return {'state': event['to'], 'msg': f'{msg}Сдача: {event["name"][-1]} рублей\n'}


while True:
    read_msg = True
    match current_state:
        case 's0':
            print('Выберите товар A [1 рубль] или B [2 рубля] (type "A" or "B")')
        case 's1' | 's2' | 's3':
            print('Выберите действие: вставить 1 рубль, 2 рубля, отменить (type "1", "2" or "cancel")')
        case 's4':
            print('Получите сдачу')
            read_msg = False
    next_st = next_state(input() if read_msg else '')
    current_state = next_st['state']
    print(next_st['msg'])
