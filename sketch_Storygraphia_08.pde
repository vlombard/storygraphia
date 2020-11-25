import controlP5.*; //<>// //<>//
// import processing.net.*;
import static javax.swing.JOptionPane.*; // library for text input 

String storygraphia_license = "credits: Vincenzo Lombardo, released under GNU General Public License version 3";
String graph_name = "NULL";

// ----------- SETUP ----------
void settings() {  
  generic_layout_settings(); // LAYOUT  
  generic_graph_settings(); // GRAPH
  // SPECIFIC SETTINGS
  unit_settings();
  agents_settings();
  tags_settings();
  // propp_settings();
  states_settings();
}

void setup() { 
  // GENERIC SETUP
  agents_setup(); 
  text_setup(); color_setup(); initial_page_setup(); 
  menu_checkbox_setup();
  
  story_specific_setup();
} // end setup

// ----------- DRAW ----------
void draw() {
  background(0, 0, 100); // white background
  draw_agents();
  if (!graph_name.equals("NULL")) {draw_header();}

  pushMatrix();
  translate (xo, yo);
  scale (zoom);
  // if (plot_generation_mode.equals("PROPP")) {propp_layout_bg_matrix();} // Propp background 
  // initialization 
  switch(modality) {
  case "INI": // *********** INITIALIZATION *************
    storygraphia_license_setup();
    initialization_choice(); 
    break;      
  case "PRP": // *********** LAYOUT PREPARATION ************* 
    if (plot_generation_mode.equals("TENSION")) {tension_setup();}    
    modality="EDT";
    break;      
  case "EDT": // *********** EDITING *************
    // nav_edt_choice();
    // DRAWING
    // *** background
    if (plot_generation_mode.equals("PROPP")) {propp_layout_bg_matrix();} // Propp background 
    else if (plot_generation_mode.equals("TENSION")) {tension_layout_bg();}
    // *** draw edges
    for (int i=0; i<i_cur_edge; i++) {edges[i].draw_labelled_edge();}; //draw_labelled_edge(i);}; 
    // *** draw nodes
    for (int i=0; i<i_cur_node; i++) {Unit u = (Unit) nodes[i]; u.draw_unit();} 
    // *** draw agents
    // draw_agents();
    // *** layover
    layover(); agent_layover();
    // *** header
    // if (!graph_name.equals("NULL")) {draw_header();}
    break;
  case "NAV": // *********** NAVIGATING THE GRAPH: TO BE DONE *************
    break;
  } // end SWITCH
  popMatrix();
} // end draw

void storygraphia_license_setup() { 
  // flex_write_lines_in_box(String text, font_type, float font_aspect_ratio, String x_align, String y_align, float x_center, float y_center, float x_width, float y_height)
  flex_write_lines_in_box("STORYGRAPHIA 0.8", default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, y_credits-yo, width-y_credits*2, y_credits);
  flex_write_lines_in_box(storygraphia_license, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, height-y_credits-yo, width-y_credits*2, y_credits);
} 

void mouseClicked() {
  switch(modality) {
  case "INI": 
    story_initialization_go();
    break;
  case "EDT":
    if (mouseX < width-100 && mouseY > vertical_offset &&
        mouseX > horizontal_offset && mouseY < height) {
      // selection of element
      node_edge_selection();
      //if (i_select!=-1) {Unit u = (Unit) nodes[i_select]; u.show_menus();}
    }
    break;
  case "NAV":
    break;
  }
}

void story_specific_setup() {
  propp_setup();
  // propp_checkbox_setup();
  // state_checkbox_setup();
}

void story_initialization_go() {
  // println("story_initialization_go");
  if (start_button.click_rectButton()) {
    modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (init_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storytext"); 
    modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (load_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (manual_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (propp_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "PROPP";
  } else if (constraints_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "CONSTRAINTS";
  } else if (arc_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "TENSION";
  }
}

void story_show_menus() {
  if (i_select!=-1) {
    Unit u;
    switch(plot_generation_mode) {
      case "MANUAL": 
        nodes[i_select].show_tags();
        break;
      case "PROPP": 
        u = (Unit) nodes[i_select];
        u.show_tags();
        u.show_propp_tag();
        break;
      case "CONSTRAINTS": 
        u = (Unit) nodes[i_select];
        u.show_states();
      break;
      case "TENSION": 
        nodes[i_select].show_tags();
        break;
    }
  }
}


void keyPressed() {  
  switch(modality) {
  case "EDT":
    if (key=='w' || key=='W') {
      if (graph_name.equals("NULL")) {graph_name = set_graph_name();}
      selectOutput("Select a file to write to:", "write_storygraph");
      headerStoryCountAndPrint();
    } else if (key=='u') { // create a new unit 
      if (i_select==-1 && i_select2==-1) {
        nodes[i_cur_node++]=new Unit(0, 0, diameter_size, diameter_size, "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, "NULL", "NULL TAG");                                        
      }
    } else if (key=='m') { // move a node
      if (i_move!=-1) {hide_all_menus();} 
    } else if (key=='r') { // STORY SPECIFIC: modify the propp tag of the selected node
      if (i_select!=-1 && i_select2==-1) {
        Unit u = (Unit) nodes[i_select]; u.modify_propp_tag(); // modify the tags through the checkbox
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='s') { // STORY SPECIFIC: modify the (preconditions or effects) states of the selected node
      if (i_select!=-1 && i_select2==-1) {
        Unit u = (Unit) nodes[i_select]; u.modify_preconditions(); u.modify_effects();  // modify the tags through the checkbox
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='y') { // STORY SPECIFIC: modify the tension of the selected node
      if (i_select!=-1 && i_select2==-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select]; u.modify_tension();  // modify the tension through the input dialog
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='a') { // STORY SPECIFIC: add a new agent in a unit 
      if (i_select!=-1 && i_select2==-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select];
        u.add_unit_agent(); 
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; 
      }
    } //else {  
      generic_graph_keyPressed();
    //}      
    break;
  }
}
