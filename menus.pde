/**
 * ControlP5 Checkbox
 * an example demonstrating the use of a checkbox in controlP5. 
 * CheckBox extends the RadioButton class.
 * to control a checkbox use: 
 * activate(), deactivate(), activateAll(), deactivateAll(), toggle(), getState()
 *
 * find a list of public methods available for the Checkbox Controller 
 * at the bottom of this sketch's source code
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlP5
 *
 */

import controlP5.*; // library for menus (mostly checkboxes used here)

ControlP5 cp5; // major class for menus

CheckBox tags_checkbox; // checkbox for tags (related to nodes)
int i_cur_tag_checkbox = 0; // counter for tag items in the checkbox
String[] cur_node_tags_from_checkbox; // current tags for the currently selected node

void menu_checkbox_setup() {
  cp5 = new ControlP5(this);
  tags_checkbox_setup();
  propp_checkbox_setup();
  state_checkbox_setup();
}

void tags_checkbox_setup() {
  tags_checkbox = cp5.addCheckBox("checkBox")                
                .setPosition(0, 0)
                .setColorForeground(color(0, 50, 100)) // light red
                .setColorActive(color(60, 50, 100)) // light yellow
                .setColorLabel(color(0, 0, 0)) // black for label
                .setSize(int(size_x/30), int(default_font_size))
                .setItemsPerRow(1)
                //.setSpacingColumn(30)
                .setSpacingRow(2)
                .hide();
                //.deactivateAll();
  tags_checkbox.addItem("NEW TAG", 0);
  // i_cur_tag_checkbox = 0;
  cur_node_tags_from_checkbox = new String[max_tags];
  for (int i=0; i<max_tags; i++) {cur_node_tags_from_checkbox[i]="NULL TAG";}
}

CheckBox propp_checkbox;

void propp_checkbox_setup() {
  // println("propp checkbox setup"); 
  propp_checkbox = cp5.addCheckBox("proppBox")                
                .setPosition(0, 0)
                .setColorForeground(color(0, 50, 100)) // light red
                .setColorActive(color(60, 50, 100)) // light yellow
                .setColorLabel(color(0, 0, 0)) // black for label
                .setSize(int(size_x/30), int(default_font_size))
                .setItemsPerRow(1)
                //.setSpacingColumn(30)
                .setSpacingRow(2)
                .hide();
                // .deactivateAll();
  for (int i=0; i<proppTags.length; i++) {propp_checkbox.addItem(proppTags[i], i);
    print (propp_checkbox.getItem(i).getName() + " ");
  }
}


CheckBox preconditions_checkbox, effects_checkbox;
int i_cur_preconditions_checkbox=0; int i_cur_effects_checkbox=0;
// int i_cur_states_checkbox=0;
String[] cur_unit_preconditions_from_checkbox;
String[] cur_unit_effects_from_checkbox;
// String[] cur_unit_states_from_checkbox;

void state_checkbox_setup() {
  preconditions_checkbox = cp5.addCheckBox("preconditionsBox")                
                .setPosition(0, 0)
                .setColorForeground(color(0, 50, 100)) // light red
                .setColorActive(color(60, 50, 100)) // light yellow
                .setColorLabel(color(0, 0, 0)) // black for label
                .setSize(int(size_x/30), int(default_font_size))
                .setItemsPerRow(1)
                //.setSpacingColumn(30)
                .setSpacingRow(2)
                .hide();
                //.deactivateAll();
  effects_checkbox = cp5.addCheckBox("effectsBox")                
                .setPosition(0, 0)
                .setColorForeground(color(0, 50, 100)) // light red
                .setColorActive(color(60, 50, 100)) // light yellow
                .setColorLabel(color(0, 0, 0)) // black for label
                .setSize(int(size_x/30), int(default_font_size))
                .setItemsPerRow(1)
                //.setSpacingColumn(30)
                .setSpacingRow(2)
                .hide();
                //.deactivateAll();
  preconditions_checkbox.addItem("NEW PRECOND", i_cur_preconditions_checkbox); 
  preconditions_checkbox.getItem(i_cur_preconditions_checkbox).getCaptionLabel().alignX(RIGHT)._myPaddingX=preconditions_checkbox.getItem(i_cur_preconditions_checkbox).getWidth();
  effects_checkbox.addItem("NEW EFFECT", i_cur_effects_checkbox);
  // i_cur_state_checkbox = 0; // USELESS???
  cur_unit_preconditions_from_checkbox = new String[max_states];
  cur_unit_effects_from_checkbox = new String[max_states]; 
  for (int i=0; i<max_states; i++) {
    cur_unit_preconditions_from_checkbox[i]="NULL STATE"; 
    cur_unit_effects_from_checkbox[i]="NULL STATE";
  }
}

