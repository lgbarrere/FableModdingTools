=== User Guide ===
Authored by Yaranorgoth

This guide helps users understand the purpose of the script.
The script was first created by an unknown person, then entirely reworked.
This project is designed to make all modding setups easier.

Fable Anniversary is harder to mod than Fable - The Lost Chapters.
However, it can use the same modding tools thanks to a symlink.
The script allows to make a symlink FTLC <<===>> FA.
Then, the FTLC modding tools "ChocolateBox" and "Fable Explorers" can be used for FA.
It is recommended to learn these tools with dedicated FTLC guides.

== Requirements
Having a legal copy of the games:
- Fable - The Lost Chapters
- Fable Anniversary

== Start of script
The script must be launched in Admin mode to work properly.
Otherwise, the console text is colored red and a request to change the mode appears.

== Configurations
Once FTLC and FA paths are set, they are saved in the "config" folder and loaded at script start.
It is recommended to configure the paths using the "Main Menu" (see section below).

== Main Menu
The Main Menu is composed by 4 sections:
- Fable logo: It is just aesthetic
- Fable games paths: Necessary paths to FTLC and FA games folders
- The options: List of tasks the user can execute
- User input: Area to input to choose an option

It is highly recommended to execute all options in order from "MOD SETUP OPTIONS TO USE IN ORDER".
A number must be typed (among the visible ones to the left), then press enter to validate the choice.
1) Set directories: Redirect to another menu (using the same logic) to set FTLC and FA folders
2) Enable mods: Become owner, grant rights and remove "Read-Only" of Fable games to let mods modify files
3) Backup Fable TLC: Make a "Fable - TLC" backup using the "Fable TLC location" path (erased if existing)
4) Make FTLC-FA symlink: Make a symlink to pretend "FableAlbion" from FTLC exists, but is located in FA

Some extra options can be used to help the user, to select from "EXTRA OPTIONS".
A letter must be typed (among the visible ones to the left), then press enter to validate the choice.
D) Load default directories: Try to set FTLC and FA automatically
C) Launch ChocolateBox: Execute the modding tool "ChocolateBox"
E) Launch Fable Explorer: Execute the modding tool "Fable Explorer"
Q) Quit: Close the script
