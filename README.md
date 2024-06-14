# Project Zomboid Server Save Manager (PZSSM)

### A little tool to manage server saves between different hosts.

> [!IMPORTANT]
> This tool is still being tested and I'm trying to improve its features. By default, all data that could be overwritten will be renamed or moved to a backup folder before deleting it.

## 1. Setup the file correctly

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
Stores the name of the server. This value should be the name you find either in the **Host** page inside the game or as the title of a `.ini` file in the `~/Zomboid/Server` folder. Looking at the pictures below, the `server_name` variable would be **Amiguis** without quotes.  
<br>  
![image](https://github.com/pabloherresp/PZ-Server-Save-Manager/assets/16340577/27888743-bbf4-4fe1-917c-f7a36251434c)

- ### `def_zomboid_loc`
Stores the name of the folder PZ loads the data from. By default, it should be a folder named Zomboid inside your user 



## 2. Project Zomboid Server files and folders to talk about.
(Feel free to comment on any missing file you might be 
