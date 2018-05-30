;----------------------------------------------
; Assignment 4-2
; Encrypt using XORing
;
; This program is to encrypt entered text using
; given key by XORing.
;----------------------------------------------


INCLUDE irvine32.inc

.data
buffer BYTE 40 DUP(0)
key BYTE 40 DUP(0)
buffCount DWORD ?
keyCount DWORD ?
prompt1 BYTE "Enter a plain text: ", 0
prompt2 BYTE "Enter a key : ", 0
prompt3 BYTE "Original Text: ", 0
prompt4 BYTE "Encrypted Text: ", 0
prompt5 BYTE "Decrypted Text: ", 0
prompt6 BYTE "Bye!", 0

.code
main PROC

L1: 
	;to print prompt1 on console
	mov edx, OFFSET prompt1
	call WriteString

	;get user plain text
	mov edx, OFFSET buffer		; point to the buffer
	mov ecx, SIZEOF buffer		; specify max char
	call ReadString				; input the string

	mov buffCount, eax			; get number of chars
	mov ecx, eax				; mov buffCount(eax) into ecx to use in below proc
	jecxz quit					; quit if buffCount == 0

	call getKey					; Get Key
	call PrintResult			; Print the Result
	jmp L1						; loop till no input is included

quit:
	;to print prompt6 on console
	mov edx, OFFSET prompt6
	call WriteString
	call Crlf

	exit
main ENDP

;-------------------------------------------------
; Get Key (getKey)
;
; Get Key to Encrypt.
;
; Receives: N/A
; Returns: N/A
;-------------------------------------------------

getKey PROC

	;to print prompt2 on console
	mov edx, OFFSET prompt2
	call WriteString

	;get user key
	mov edx, OFFSET key			;point to the buffer
	mov ecx, SIZEOF key			;specify max char
	call ReadString				;input the string

	mov keyCount, eax			;get number of chars
	call Crlf
	
	ret
getKey ENDP


;-------------------------------------------------
; Print Result (printResult)
;
; Print (1) Original Text, (2) Encrypted Text by 
; XORing each byte the string by XORing each byte
; and (3) Decrypted Text.
;
; Receives: N/A
; Returns: N/A
;-------------------------------------------------

printResult PROC
	
	;to print prompt3 on console and original text
	mov edx, OFFSET prompt3
	call WriteString
	mov edx, OFFSET buffer
	call WriteString

	;to print prompt4 on console and encrypted text
	call Crlf
	mov edx, OFFSET prompt4
	call WriteString
	call enDecrypt
	mov edx, OFFSET buffer
	call WriteString

	;to print prompt3 on console and decrypted text
	call Crlf
	mov edx, OFFSET prompt5
	call WriteString
	call enDecrypt
	mov edx, OFFSET buffer
	call WriteString

	call Crlf
	call Crlf
	
	ret
printResult ENDP

;-------------------------------------------------
; Encrypt/Decrypt (enDecrypt)
;
; Translates the string by XORing each byte
; with the same integer.
; Receives: nothing. Returns: nothing
;-------------------------------------------------

enDecrypt PROC
	
	pushad

	mov ecx, buffCount		; set loop counter
	mov esi, 0				; index 0 in buffer1 (string)
	mov edi, 0				; index 0 in buffer2 (key)
	mov eax, 0				; initialise eax reg

	jmp L2

	L1:
		mov edi, 0			; set index 0
		jmp L2

	L2:
		mov al, key[edi]				; move key[edi] to eax reg
		xor buffer[esi], al				; translate a byte
		inc esi							; point to next byte for buffer
		inc edi							; point to next byte for key
		cmp edi, keyCount				; check whether key is all used
		je L1
		loop L2

	popad
	ret
enDecrypt ENDP

END main
