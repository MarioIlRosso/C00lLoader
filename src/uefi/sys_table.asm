bits 64

; First entry of EFI_SYSTEM_TABLE.
struc EFI_TABLE_HEADER
	.Signature: resq 1
	.Revision: resd 1
	.HeaderSize: resd 1
	.CRC32: resd 1
	.Reserved: resd 1
endstruc

; Almost all fields here are qwords cause 64x has 8 byte ptrs.
struc EFI_SYSTEM_TABLE
	.Hdr: resb EFI_TABLE_HEADER_size	; EFI_TABLE_HEADER_size is auto defined by assembly.
	.FirmwareVendor: resq 1
	.FirmwareRevision: resd 1
	.ConsoleInHandle: resq 1
	.ConIn: resq 1
	.ConsoleOutHandle: resq 1
	.ConOut: resq 1
	.StandardErrorHandle: resq 1
	.StdErr: resq 1
	.RuntimeServices: resq 1
	.BootServices: resq 1
	.NumberOfTableEntries: resq 1
	.ConfigurationTable: resq 1
endstruc
