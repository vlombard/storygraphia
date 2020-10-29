import processing.net.*; //<>// //<>//
import static javax.swing.JOptionPane.*;

String storygraphia_license = "credits: Vincenzo Lombardo, released under GNU General Public License version 3";
String graph_name = "NULL";

// ----------- SETUP ----------
void settings() {  
  generic_layout_settings(); // LAYOUT  
  generic_graph_settings(); // GRAPH
  // SPECIFIC SETTINGS
  unit_settings();
  agents_settings();
}

void setup() { 
  // GENERIC SETUP
  agents_setup(); 
  text_setup(); color_setup(); initial_page_setup();  
} // end setup

// ----------- DRAW ----------
void draw() {
  background(0, 0, 100); // white background 
  draw_agents();
  if (!graph_name.equals("NULL")) {draw_header();}
  translate (xo, yo);
  scale (zoom);

  // initialization 
  switch(modality) {
  case "INI": // *********** INITIALIZATION *************
    storygraphia_license_setup();
    initialization_choice(); 
    break;      
  case "EDT": // *********** EDITING *************
    // nav_edt_choice();
    // DRAWING
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
} // end draw

void storygraphia_license_setup() { 
  // flex_write_lines_in_box(String text, font_type, float font_aspect_ratio, String x_align, String y_align, float x_center, float y_center, float x_width, float y_height)
  flex_write_lines_in_box("STORYGRAPHIA 0.7", default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, y_credits-yo, width-y_credits*2, y_credits);
  flex_write_lines_in_box(storygraphia_license, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, height-y_credits-yo, width-y_credits*2, y_credits);
} 

void mouseClicked() {
  switch(modality) {
  case "INI": 
    story_initialization_go();
    break;
  case "EDT":
    // selection of element
    node_edge_selection();
    break;
  case "NAV":
    break;
  }
}

void story_initialization_go() {
    if (start_button.click_rectButton()) {
      modality="EDT";
    } else if (init_button.click_rectButton()) {
      selectInput("Select a file to process:", "load_storytext"); 
      modality="EDT";
    } else if (load_button.click_rectButton()) {
      selectInput("Select a file to process:", "load_storygraph"); 
      modality="EDT";
    }
}
void keyPressed() {  
  switch(modality) {
  case "EDT":
    if (key=='w' || key=='W') {
      if (graph_name.equals("NULL")) {graph_name = set_graph_name();}
      selectOutput("Select a file to write to:", "write_storygraph");
    } else if (key=='u') { // create a new unit 
      if (i_select==-1 && i_select2==-1) {
        nodes[i_cur_node++]=new Unit(0, 0, diameter_size, diameter_size, "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, "NULL", "NULL");                                        
      }
    } else if (key=='a') { // add a new agent in a unit 
      if (i_select!=-1 && i_select2==-1) {
        Unit u = (Unit) nodes[i_select];
        u.add_unit_agent(); 
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL";
      }
    } else {  
      generic_graph_keyPressed();
    }      
    break;
  }
}
