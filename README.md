# DJMaxRespectV-Randomizer

  Small program to provide a controlled random song selection which neowiz patched away.
  Sadly this decision makes practicing a specific difficulty range very hard and since it directly plays
  the song without informing you about the difficulty.
  If you are as sad as me this program is for you :)
  
  Completely written in AHKv2. Only compatible with DJMax Respect V on PC (Steam platform).

## DISCLAIMER:

  This program does not interfere in any way with the DJMax Respect V 
  game data or internal memory thus enabling the usage with xigncode3 protection.
  In fact this program does not require the game at all. All data is provided externally.

## HOW IT WORKS:

  This program only sends keyboard event inputs which are interpreted by the game.
  These inputs are determined by the function and files provided within this repository.

## KNOWN ISSUES:

  I can not guarantee that this randomizer works with every bought DLC combination.
  In the PS4-Era some songs were only unlocked (like the extended mix versions) if a few specific DLCs are bought.
  This could mess up the randomizer table making code changes a necessity (aka releasing a new version).

## COMPILING & RUNNING:

  ### Method A (For Developers):
    Download a copy from this repository and extract it.
    Download AHK v2 beta from autohotkey.com and put it into the same folder
    where the extracted repository is. Drag the .ahk onto the executable.
  
  ### Method B (Self compiled .exe):
    Follow METHOD A and use the ahk2exe inside the UX folder to compile a .exe yourself.
  
  ### Method C (Trust):
    If you trust a random stranger on the internet ( Me :) ) you can just download the precompiled
    Executable and database directly from the release tab. No further downloads necessary.

## KEY FEATURES:
  - Extended Filter Options for
      Songpacks, K-Modes, Chart Difficulty and Star range.
  - Change Keydelay if selected songs are off and don't reflect the rolled song.
  - Exclude charts if you don't need them with F4. Database is updated on program exit.
  - Full Stream Deck support (contact me for details).
      It shows all rolled song data including stars and if the chart will be excluded.
  - Numpad(+) will bring up the randomizer in foreground to adjust settings.
  - CTRL+F2 will reroll the current rolled song in case the game glitches/brings up the new menu etc...
  - Pressing F2 will roll the song and bring it up in the game.
  
## USAGE:
  Run the game and enter Freestyle-Mode. Make sure 'All Tracks' tab is selected.
  
  Run this program and click on 'DLC' to select your bought packs.
  Select the desired filter options. GUI should be self-explanatory.
  Settings will be saved as a .ini including filter options and window position!.
  
  Either click on 'Go!' or press F2 on your keyboard. If the game is running it should select the randomly selected song
  with the correct button and difficulty mode!
  
 ## SCREENSHOTS:
 
![grafik](https://github.com/user-attachments/assets/ab34e4b0-0bc5-4e41-b8c6-9dc1f715aa70)
![grafik](https://github.com/user-attachments/assets/ce2977d4-ab51-4942-b1f2-1882cdf9490c)
![grafik](https://github.com/user-attachments/assets/edb9144a-8c55-4935-ad9f-9aefdc0cf505)

  
