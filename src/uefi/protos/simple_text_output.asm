struc EFI_SIMPLE_TEXT_OUTPUT_PROTO
	.Reset: resq 1
	.OutputString: resq 1
	.TestString: resq 1
	.QueryMode: resq 1
	.SetMode: resq 1
	.SetAttribute: resq 1
	.ClearScreen: resq 1
	.SetCursorPosition: resq 1
	.EnableCursor: resq 1
	.Mode: resq 1
endstruc
