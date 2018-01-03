format PE GUI 4.0 
entry start 
include 'win32a.inc' 

section 'binary' code readable writeable executable 
start: invoke CreateProcessA,exe_path,0,0,0,0,0,0,0,startupinfo,processinfo 


       invoke VirtualAllocEx,dword [Process],0,code2.endx-code2,MEM_COMMIT+MEM_RESERVE,0x40 
       mov [newadr],eax 
       sub eax,[oldadr] 
       sub eax,5 
       mov [code01.addr],eax 
       mov eax,[oldadr] 
       sub eax,(code2.endx-code2)-(code01.endx-code01) 
       sub eax,[newadr] 
       mov [code2.endx-4],eax 
       invoke VirtualProtectEx,dword [Process],0,code01.endx-code01,MEM_COMMIT+MEM_RESERVE,0 

       invoke WriteProcessMemory,dword [Process],[oldadr],code01,code01.endx-code01,need 
       invoke WriteProcessMemory,dword [Process],[newadr],code2,code2.endx-code2,need 

       invoke ExitProcess,0 

section 'data'  data readable writeable 
newadr: dd 0 
oldadr: dd 0x72FF96 
code01: db 0xe9 
 .addr: db 0,0,0,0,90h,90h 
 .endx: 
code2: cmp ecx,[0x400000+0x4CECBC] 
       je code2.x 
       mov dword [ecx+eax*4+0x1B8],0 
  .x:  db 0xE9,0,0,0,0 
 .endx: 
startupinfo: 
       dd 68 
       times 64 db 0 
processinfo: 
        Process dd 0 
        Thread dd 0 
        ProcessId dd 0 
        ThreadId dd 0 

need: dd 0 
exe_path: db  "C:\Program Files (x86)\Steam\SteamApps\common\Gothic II\system\Gothic2.exe",0 

section 'library' import data readable writeable 
        library kernel32,'KERNEL32.DLL' 
        include 'api\kernel32.inc' 
