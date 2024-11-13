#include <iostream>
#include <cstring>
using namespace std;

extern "C" void __stdcall CompressString(const char* source, char* dest);

int main() {
    char inputString[256];     // ����� ��� ����� ������
    char outputString[256] = { 0 }; // ����� ��� �������� ����������

    // ���� ������ ������� 
    cout << "Input string: ";
    cin.getline(inputString, 256);
    // ����� ������������ �������
    CompressString(inputString, outputString);

    // ������� ������������ � ������ ������
    cout << "Original string: " << inputString << std::endl;
    cout << "Compressed string: " << outputString << std::endl;
    return 0;
}
