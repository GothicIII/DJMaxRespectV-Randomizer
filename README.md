# DJMaxRespectV-Randomizer

  Small program to provide a controlled random song selection which neowiz patched away.
  Sadly this decision makes practicing a specific difficulty range very hard and since it directly plays
  the song without informing you about the difficulty.
  If you are as sad as me this program is for you :)
  
  Completely written in AHKv2. Only compatible with DJMax Respect V on PC (Steam platform).

DISCLAIMER:
  This program does not interfere in any way with the DJMax Respect V 
  game data or internal memory thus enabling the usage with xigncode3 protection.
  In fact this program does not require the game at all. All data is provided externally.

HOW IT WORKS:
  This program only sends keyboard event inputs which are interpreted by the game.
  These inputs are determined by the function and files provided within this repository.

KNOWN ISSUES:
  I can not guarantee that this randomizer works with every bought DLC combination.
  In the PS4-Era some songs were only unlocked (like the extended mix versions) if a few specific DLCs are bought.
  This could mess up the randomizer table making code changes a necessity (aka releasing a new version).
  
  I don't own MUSE DASH DLC so data for it is missing. If you own it already, the random tables will be
  messed up for you meaning you won't be taken to the right song (it will be either further down or up).
  I'll get the DLC as soon it gets on discount. Then I'll be able to patch this.

COMPILING & RUNNING:
  Method A <For Developers>:
    Download a copy from this repository and extract it.
    Download AHK v2 beta from autohotkey.com and put it into the same folder where the extracted repository is.
    Drag the .ahk onto the executable.
  
  Method B <Self compiled .exe>:
    Follow METHOD A and use the ahk2exe inside the UX folder to compile a .exe yourself.
  
  Method C <Trust>:
  If you trust a random stranger on the internet ( Me :) ) you can just download the precompiled
  Executable and database directly from the release tab. No further downloads necessary.
  
USEAGE:
  Run the game and enter Freestyle-Mode. Make sure 'All Tracks' tab is selected.
  Run this program and click on 'DLC' to select your bought packs.
  Select the desired filter options. 
  
  Either click on 'Go!' or press F2 on your keyboard. If the game is running it should select the randomly selected song
  with the correct button and difficulty mode!
