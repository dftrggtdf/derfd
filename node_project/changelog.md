# in alpha versions everything is subject to change without warnings
## 0.0.0.1 alp dev
- blank white canvas

## 0.0.0.2 alp dev
- zoom added

## 0.0.0.3 alp dev
- fixed dragging problem

## 0.0.0.4 alp dev
- fixed "physics" dragging problem

## 0.0.0.5 alp dev
- more natural dragging sytem

## 0.0.0.6 alp dev
- fixed dragging reseting after previously being moved

## 0.0.0.7 alp dev
- double left clicking renaming stuff
- right click meniu
    - rename
    - add child (button)
    - delete

## 0.0.0.8 alp dev
- fixed children nodes being buggy
- fixed parent children nodes being buggy
- fixed repetitive deleting issue

## 0.0.0.9 alp dev
- added a line between parent and child
- made the line to follow the parent and child when moved
- added a warning and a confirmation before deleting parent node

## 0.0.0.9_1 alp dev
- fixed adding 2 childs from same parent to act as 1

## 0.0.0.9_2 alp dev
- node lines auto translating position
- when one node moved, rest is moving too (if applies)
- changed font to monospace 10
- added text to be vizible during low zoom

## 0.0.0.9_3 alp dev
- fixed when moving a child doesnt move descendants too
- deleting a child or anything would reset everyone's position to initial
- added ctrl + z to undo
- added ctrl + y to redo

## 0.0.0.9_4 alp dev
- fixed renaming not working to ctrl + z and ctrl + y

## 0.0.1.0.0 alp dev (NOTE NOTE NOTE)
- added save
- added open
- added button to create new mind map
    - *with confirmation if exist modifcations non-saved*
- added dirty state
    - *it knows if theres something not saved*
- ctrl + s to save quickly
- added option to click somewhere else to apply renamed
- fixed bugs
    - 0. note: not all covered, too much
    - 1. opening saved mind maps throws unmatched version error
    - 2. too long names wont fit
    - 3. automatically json type file
- renaming system:
    - click enter -> finishes current renaming
    - click esc -> cancel current renaming
    - click on different node -> finishes current renaming
    - click on white canvas -> finishes current renaming
    - after finishing can be renamed again
    - while in editing cant move node