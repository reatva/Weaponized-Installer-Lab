## Weaponized Installer Lab
This Project simulates a read team scenario where a legitimate installer is modified to carry a stealth payload. The goal is to demonstrate payload delivery via social engineering, without raising antivirus alarms.

## Lab Objectives:

- Wrapper creation using Nim to embed an RC4-encrypted Sliver implant
- Hosting a fake download site that distributes trojanized installers
- Executing Sliver payloads in memory without touching disk (AV evasion)
- Triggering shell access *after* installation finishes

## Tools & Techniques Used
| Tool | Purpose |
|------|---------|
| Nim | Used to build the wrapper with RC4  encoded payload |
| Sliver | Payload generation |
| Python/HTML | Fake landing page and server |
| RC4 encoding | AV evasion |
| Social Engineering | Pretext: Software Download |

## Wrapper Details
- Base installer: VLC media player (can be any legit installer)
- Payload: Reverse shell
- Encoding: RC4 to bypass AV
- Trigger: Executed only after installer finishes

## How it works 
1. User lands on fake VLC download page
2. They download a trusted-looking installer
3. Inside the wrapper:
     - RC4 shellcode is decrypted after legit install finishes
     - Reverse shell is launched to the attacker's listener
4. No UAC prompt or antivirus alert triggered (on tests)

## Full attack Preview
![Alt text](/docs/screenshots/2.LandingPage.png)

- Download button triggers 'wrapper.exe'

![Alt text](/docs/screenshots/3.wrapper-installation.png)

- Launches legit VLC installer

![Alt text](/docs/screenshots/4.sliver-c2.png)

- C2 reverse shell obtained

Want to reproduce the lab? Follow the steps provided [here.](/steps/setup.md) 

## Video


## Optional: Post-Exploitation Persistance
- Registry run key
- Scheduled task

## Disclaimer
This lab was created for educational and red teaming purposes only.
All actions were performed in isolated lab environments under controlled conditions.


