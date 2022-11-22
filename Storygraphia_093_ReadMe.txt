Storygraphia 0.9.3 (released under GNU General Public License version 3 - Vincenzo Lombardo)
21 November 2022

New features:
- Fixed bugs 
- Export to Twine (Harlowe format)
- Reset narrative button


USER MANUAL

Storygraphia is a programme developed in Processing (download at processing.org) that implements the editing and visualization of an interactive story graph. 
Storygraphia provides a GUI for editing a story graph and analyzing the stories that are compiled from it.


DEFINITIONS

A story graph is a graph where nodes are units of the story and edges are transitions over units. A story graph consists of units and connections between units.

A unit is a graph node, consisting of:
- identifier (assigned automatically - but can be modified)
- text (input by the creator, possibly loaded from a text file, one line per node text,
  visualized through layover)
- x,y coordinates assigned through drag 'n drop
- tags (input by the creator) 

Moreover, a unit has associated:
- agents (assigned by the author through keyboard press "a", after selection), 
         visualised with border colors and a reference on the left side
- Propp tag
- tension value (integer between 1-100, to approximate an ideal dramatic arc, displayed in the background)
- states (i.e., preconditions and effects, assigned by the author through menu selection)

A graph edge consists of:
- identifier (assigned automatically - 
              can be modified through keyboard press "i", after selection)
- label (input by the creator, visualized through layover on label - 
         can be modified through keyboard press "l", after selection)


STORYGRAPHIA INTERFACE EDITING MODE
Interface working with mouse and keyboard

START
Select one of three possibilities:
1. Start a new storygraph (blank window)
2. Create a storygraph from a text file (one unit per row)
3. Load a saved storygraph
  3.1 Manual editing (only tags)
  3.2 Propp (functional) tagging (in addition to content tags)
  3.3 Constraints-based editing (preconditions and effects for each unit)
  3.4 Tension value (for dramatic arc approximation in plot generation)


Commands
CREATE A NEW UNIT: keyboard press "u"; unit appears at window center
CREATE A NEW EDGE: 
	select first node (tail); 
        then, press "e";
	then select second node (head); 	
SELECT A UNIT/EDGE: MOUSE click on unit or edge label to select
MOVE A UNIT: mouse drag'n'drop, while keyboard press "m"
DELETE A UNIT/EDGE: after selection of unit/edge, keyboard press "d" (deletion of unit
  causes deletion of all edges connected to it)
MODIFY IDENTIFIER OF A UNIT/EDGE: keyboard press "i"; then, enter new ID
MODIFY TEXT OF A UNIT: keyboard press "t"; then, enter new text
MODIFY LABEL OF AN EDGE: keyboard press "l"; then, enter new label
ADD AGENT TO A UNIT: keyboard press "a"; then, enter agent name
SELECT/ADD TAGS TO A UNIT:
	select node (tag menu appears); 
	check tag boxes required, possibly after creating new tag, through menu item "NEW TAG"
        then, press "g";
SELECT/ADD PRECONDITION/EFFECT TO A UNIT:
	select node (preconditions and effects menus appears); 
	check tag box on men, possibly after creating new tag, through menu item "NEW TAG"
        then, press "g";
INSERT/MODIFY TENSION VALUE: keyboard press "y"; then, enter tension value as integer [1,100]
SAVE A STORYGRAPH: keyboard press "w" and file selection (.json extension)
EXPORT TO TWINE: mouse click on Twine button (top left)
RESET NARRATIVE: mouse click on SG button (top left)
HELP: keyboard press "h"
EXIT: keyboard press "q"

KEYBOARD RESUME
w = write story graph (file xxx.json)
d = delete the node currently selected and all edges connected to it

ZOOM-IN/OUT: keyboard press "+"/"-"
MOVE GRAPH: keyboard press arrows
RESTORE ORIGINAL DISPLAY SIZE: keyboard press "blank space"