%include "src/uefi/protos/simple_text_output.asm"

; (rcx: ConOut, rdx: String Pointer)
print_str:
	mov rax, [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTO.OutputString]

	sub rsp, 40
	call rax
	add rsp, 40

	ret
