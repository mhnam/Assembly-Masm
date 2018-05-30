;----------------------------------------------
; Assignment 4
; Reverse String
;
; This program is to reverse entered text using
; stack memory.
;----------------------------------------------

INCLUDE irvine32.inc

.data
buffer BYTE 40 DUP(0)
byteCount DWORD ?
prompt1 BYTE "Type_A_String_To_Reverse: ", 0
prompt2 BYTE "Reversed_String: ", 0
prompt3 BYTE "Bye!", 0

.code
main PROC

L1: 
	;to print prompt1 on console
	mov edx, OFFSET prompt1
	call WriteString

	;get user string
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max char
	call ReadString				;input the string

	mov byteCount, eax			;get number of chars
	mov ecx, eax				;mov byteCounter(eax) into ecx to use in below proc
	jecxz quit					;quit if byteCounter == 0
	call ReverseString

	;to print prompt2 on console
	mov edx, OFFSET prompt2
	call WriteString

	;to print the result
	mov edx, OFFSET buffer
	call WriteString
	call Crlf

	;loop till no input is included
	jmp L1

quit:
	;to print prompt3 on console
	mov edx, OFFSET prompt3
	call WriteString
	call Crlf

	exit
main ENDP

;----------------------------------------------
; ReverseString
; Reverse string input
; 
; Receives: N/A
; Returns: N/A
;-----------------------------------------------

ReverseString PROC
	pushad			;to store previous values before the procedure
	mov eax, 0		;iniitalise eax
	mov esi, 0

L1: 
	; push given string into stack
	mov al, buffer[esi]
	cmp eax, 64d
	jbe L4
	cmp eax, 90d
	jbe L3
	cmp eax, 96d
	jbe L4
	cmp eax, 122d
	jbe L2
	jmp L4

L2:
	; capitalise
 	sub eax, 32d
	jmp L4

L3:
	; uncapitalise
	add eax, 32d

L4:
	; push it into stack
	push eax
	inc esi			; inc index esi
	loop L1

	;prepare for pop in L5
	mov ecx, byteCount
	mov esi, 0

L5: 
	;pop given string in stack
	pop eax
	mov buffer[esi], al
	inc esi
	loop L5

	popad			;to restore previous values before the procedure
	ret
ReverseString ENDP

END main