boolean unique_event = true;

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(tags_checkbox)) {
    print("got an event from "+tags_checkbox.getName()+"\t\n");
    print4check("cur_node_tags_from_checkbox: ", 0, 10, cur_node_tags_from_checkbox);
    initialize_tag_list(cur_node_tags_from_checkbox); 
    print4check("cur_node_tags_from_checkbox: ", 0, 10, cur_node_tags_from_checkbox);
    if (unique_event) {
      unique_event = false;
      int counter = 0; int number_of_items = tags_checkbox.getItems().size();
      for (int j=0; j<number_of_items; j++) {
        if (tags_checkbox.getItem(j).getState()) {
          print("got one true state "+tags_checkbox.getItem(j).getName()+"\t\n");
          if (tags_checkbox.getItem(j).getName().equals("NEW TAG")) {
            cur_node_tags_from_checkbox[counter++] = create_tag();
            tags_checkbox.getItem(j).setState(false);
          } else {
            cur_node_tags_from_checkbox[counter++] = tags_checkbox.getItem(j).getName();
          }
        }
      }
    }
    unique_event = true;
  } // END event from tag_checkbox
  else if (theEvent.isFrom(propp_checkbox)) {
    //print("got an event from "+propp_checkbox.getName()+"\t\n");
    if (unique_event) {
      unique_event = false;
      int number_of_items = propp_checkbox.getItems().size(); int new_propp_tag = -1; 
      if (cur_unit_propp_tag_index == -1) {
        for (int j=0; j<number_of_items; j++) { // for each item of propp checkbox
          if (propp_checkbox.getItem(j).getState()) {cur_unit_propp_tag_index=j;}
        }
      } else {
        for (int j=0; j<number_of_items; j++) { // for each item of propp checkbox
          if (propp_checkbox.getItem(j).getState() && cur_unit_propp_tag_index!=j) {new_propp_tag = j;}
        }
        if (new_propp_tag!=-1) {propp_checkbox.getItem(cur_unit_propp_tag_index).setState(false); cur_unit_propp_tag_index = new_propp_tag;} // if the two numb coincide, set item state to true
        else {cur_unit_propp_tag_index = -1;}
      }
    }
    unique_event = true;
  } // END event from propp_checkbox
  else if (theEvent.isFrom(preconditions_checkbox)) {
    if (unique_event) {
      unique_event = false;
      initialize_state_list(cur_unit_preconditions_from_checkbox);
      print("got an event from "+preconditions_checkbox.getName()+"\t\n");
      int counter = 0; int number_of_items = preconditions_checkbox.getItems().size();
      // print("number_of_items = "+number_of_items+"\t\n");
      for (int j=0; j<number_of_items; j++) {
        if (preconditions_checkbox.getItem(j).getState()) {
          if (preconditions_checkbox.getItem(j).getName().equals("NEW PRECOND")) {
            cur_unit_preconditions_from_checkbox[counter] = create_state();
            preconditions_checkbox.getItem(j).setState(false); // turn NEW PRECOND back to false
            // cur_unit_effects_from_checkbox[counter] = cur_unit_preconditions_from_checkbox[counter];
            // effects_checkbox.getItem(j).setState(false);
            counter++;
          } else {
            cur_unit_preconditions_from_checkbox[counter] = preconditions_checkbox.getItem(j).getName();
            counter++;
          }
        }
      }
    }
    unique_event = true;
  } // END event from preconditions_checkbox
  else if (theEvent.isFrom(effects_checkbox)) {
    if (unique_event) {
      unique_event = false;
      initialize_state_list(cur_unit_effects_from_checkbox);
      print("got an event from "+effects_checkbox.getName()+"\t\n");
      int counter = 0; int number_of_items = effects_checkbox.getItems().size();
      // print("number_of_items = "+number_of_items+"\t\n");
      for (int j=0; j<number_of_items; j++) {
        if (effects_checkbox.getItem(j).getState()) {
          if (effects_checkbox.getItem(j).getName().equals("NEW EFFECT")) {
            cur_unit_effects_from_checkbox[counter++] = create_state();
            effects_checkbox.getItem(j).setState(false);
            // cur_unit_preconditions_from_checkbox[counter] = cur_unit_effects_from_checkbox[counter];
            // preconditions_checkbox.getItem(j).setState(false);
          } else {
            cur_unit_effects_from_checkbox[counter] = effects_checkbox.getItem(j).getName();
            counter++;
          }
        }
      }
    }
    unique_event = true;
  } // END event from effects_checkbox

  // println("exiting controlEvent");    
}

