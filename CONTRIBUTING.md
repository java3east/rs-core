# Rules
If you want to contribute please follow the given rules, to keep this repository clean, bug free and with good performance.  
Pull requests which don't follow the set rules, will not be merged into the main branch and will not be released until
set rules are followed. If your code dosn't match those standards the person reviewing your code will kindly advice you
to make changes to your code.

## File structure
### Index.lua
The Index.lua file should only be used to initialize new modules and classes and should not contain any functional content. 
For most changes you won't have to touch this file!

### Folder & file names
- Folder names should have a capital letter at the begining of each new word. There should be no underscores, numbers or spaces
in their names, they should only contain upper and lowercase letters.  
- The name of the file should be the same as the name of the containing class.
- Modules that belong to another module (e.g. a character belongs to a player) should be located in the folder of the parent module
  (e.g. the folder 'Character' should be in the folder 'Player')  
- Only Modules which are exactly the same for Client and Server should be located in the Shared folder and if they are they also should be
  (no code duplication!)

## Coding Style
### TODO

## Tests
### TODO
