%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    ; TODO Task1
    
    push dword[img]
    
    call bruteforce_singlebyte_xor

    jmp done
solve_task2:
    ; TODO Task2
    jmp done
solve_task3:
    ; TODO Task3
    jmp done
solve_task4:
    ; TODO Task4
    jmp done
solve_task5:
    ; TODO Task5
    jmp done
solve_task6:
    ; TODO Task6
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
    
bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    mov ebx, [img_width]                ; mut latimea imaginii in registrul ebx
    mov eax, [img_height]               ; mut lungimea imaginii in registrul eax
    mul ebx                             ; fac inmultirea cu ebx
    mov ecx, eax                        ; mut valoarea rezultata in urma inmultirii in reigstrul ecx
    mov esi,[img]                      
        
loop1:
    xor eax,eax
key_loop:
    inc eax                             ; testez o cheie noua
    cmp eax,256                         ; vad daca am terminat de testat cheile
    jz end_key_loop
    
    xor ebx,ebx
    mov edx, dword[esi + 4*ecx]
    xor edx, eax
    cmp edx, 't'                        ; verific daca am gasit t
    je i_found_the_t
 
cont_from_false_pos:                    ; daca o cheie a dat eronat continui cu cheile
          
    jmp key_loop                    
    
end_key_loop:

    dec ecx
    cmp ecx,0
    jnz loop1
    
    jmp out_of_force
    
i_found_the_t:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'n'
    je i_found_the_n
    jne skip

i_found_the_n:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'e'
    je i_found_the_e1
    jne skip

i_found_the_e1:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'i'
    je i_found_the_i
    jne skip

i_found_the_i:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'v'
    je i_found_the_v
    jne skip

i_found_the_v:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'e'
    je i_found_the_e2
    jne skip
    
i_found_the_e2:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    cmp edx, 'r'
    je i_found_the_key
    jne skip

i_found_the_key:
    inc ebx                             ; numara
    dec ecx                             ; ma duc la stanga
    mov edx, dword[esi + 4*ecx]         ; iau pixelul
    xor edx, eax                        ; decripteaza
    jmp out_of_force

skip:
    add ecx,ebx                         ;adun cati pixeli am scos (ma intorc la ultimul pixel/litera)
    jmp cont_from_false_pos

out_of_force:

    mov edi,eax
    
    mov edx,0
    mov eax,ecx
    mov ebx,[img_width]
    div ebx
   
    mov ebx,eax
    
    ; ebx linia
    ; edx coloana
    
    sub ecx,edx                         ; ecx - start linie
                                        ; nu mai am nevoie de edx
    
    mov eax,edi                         ; eax - cheia
    
msg_loop:

    mov edx,[esi+4*ecx]
    xor edx,eax
    cmp edx,0
    jz end_msg_loop
    PRINT_CHAR edx
    inc ecx
    jmp msg_loop

end_msg_loop:
    NEWLINE
    PRINT_DEC 4,eax
    NEWLINE
    PRINT_DEC 4,ebx
    NEWLINE

    leave
    ret
    