// function that hides all menus (checkboxes)
void hide_all_menus() {
  tags_checkbox.hide();
  propp_checkbox.hide();
  preconditions_checkbox.hide();
  effects_checkbox.hide();
}

void checkBox(float[] a) {
  println(a);
}


/*
a list of all methods available for the CheckBox Controller
use ControlP5.printPublicMethodsFor(CheckBox.class);
to print the following list into the console.

You can find further details about class CheckBox in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.CheckBox : CheckBox addItem(String, float) 
controlP5.CheckBox : CheckBox addItem(Toggle, float) 
controlP5.CheckBox : CheckBox deactivateAll() 
controlP5.CheckBox : CheckBox hideLabels() 
controlP5.CheckBox : CheckBox removeItem(String) 
controlP5.CheckBox : CheckBox setArrayValue(float[]) 
controlP5.CheckBox : CheckBox setColorLabels(int) 
controlP5.CheckBox : CheckBox setImage(PImage) 
controlP5.CheckBox : CheckBox setImage(PImage, int) 
controlP5.CheckBox : CheckBox setImages(PImage, PImage, PImage) 
controlP5.CheckBox : CheckBox setItemHeight(int) 
controlP5.CheckBox : CheckBox setItemWidth(int) 
controlP5.CheckBox : CheckBox setItemsPerRow(int) 
controlP5.CheckBox : CheckBox setNoneSelectedAllowed(boolean) 
controlP5.CheckBox : CheckBox setSize(PImage) 
controlP5.CheckBox : CheckBox setSize(int, int) 
controlP5.CheckBox : CheckBox setSpacingColumn(int) 
controlP5.CheckBox : CheckBox setSpacingRow(int) 
controlP5.CheckBox : CheckBox showLabels() 
controlP5.CheckBox : String getInfo() 
controlP5.CheckBox : String toString() 
controlP5.CheckBox : Toggle getItem(int)
controlP5.CheckBox : List getItems()
controlP5.CheckBox : boolean getState(String) 
controlP5.CheckBox : boolean getState(int) 
controlP5.CheckBox : void updateLayout() 
controlP5.ControlGroup : CheckBox activateEvent(boolean) 
controlP5.ControlGroup : CheckBox addListener(ControlListener) 
controlP5.ControlGroup : CheckBox hideBar() 
controlP5.ControlGroup : CheckBox removeListener(ControlListener) 
controlP5.ControlGroup : CheckBox setBackgroundColor(int) 
controlP5.ControlGroup : CheckBox setBackgroundHeight(int) 
controlP5.ControlGroup : CheckBox setBarHeight(int) 
controlP5.ControlGroup : CheckBox showBar() 
controlP5.ControlGroup : CheckBox updateInternalEvents(PApplet) 
controlP5.ControlGroup : String getInfo() 
controlP5.ControlGroup : String toString() 
controlP5.ControlGroup : boolean isBarVisible() 
controlP5.ControlGroup : int getBackgroundHeight() 
controlP5.ControlGroup : int getBarHeight() 
controlP5.ControlGroup : int listenerSize() 
controlP5.ControllerGroup : CColor getColor() 
controlP5.ControllerGroup : CheckBox add(ControllerInterface) 
controlP5.ControllerGroup : CheckBox bringToFront() 
controlP5.ControllerGroup : CheckBox bringToFront(ControllerInterface) 
controlP5.ControllerGroup : CheckBox close() 
controlP5.ControllerGroup : CheckBox disableCollapse() 
controlP5.ControllerGroup : CheckBox enableCollapse() 
controlP5.ControllerGroup : CheckBox hide() 
controlP5.ControllerGroup : CheckBox moveTo(ControlWindow) 
controlP5.ControllerGroup : CheckBox moveTo(PApplet) 
controlP5.ControllerGroup : CheckBox open() 
controlP5.ControllerGroup : CheckBox registerProperty(String) 
controlP5.ControllerGroup : CheckBox registerProperty(String, String) 
controlP5.ControllerGroup : CheckBox remove(CDrawable) 
controlP5.ControllerGroup : CheckBox remove(ControllerInterface) 
controlP5.ControllerGroup : CheckBox removeCanvas(ControlWindowCanvas) 
controlP5.ControllerGroup : CheckBox removeProperty(String) 
controlP5.ControllerGroup : CheckBox removeProperty(String, String) 
controlP5.ControllerGroup : CheckBox setAddress(String) 
controlP5.ControllerGroup : CheckBox setArrayValue(float[]) 
controlP5.ControllerGroup : CheckBox setColor(CColor) 
controlP5.ControllerGroup : CheckBox setColorActive(int) 
controlP5.ControllerGroup : CheckBox setColorBackground(int) 
controlP5.ControllerGroup : CheckBox setColorForeground(int) 
controlP5.ControllerGroup : CheckBox setColorLabel(int) 
controlP5.ControllerGroup : CheckBox setColorValue(int) 
controlP5.ControllerGroup : CheckBox setHeight(int) 
controlP5.ControllerGroup : CheckBox setId(int) 
controlP5.ControllerGroup : CheckBox setLabel(String) 
controlP5.ControllerGroup : CheckBox setMouseOver(boolean) 
controlP5.ControllerGroup : CheckBox setMoveable(boolean) 
controlP5.ControllerGroup : CheckBox setOpen(boolean) 
controlP5.ControllerGroup : CheckBox setPosition(PVector) 
controlP5.ControllerGroup : CheckBox setPosition(float, float) 
controlP5.ControllerGroup : CheckBox setStringValue(String) 
controlP5.ControllerGroup : CheckBox setUpdate(boolean) 
controlP5.ControllerGroup : CheckBox setValue(float) 
controlP5.ControllerGroup : CheckBox setVisible(boolean) 
controlP5.ControllerGroup : CheckBox setWidth(int) 
controlP5.ControllerGroup : CheckBox show() 
controlP5.ControllerGroup : CheckBox update() 
controlP5.ControllerGroup : CheckBox updateAbsolutePosition() 
controlP5.ControllerGroup : ControlWindow getWindow() 
controlP5.ControllerGroup : ControlWindowCanvas addCanvas(ControlWindowCanvas) 
controlP5.ControllerGroup : Controller getController(String) 
controlP5.ControllerGroup : ControllerProperty getProperty(String) 
controlP5.ControllerGroup : ControllerProperty getProperty(String, String) 
controlP5.ControllerGroup : Label getCaptionLabel() 
controlP5.ControllerGroup : Label getValueLabel() 
controlP5.ControllerGroup : PVector getPosition() 
controlP5.ControllerGroup : String getAddress() 
controlP5.ControllerGroup : String getInfo() 
controlP5.ControllerGroup : String getName() 
controlP5.ControllerGroup : String getStringValue() 
controlP5.ControllerGroup : String toString() 
controlP5.ControllerGroup : Tab getTab() 
controlP5.ControllerGroup : boolean isCollapse() 
controlP5.ControllerGroup : boolean isMouseOver() 
controlP5.ControllerGroup : boolean isMoveable() 
controlP5.ControllerGroup : boolean isOpen() 
controlP5.ControllerGroup : boolean isUpdate() 
controlP5.ControllerGroup : boolean isVisible() 
controlP5.ControllerGroup : boolean setMousePressed(boolean) 
controlP5.ControllerGroup : float getValue() 
controlP5.ControllerGroup : float[] getArrayValue() 
controlP5.ControllerGroup : int getHeight() 
controlP5.ControllerGroup : int getId() 
controlP5.ControllerGroup : int getWidth() 
controlP5.ControllerGroup : void remove() 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 


*/
