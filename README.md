# DJMaxRespectV-Randomizer
<img width="549" height="466" alt="grafik" src="https://github.com/user-attachments/assets/9985046d-d62d-4b92-bd91-6b88475ae408" />

  This is a program to provide a controlled random song selection which neowiz patched away.
  Sadly this decision makes practicing a specific difficulty range very hard and since it directly plays
  the song without informing you about the difficulty.\
  If you are as sad as me this program is for you :)
  
  Completely written in AHKv2. Only compatible with DJMax Respect V on PC (Steam platform) and Windows.\
  I don't know if it works on Linux using Wine but since AHKv2 uses WinApi it will be hit or miss.


## DISCLAIMER

  This program does not interfere in any way with the DJMax Respect V\
  game data or internal memory thus enabling the usage with xigncode3 protection.\
  In fact this program does not require the game at all. All data is provided externally.


## HOW IT WORKS

  This program only sends keyboard event inputs which are interpreted by the game.\
  These inputs are determined by the function and files provided within this repository.


## KNOWN ISSUES

  - I can not guarantee that this randomizer works with every bought DLC combination.
    In the PS4-Era some songs were only unlocked (like the extended mix versions) if a few specific DLCs are bought.
    This could mess up the randomizer table making code changes a necessity (aka releasing a new version). I tried my best, though.
  - The game sometimes eats inputs - depending on CPU load, star constellations etc, so the target chart is not hit (0,X% chance).\
    For this there is an keydelay option which can be set higher to maybe reduce this problem (the default 25ms is already very well tested).
    You can also try CTRL+F2 to reroll the current chart to see if it was just a miss.\
    If it misses everytime please recheck enabled DLCs in options and open an issue if it still doesn't work.


## COMPILING

  ### Method A (For Developers):
    Download a copy from this repository and extract it.
    Download AHK v2 beta from autohotkey.com and put it into the same folder
    where the extracted repository is. Drag the .ahk onto the executable.
    StreamDeck is only supported as a compiled .exe!
  
  ### Method B (Self compiled .exe):
    Follow METHOD A and use the ahk2exe inside the UX folder to compile a .exe yourself.
  
  ### Method C (Trust):
    If you trust a random stranger on the internet ( Me :) ) you can just download the precompiled
    Executable and database directly from the release tab. No further downloads necessary.


## FIRST RUN
  Please make sure that SongList.db is in the same directory as the program; it is bundled with the .rar from the release page.\
  (if for whatever reason it is missing just download it from the repo)\
  When running the 1st time some info messages will appear and the program creates files/folders to run properly.
  
  <img width="400" alt="FirstRun" src="https://github.com/user-attachments/assets/488e220d-4b98-4b34-9c0c-6962cfd64989" />
  
  You'll see that all DLCs are disabled. If you only own the main game then you are good to go else press the
  Options-button and select the DLCs you own. These will be enabled. 
  
  <img width="400" alt="OptionsDLC" src="https://github.com/user-attachments/assets/3352a1e4-2062-4e99-8925-f11f5e1c07c6" />
  
  If your bought DLCs do not match here then the randomizer won't work properly and song selection will be always wrong!\
  The 'All'-checkboxes will toggle everything at once saving you a bit of time.\
  You may also go to the general tab and play with the options around there.

  Run the game and enter Freestyle-Mode. Make sure 'All Tracks' tab is selected and the sorting scheme is 'Title A-Z'.\
  I'm trying to bring more sorting options onto the table but it is really hard to keep track of the sorting functions.


## USING THE RANDOMIZER
  Everything in the main window should be self explanatory. The checkboxes toggle each song-pack while 'All' - yeah you guessed it -\
  toggles all (enabled) song-packs at once. Unset song-packs are not rolled but the order of each song is preserved.\
  CM, CV and PLI are not real full DLC so they get a special treatment. Since ingame they are all bundled up together, there is
  a right-mouse-button menu where you can toggle each pack individually.\
  Toggling only a few from a category will mark the corresponding checkbox with a '-'.
  
  <img width="400" alt="MainWin" src="https://github.com/user-attachments/assets/574d0b92-4d91-4831-b775-be16c1ea00ce" />
  <img width="400" alt="SubMenuAR" src="https://github.com/user-attachments/assets/86511818-4111-4efe-ae32-0cc07fd9faab" />

  Menu options are always saved by either clicking the 'x' at the top right or clicking the corresponding menu button again.

  K-Modes, difficulties and the star-difficulty slider - you know what they do.\
  Each option is checked against the current available song table and if a combination is impossible,\
  those difficulties will be grayed out. If no song can be rolled due to e.g. most beeing excluded, you will be informed.

  <img width="400" alt="grafik" src="https://github.com/user-attachments/assets/96be46d1-9733-43aa-ab72-3a92bfbe9043" />

  To roll a new chart press either 'F2' or click the button 'Go!'.\
  If a song is rolled and the game is running, the input will be send to the game and the chart is chosen ingame.\
  Otherwise you get a sad message and only the rolled chart is shown.

  One downside is if you play chart after chart you won't see what the randomizer really rolled (it has a 99,X% accuracy).
  For this the keyboard-key 'Numpad+' will minimize the game and show itself and vise-versa.
  You can also use the StreamDeck plugin for maximum comfort!

