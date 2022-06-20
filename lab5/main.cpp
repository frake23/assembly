#include <iostream>

using namespace std;

const int INPUT_SIZE = 255;
const int MAX_WORDS = 128;

extern void reverse_string(char* source, short* indexes, char* result);

void output(short i) {
    cout << "Word " << i << " reversed" << '\n';
}

int main()
{
    char *s;
    short indexes[MAX_WORDS];
    char result[INPUT_SIZE];
    int n, i;
    std::string strtmp;

    cout << "Enter the string" << '\n';
    getline(cin, strtmp);
    s = const_cast<char*>(strtmp.c_str());

    cout << "Enter words count" << '\n';
    cin >> n;

    cout << "Enter word numbers" << '\n';
    for (i = 0; i < n; i++) {
        cin >> indexes[i];
        
    }
    indexes[i+1] = 0;

    reverse_string(s, indexes, result);

    cout << "Result string: \n";
    cout << result << '\n';
}

// _Z6outputc
// _Z14reverse_stringPKcP

