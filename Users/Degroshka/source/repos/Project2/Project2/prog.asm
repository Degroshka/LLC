.386
.model flat, stdcall
.stack 4096

.data
errorMessage db "Error: invalid character", 0  ; ��������� �� ������ 

.code
CompressString proc source: PTR BYTE, dest: PTR BYTE
    ; ��������� ��������
    push esi
    push edi
    push ecx
    push ebx

    ; ������������� ����������
    mov esi, source              ; esi ��������� �� ������ �������� ������
    mov edi, dest                ; edi ��������� �� ������ �������� ������
    xor ebx, ebx                 ; ���������� ebx ��� "������� �����" ��� ���������� ��������

    ; ���������� ����� ������ (���� �����)
    mov edx, esi                 ; ������ ������
find_end:
    cmp byte ptr [edx], 0
    je start_compression         ; ���� ��������� ����� ������
    inc edx
    jmp find_end

start_compression:
    dec edx                      ; edx ������ ��������� �� ��������� ������ ������

reverse_loop:
    cmp edx, esi                 ; ���������, �������� �� ������ ������
    jb end_compression           ; ���� ����� �� ������, ��������� ����

    ; �������� ������� ������
    mov al, byte ptr [edx]

    ; �������� �� ����� 'a'-'z'
    cmp al, 'a'
    jl check_uppercase           ; ������� � �������� ��������� ����, ���� ������ ������ 'a'
    cmp al, 'z'
    jg check_uppercase           ; ������� � �������� ��������� ����, ���� ������ ������ 'z'

    ; ����������� ������ � �������� 0-25 � ��������� ������� �����
    sub al, 'a'
    bt ebx, eax
    jc skip_char                 ; �������, ���� ��� ���������� (������ ��� ���)

    bts ebx, eax                 ; ������������� ��� ��� ����� �������
    add al, 'a'                  ; ���������� ������ � ��������� ��������
    mov byte ptr [edi], al       ; ���������� ������ � �������� ������
    inc edi                      ; ����������� ��������� �������� ������
    jmp skip_char

check_uppercase:
    ; �������� �� ����� 'A'-'Z'
    cmp al, 'A'
    jl check_digits              ; ������� � �������� ����, ���� ������ ������ 'A'
    cmp al, 'Z'
    jg check_digits              ; ������� � �������� ����, ���� ������ ������ 'Z'

    ; ����������� ������ � �������� 0-25 � ��������� ������� �����
    sub al, 'A'
    bt ebx, eax
    jc skip_char                 ; �������, ���� ��� ���������� (������ ��� ���)

    bts ebx, eax                 ; ������������� ��� ��� ����� �������
    add al, 'A'                  ; ���������� ������ � ��������� ��������
    mov byte ptr [edi], al       ; ���������� ������ � �������� ������
    inc edi                      ; ����������� ��������� �������� ������
    jmp skip_char

check_digits:
    ; �������� �� ����� '0'-'9'
    cmp al, '0'
    jl invalid_character         ; ������� � ������, ���� ������ ������ '0'
    cmp al, '9'
    jg invalid_character         ; ������� � ������, ���� ������ ������ '9'

    ; ����������� ������ � �������� 26-35 � ��������� ������� �����
    sub al, '0'
    add al, 26                   ; �������� � �������� 26-35
    bt ebx, eax
    jc skip_char                 ; �������, ���� ��� ���������� (������ ��� ���)

    bts ebx, eax                 ; ������������� ��� ��� ����� �������
    sub al, 26                   ; ���������� ������ � ��������� ��������
    add al, '0'
    mov byte ptr [edi], al       ; ���������� ������ � �������� ������
    inc edi                      ; ����������� ��������� �������� ������
    jmp skip_char

invalid_character:
    ; ������������� ��������� �� ������
    lea esi, errorMessage
    mov edi, dest
    copy_error_message:
        mov al, byte ptr [esi]
        mov byte ptr [edi], al
        inc esi
        inc edi
        cmp al, 0
        jne copy_error_message
    jmp end_compression

skip_char:
    dec edx                      ; ������� � ���������� ������� (������ ������)
    jmp reverse_loop

end_compression:
    ; ��������� �������� ������ ������� ������
    mov byte ptr [edi], 0

    ; ��������������� ��������
    pop ebx
    pop ecx
    pop edi
    pop esi
    ret
CompressString endp

end