## EXCLUDING CHARTS
  When you finish playing the chart you have the option to exclude it with 'F4' or by clicking the checkboxs in the main window!\
  This will be written to DJMaxExcludeCharts.db and the chart won't be rolled again (default setting).\
  You have about 3 seconds to undo the change before it gets written by pressing 'F4' or clicking the checkbox.\
  You can do this for practice when reaching e.g. FC or PP or something in between. This list will be preserved as long the song data\
  does not change (e.g. getting a downgrade/upgrade in difficulty or a new SC chart).

  In the Options (general tab) you can even force to roll only charts when the previous difficulty is excluded.\
  So when you start from a fresh file you'll only get NM charts. Excluding them will unlock the HD-chart of that song and so on.\
  
  Very useful for practicing!


## STATS
  Using DJMasExcludeCharts.db as data you will see here which charts are still available and which charts are already excluded.\
  Currently the songnames aren't shown but maybe I'll look into it in the future.

  <img width="400" alt="Stats" src="https://github.com/user-attachments/assets/ad60548d-a262-4d7f-8a1a-ad7f4397c4e0" />

  
## STREAMDECK PLUGIN USAGE

  If you own a StreamDeck (or install the application anyway and use a phone) the randomizer will show everything on 3 tiles
  including songname, DLC group difficulty and star-difficulty.
  
  <img width="1000" alt="grafik" src="https://github.com/user-attachments/assets/72fde7b0-cf5b-40e4-bd35-7e260dd86f1d" />
  <img width="1000" alt="SD_01" src="https://github.com/user-attachments/assets/3bc538de-29d1-4d70-862e-6ba4a0c13cb9" />

  When the StreamDeck is ready and the path to the DJMaxRandomizer.exe is known to the plugin, the middle tile will\
  run the randomizer and at the same time tries to communicate with it. Please make sure the StreamDeck support-option is enabled!
  
  The plugin checks if Administration rights are needed or not and will inform you when something fails.\
  Otherwise if everything is alright the middle tile will have a green checkmark on it and is ready to go.\
  (If the path to the randomizer is not known please start it manually. Afterwards press the middle tile to initiate a connection.)

  Rolling the song now with 'F2' will show every data on the StreamDeck titles.
  
  Of course pressing 'F4' to exclude the chart will be shown too. You'll have roughly 3 seconds to cancel the process by pressing 'F4' again.
  This will be reflected by a 'X' or a checkmark if excluded.
  
  <img width="500" alt="SD_02" src="https://github.com/user-attachments/assets/b4a8e363-84de-47f1-b8ec-399523717e1e" />

  The installation instructions and download links are coming soon.   

  
## KEY FEATURES
  - Extended Filter Options for Songpacks, K-Modes, Chart Difficulty and Star range.
  - Change Keydelay if selected songs are off and don't reflect the rolled song.
  - Exclude charts if you don't need them with F4 or checkbox in main window. Database is updated on program exit.
  - Full StreamDeck support:\
    It shows all rolled song data including stars and if the chart will be excluded.
  - Numpad(+) will bring up the randomizer in foreground to adjust settings.
  - Pressing F2 will roll the song and bring it up in the game.
  - CTRL+F2 will reroll the current rolled song in case the game glitches/brings up the new menu etc...
  
 ## SCREENSHOTS

 <img width="549" alt="MainWin_Success" src="https://github.com/user-attachments/assets/449da714-0166-46b4-bf6b-d07e527a2221" />
 <img width="1000" alt="SD_03" src="https://github.com/user-attachments/assets/debc061c-202c-450c-92f1-f86dd3afc956" />
 <img width="5120" height="1440" alt="grafik" src="https://github.com/user-attachments/assets/8ddc38d8-4c23-4890-98d0-b8db0f337a9a" />





  
