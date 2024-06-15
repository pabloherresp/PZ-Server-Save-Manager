# Project Zomboid Server Save Manager (PZSSM)

### A little tool to manage server saves between different hosts in Windows.

> [!IMPORTANT]
> This tool is still being tested and I'm trying to improve its features. By default, all data that could be overwritten will be renamed or moved to a backup folder before deleting it.

> [!NOTE]
> You don't need to close the game in order to let this program manage files, you can stay in the main menu.

## 1. File setup

The first time you try to execute the program, you might be prompted to do the initial setup.  
You can **edit** this file with the notepad as a text file.  
The variables you need to edit are in the first lines of code:
```batch
set server_name=
set def_zomboid_loc=%USERPROFILE%\Zomboid
set def_zip_loc=%USERPROFILE%\Downloads
set url="" 
set backup_option=1
```
- ### `server_name`
Stores the name of the server. This value should be the name you find either in the **Host** page inside the game or as the title of a `.ini` file in `~/Zomboid/Server` inside your user folder. Looking at the pictures below, the `server_name` variable would be **Amiguis** without quotes.  
  
![image](https://github.com/pabloherresp/PZ-Server-Save-Manager/assets/16340577/27888743-bbf4-4fe1-917c-f7a36251434c)

- ### `def_zomboid_loc`
Stores the location of the folder PZ loads the data from. By default, it should be a folder named Zomboid inside your user folder. You can use the shortcut `Windows key + R` and paste `%USERPROFILE%` in order to open your user folder.
Program might fail if there are spaces in the folder name.

- ### `def_zip_loc`
Stores the location of the folder where ZIPs files will be saved, and where downloaded ZIPs will be loaded from. By default, the `Downloads` folder is used as it's easy to find and access. Program might fail if there are spaces in the folder name.

- ### `url`
Stores the url where you and your friends will share the ZIPs files, for example, a shared Google Drive folder. This value can be left empty, if done so, the option to open the link won't appear in the selection prompt.

- ### `backup_option`
Decide if backups of files are done before overwriting them. 1 = true, 0 = false. True by default.

## 2. How to use
You can run this script by selecting it and pressing `Enter`, or by doing right click and look for `Run`.
When prompted to choose an option, write the number of the action you wish to do.
```
- OPTIONS -
. . 1 to SAVE a new zip file
. . 2 to LOAD from a existing zip file
. . 3 to OPEN zip file folder
. . 4 to FIX map files for a server
. . 5 to OPEN url link (optional)
. . 0 to CLOSE the program
```

#### 2.1. Save A new zip file

This option creates a ZIP file in the location defined in `def_zip_loc` (Downloads by default). The name of the ZIP will be the current date and time, followed by the word `_PZ_Server_` and finally, the name of the server.

#### 2.2. Load from a existing zip file

This option will list all the zips in the folder `def_zip_loc` that match all the files that end in `_PZ_server_%server_name%.zip` where `%server_name%` is the name of your server.

#### 2.3. Open zip file folder

This option will open the folder `def_zip_loc` so you can access quickily after saving a new zip file.

#### 2.4. Fix missing map files for a server. Read with caution!
<img align="right" width="200" src="https://github.com/pabloherresp/PZ-Server-Save-Manager/assets/16340577/990a1ec8-ac90-4196-bbfd-0c9d1f822bfe">  
<p>One of the hardest parts to work with, the ingame map, the one you open when pressing `M`, is stored on the player files instead of server side. You store the zones you've discovered and the symbols you've written in your computer as a client. So when the same server is hosted from a different computer, a new folder with a different name is created referencing this new host, and the map seems to be empty as the data can't be read from the previous folder.</p>

> [!NOTE]
> Fixing this is a client side action, all players wanting to get the maps back have to perform this action with the program.

The only way to make this option work is knowing the two folders whose files need to be moved. These folders are found inside the `~/Zomboid/Saves/Multiplayer` folder, they are named with the SteamID of the player who hosted the game  (if the server has been hosted from the host option in the main menu while playing from Steam) or an IP (if a dedicated server has been used) followed by the server name and the `_player` suffix, unless you are the one who hosted the game, in this case there won't be any SteamID or IP, the folder will be named with just the server name and the suffix `_player`. (You can use [this web](https://www.steamidfinder.com/) to see if the SteamID belongs to one of your friends who has hosted)  
\
When selecting this option, all the folders that match the pattern for the desired server name will be listed and you will be prompted to select two of them. First, you will choose the folder whose maps you will play with, and then, the folder whose maps will be overwritten. It is important to note that these folders MUST exist before using it, so you need to join the new host at least once before trying to fix the maps if you've never joined.  

<details>
<summary>${\textsf{\color{lightgreen}Example of using this feature}}$</summary>
  
Let's see an example, if you are 3 friends, `A, B and C`, with `SteamIDs 001, 002 and 003` respectively (Real IDs are actually longer), playing in a server called `Elephant`, let's say A hosts the first day and all three players join.  

He suddenly can't play the next day, so he uses this program to create a save and sends it to B. Now B uses the program to load the zip he received and can host the server from the Host option in the game. Both B and C join the server and they can check the discovered ingame map and the symbols has been lost so they both leave the game. At this moment, B would use the program again, select this option and choose the folder of the previous host (A) called `001_Elephant_player` and overwrite the files inside his own host folder `Elephant_player`. Player C will firstly choose the same folder of the previous host (A) and then the folder for the new host (B), `002_Elephant_player`. Then both can join the game with the map as they had it the first day. They finish playing and B creates a new zip in order to share it with A for the next day.  

This time A uses the program to load the ZIP from B. A doesn't need to fix maps as his map hasn't updated since the first day. B needs to use the program using the maps from `Elephant_player` (his own host folder) and overwrite `001_Elephant_player` (the folder when A hosts), this folder already exists as it's the one B used the first day, he doesn't need to join once before fixing maps as B and C had to do the second day. Finally, C needs to do the same as B but using `002_Elephant_player` as his first folder (the folder when B hosts), and overwrite the folder when A hosts, he already have both folders as B so he can do it before joining once.  

</details>

##### (I know this option to fix maps is really confusing and I've tried to explain the process and issues the best I could, any problem you have while trying it can be sorted out as no files are deleted, all files that could be overwritten are renamed using the date and time in which the fix was attempted.)

#### 2.5. Open url link (Optional)
This option will only appear if a url has been set in the variables section. This option will open the url in your browser.

## 3. Get the backup files back

Any time you load a zip, the folders that would be overwritten are moved to a new folder inside `~/Zomboid/backups`, this folder will be named with the current date and time followed by the suffix `_backup`. If you want to restore a backup, you just need to copy the 3 folders `db, Saves and Server` inside this folder to the Zomboid folder, you will be asked to overwrite files.  
<br>
The map files that are backed up when trying to fix missing maps `map_visited.bin and map_symbols.bin` are only renamed adding `_backup_` and the date at the end of the name, so you just need to delete or rename the previous file and then renove the part of the name that was added to the files you want to restore so they are called `map_visited.bin and map_symbols.bin` again.

## 4. Some knowledge about Project Zomboid folders and files
(Feel free to comment on any missing file you might find)

# Work in progress.
