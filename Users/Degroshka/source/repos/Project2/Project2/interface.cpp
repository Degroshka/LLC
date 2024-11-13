#include <iostream>
#include <cstring>
using namespace std;

extern "C" void __stdcall CompressString(const char* source, char* dest);

int main() {
    char inputString[256];     // Буфер для ввода строки
    char outputString[256] = { 0 }; // Буфер для хранения результата

    // Ввод строки вручную 
    cout << "Input string: ";
    cin.getline(inputString, 256);
    // Вызов ассемблерной функции
    CompressString(inputString, outputString);

    // Выводим оригинальную и сжатую строки
    cout << "Original string: " << inputString << std::endl;
    cout << "Compressed string: " << outputString << std::endl;
    return 0;
}
