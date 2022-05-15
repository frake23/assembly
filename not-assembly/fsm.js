let myFsm = {
    initial: 's0',
    events: [
        {name: 'a/0', from: 's0', to: 's1'},
        {name: 'c/3', from: 's1', to: 's0'},
        {name: 'e/0', from: 's1', to: 's0'},
        {name: 'e/0', from: 's0', to: 's0'},
        {name: 'd/3', from: 's1', to: 's4'},
        {name: 'e/1', from: 's4', to: 's0'},
        {name: 'b/0', from: 's0', to: 's2'},
        {name: 'd/4', from: 's2', to: 's0'},
        {name: 'e/0', from: 's2', to: 's0'},
        {name: 'c/0', from: 's2', to: 's3'},
        {name: 'e/1', from: 's3', to: 's0'},
        {name: 'c/4', from: 's3', to: 's0'},
        {name: 'd/4', from: 's3', to: 's4'},
    ],
}