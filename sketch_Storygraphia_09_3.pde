import controlP5.*; //<>//
// import processing.net.*;
import static javax.swing.JOptionPane.*; // library for text input 

String storygraphia_license = "credits: Vincenzo Lombardo, released under GNU General Public License version 3";
String graph_name = "NULL";
PImage sg_logo, sg_menu, twine_logo;

// ----------- SETUP ----------
void settings() {  
  generic_layout_settings(); // LAYOUT 
  help_settings(); // HELP LAYOUT
  generic_graph_settings(); // GRAPH
  // SPECIFIC SETTINGS
  unit_settings();
  agents_settings();
  tags_settings();
  // propp_settings();
  states_settings();
  sg_logo = loadImage("SG_logo_trasp.png"); // 308x202  
  twine_logo = loadImage("Twine_logo_trasp.png"); // 320x322  
  sg_button = new imgButton(sg_logo, "Reset narrative! Unsaved changes will be lost.", (left_offset/2)/zoom-xo, (top_offset/2)/zoom-yo, left_offset, top_offset);
  twine_button = new imgButton(twine_logo, "Export to Twine (basic Harlowe format)", (1.5*left_offset)/zoom-xo, (top_offset/2)/zoom-yo, left_offset, top_offset);
  sg_menu = loadImage("Storygraphia_menu.png"); // 720x405
}

void setup() { 
  // GENERIC SETUPS
  text_setup(); // text settings
  color_setup(); 
  initial_page_setup(); 
  nav_edt_setup(); 
  // SPECIFIC SETUPS
  generic_graph_setup();
  story_specific_setup();
  menu_checkbox_setup();
} // end setup

// ----------- DRAW ----------
void draw() {
  background(0, 0, 100); // white background
  // draw_agents(); draw_tags();
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
    // DRAWING
    // *** background
    if (plot_generation_mode.equals("PROPP")) {propp_layout_bg_matrix();} // Propp background 
    else if (plot_generation_mode.equals("TENSION")) {tension_layout_bg();}
    else {background(0, 0, 100);} // white background
    if (white_page) {
      flex_write_lines_in_box("Press 'h' for help", default_font_name, default_font_aspect_ratio, 
                              "CENTER", "CENTER", width/2-xo, height-bottom_offset-yo, width-left_offset*2, y_credits);
    }
    draw_agents(); draw_tags();
    // *** header
    if (!graph_name.equals("NULL")) {draw_header();}
    // *** draw edges
    for (int i=0; i<i_cur_edge; i++) {edges[i].draw_labelled_edge();}; //draw_labelled_edge(i);}; 
    // *** draw nodes
    for (int i=0; i<i_cur_node; i++) {
      Unit u = (Unit) nodes[i]; 
      u.draw_unit();
    } 
    // *** layover
    layover(); agent_layover(); tag_layover(); button_layover();
    if (help_b) {display_help();}
    break;
  case "NAV": // *********** NAVIGATING THE GRAPH: TO BE DONE *************
    draw_agents(); draw_tags();
    // *** header
    if (!graph_name.equals("NULL")) {draw_header();}
    // set the cur_nav_unit
    next_node_in_nav();
    // find predecessor and subsequent units
    // set positions for adjacent unit and related edges
    // *** draw edges
    Unit u_cur = (Unit) nodes[cur_nav_node_index];
    for (int i=0; i<i_cur_edge; i++) {
      if ((searchStringIndex(edges[i].tail_id, predecessor_node_ids, 0, i_cur_predecessor)!=-1 && 
          edges[i].head_id.equals(u_cur.id)) ||
          (searchStringIndex(edges[i].head_id, subsequent_node_ids, 0, i_cur_subsequent)!=-1 && 
          edges[i].tail_id.equals(u_cur.id)))
          {
        edges[i].draw_labelled_edge(); 
      }
    }; 
    // draw unit and edges
    for (int i=0; i<i_cur_node; i++) {
      Unit u = (Unit) nodes[i]; 
      if (i == cur_nav_node_index) {u.draw_unit_in_nav("cur");}
      else if (searchStringIndex(u.id, predecessor_node_ids, 0, i_cur_predecessor)!=-1) {
        u.draw_unit_in_nav("pre");}
      else if (searchStringIndex(u.id, subsequent_node_ids, 0, i_cur_subsequent)!=-1) {
        u.draw_unit_in_nav("sub");}
    } 
    // *** layover
    layover_nav(); agent_layover(); tag_layover(); button_layover();
    break;
  } // end SWITCH
  popMatrix();
} // end draw



// *** STORY SPECIFIC INTERACTIVITY

void mouseClicked() {
  switch(modality) {
  case "INI": 
    story_initialization_go();
    break;
  case "EDT":
    // if mouse in the central editing area
    if (mouseX < width-right_offset && mouseY > top_offset &&
        mouseX > left_offset && mouseY < height) {
      // selection of node or edge
      node_selection(); edge_selection();
    } else
    // if mouse in the agent area
    if (mouseX < left_offset && mouseY > top_offset &&
        mouseX > 0 && mouseY < height) {
        agent_selection();
    } else
    // if mouse in the tag area
    if (mouseX < width && mouseY > top_offset &&
        mouseX > width-right_offset && mouseY < height) {
        tag_selection();
    } else
    // if mouse in the NAV/EDT choice area
    if (nav_button.click_rectButton()) {
      nav_edt_go();
    }
    // if mouse in the Twine export area
    if (twine_button.click_imgButton()) {
      twine_button_go(); //<>//
    }
    // if mouse in the Twine export area
    if (sg_button.click_imgButton()) {
      generic_graph_setup();
      menu_checkbox_setup();
      story_specific_setup();
      modality = "INI";
    }
    break;
  case "NAV":
    // if mouse in the NAV/EDT choice area
    if (edt_button.click_rectButton()) {
      nav_edt_go();
    } else
    // if mouse in the central editing area
    if (mouseX < width-right_offset && mouseY > top_offset &&
        mouseX > left_offset && mouseY < height) {
      // selection of edge for advancing in navigation
      edge_selection_nav();
    }
    break;
  }
}


void keyPressed() {  
  switch(modality) {
  case "EDT":
    if (key=='b') { // twine
      selectOutput("Select a file to write to:", "write_twine_graph");
    } else
    if (key=='w') { // || key=='W') {
      if (graph_name.equals("NULL")) {graph_name = set_graph_name(); selectOutput("Select a file to write to:", "write_storygraph");}
      else {write_storygraph(cur_selection);}
      headerStoryCountAndPrint();
    } else if (key == 'z') {
      if (i_select_agent!=-1 && (select_type.equals("AGENT")||select_type.equals("NODE+AGENT"))) {
        i_select_agent=-1; select_type="NULL"; selection_possible = true;  hide_all_menus();}
      if (i_select_node!=-1 && select_type.equals("NODE+AGENT")) {
        nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true;  hide_all_menus();}
      if (help_b) {help_b = false;} // exit from help
    } else if (key=='u') { // create a new unit 
      if (i_select_node==-1) {
        nodes[i_cur_node++]=new Unit(0, 0, diameter_size, diameter_size, "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, "NULL", "NULL TAG");                                        
      }
    } else if (key=='d') { // delete the selected agent
      if (select_type=="AGENT" && i_select_agent!=-1) {
        hide_all_menus(); agents[i_select_agent].delete();
        i_select_agent=-1; select_type="NULL"; selection_possible = true;
      } 
      else if (select_type=="NODE+AGENT" && i_select_node!=-1 && i_select_agent!=-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select_node]; Agent a = agents[i_select_agent];
        u.delete_unit_agent(a.name); 
        nodes[i_select_node].select1 = false; i_select_node=-1; 
        i_select_agent=-1; 
        select_type="NULL"; selection_possible = true; 
      }
    // } else if (key=='m') { // move a node
      //if (select_type!="AGENT" && i_move!=-1) {hide_all_menus();} 
    } else if (key=='r') { // STORY SPECIFIC: modify the propp tag of the selected node
      if (select_type=="NODE" && i_select_node!=-1) {
        Unit u = (Unit) nodes[i_select_node]; u.modify_propp_tag(); // modify the tags through the checkbox
        nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='s') { // STORY SPECIFIC: modify the (preconditions or effects) states of the selected node
      if (select_type=="NODE" && i_select_node!=-1) {
        Unit u = (Unit) nodes[i_select_node]; u.modify_preconditions(); u.modify_effects();  // modify the tags through the checkbox
        nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='y') { // STORY SPECIFIC: modify the tension of the selected node
      if (select_type=="NODE" && i_select_node!=-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select_node]; u.modify_tension();  // modify the tension through the input dialog
        nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } else if (key=='a') { // STORY SPECIFIC: add a new agent in a unit 
      if (select_type=="NODE" && i_select_node!=-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select_node];
        u.add_unit_agent("NULL"); 
        nodes[i_select_node].select1 = false; node_deselection(); // i_select_node=-1; select_type="NULL"; selection_possible = true; 
      } 
      else if (select_type=="NODE+AGENT" && i_select_node!=-1 && i_select_agent!=-1) {
        hide_all_menus();
        Unit u = (Unit) nodes[i_select_node]; Agent a = agents[i_select_agent];
        u.add_unit_agent(a.name); 
        nodes[i_select_node].select1 = false; i_select_node=-1; 
        i_select_agent=-1; 
        select_type="NULL"; selection_possible = true; 
      }
    } else if (key=='t') { // modify the text of the selected agent
      if (select_type=="AGENT" && i_select_agent!=-1) {
        hide_all_menus();
        agents[i_select_agent].modify_name(); // modify the text
        i_select_agent=-1; select_type="NULL"; selection_possible = true; // unselect
      }
    } //else {  
    //}      
    break;
  }
  // println("GENERIC KEYPRESS");
  generic_graph_keyPressed();
}

// *** STORY SPECIFIC SETUP

void storygraphia_license_setup() { 
  // flex_write_lines_in_box(String text, font_type, float font_aspect_ratio, String x_align, String y_align, float x_center, float y_center, float x_width, float y_height)
  imageMode(CENTER); image(sg_logo, width/2-xo, 3*y_credits-yo, sg_logo.width*2*y_credits/sg_logo.height, 2*y_credits);
  flex_write_lines_in_box("STORYGRAPHIA 0.9", default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, y_credits-yo, width-y_credits*2, y_credits);
  flex_write_lines_in_box(storygraphia_license, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", width/2-xo, height-bottom_offset-yo, width-left_offset*2, y_credits);
} 

void story_specific_setup() {
  tags_setup();
  agents_setup(); 
  propp_setup();
}

void story_initialization_go() {
  // println("story_initialization_go");
  if (scratch_button.click_rectButton()) {
    modality="PRP"; plot_generation_mode = "MANUAL"; white_page=true;
  } else if (file_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storytext"); 
    modality="PRP"; plot_generation_mode = "MANUAL";
  //} else if (load_button.click_rectButton()) {
  //  selectInput("Select a file to process:", "load_storygraph"); 
  //  modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (manual_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "MANUAL";
  } else if (propp_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "PROPP";
  } else if (constraints_sculpture_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "CONSTRAINTS"; plot_generation_submode = "SCULPTURE";
  } else if (constraints_painting_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "CONSTRAINTS"; plot_generation_submode = "PAINTING";
  } else if (arc_button.click_rectButton()) {
    selectInput("Select a file to process:", "load_storygraph"); 
    modality="PRP"; plot_generation_mode = "TENSION";
  }
}

void nav_edt_go() {
  // println("nav_edt_go"); //<>// //<>//
  hide_all_menus();
  if (modality.equals("EDT") && edt_button.click_rectButton()) {
    select_start_node_in_nav();
    modality="NAV"; 
  } else if (modality.equals("NAV") && nav_button.click_rectButton()) {
    modality="EDT"; cur_nav_node_index=-1;
  } 
}

void twine_button_go() {
  // println("nav_edt_go"); //<>//
  hide_all_menus();
  if (twine_button.click_imgButton()) {
    selectOutput("Select a file to write to:", "write_twine_graph");
    modality="EDT"; cur_nav_node_index=-1;
  } 
}

void select_start_node_in_nav() {
  if (i_select_node!=-1) {cur_nav_node_index = i_select_node; nodes[i_select_node].select1=false; node_deselection(); } // i_select_node=-1; selection_possible=true; } 
  else {
    boolean cur_nav_node_index_found = false;
    while (!cur_nav_node_index_found) {
      int cur_nav_node_index_proposal = int(random(i_cur_node));
      if (!nodes[cur_nav_node_index_proposal].deleted) {
        cur_nav_node_index=cur_nav_node_index_proposal;
        cur_nav_node_index_found=true;
      }
    }
  }
  nodes[cur_nav_node_index].x_nav=0; nodes[cur_nav_node_index].y_nav=0;
  nodes[cur_nav_node_index].w_nav=actual_height/3; nodes[cur_nav_node_index].h_nav=actual_height/3;
  nodes[cur_nav_node_index].compute_pred_subs();
  float offset = actual_height/i_cur_predecessor;
  for (int i=0; i<i_cur_predecessor; i++) {
    int node_index = searchNodeIdIndex(predecessor_node_ids[i]);
    nodes[node_index].y_nav = (top_offset + i * offset + offset/2)/zoom-yo;
    nodes[node_index].x_nav = (left_offset+actual_width/6)/zoom-xo;
    nodes[node_index].w_nav=diameter_size;
    nodes[node_index].h_nav=diameter_size;
  }
  offset = actual_height/i_cur_subsequent;
  for (int i=0; i<i_cur_subsequent; i++) {
    int node_index = searchNodeIdIndex(subsequent_node_ids[i]);
    nodes[node_index].y_nav = (top_offset + i * offset + offset/2)/zoom-yo;
    nodes[node_index].x_nav = (left_offset+5*actual_width/6)/zoom-xo;
    nodes[node_index].w_nav=diameter_size;
    nodes[node_index].h_nav=diameter_size;
  }
}

void next_node_in_nav() {
  for (int i=0; i<i_cur_node; i++) {
    nodes[i].x_nav=-1; nodes[i].y_nav=-1;
    nodes[i].w_nav=0; nodes[i].h_nav=0;
  }
  for (int i=0; i<i_cur_edge; i++) {
    edges[i].label_x_nav=-1; edges[i].label_y_nav=-1;
  }
  nodes[cur_nav_node_index].x_nav=0; nodes[cur_nav_node_index].y_nav=0;
  nodes[cur_nav_node_index].w_nav=actual_height/3; nodes[cur_nav_node_index].h_nav=actual_height/3;
  nodes[cur_nav_node_index].compute_pred_subs();
  float offset = actual_height/i_cur_predecessor;
  for (int i=0; i<i_cur_predecessor; i++) {
    int node_index = searchNodeIdIndex(predecessor_node_ids[i]);
    nodes[node_index].y_nav = (top_offset + i * offset + offset/2)/zoom-yo;
    nodes[node_index].x_nav = (left_offset+actual_width/6)/zoom-xo;
    nodes[node_index].w_nav=diameter_size;
    nodes[node_index].h_nav=diameter_size;
  }
  offset = actual_height/i_cur_subsequent;
  for (int i=0; i<i_cur_subsequent; i++) {
    int node_index = searchNodeIdIndex(subsequent_node_ids[i]);
    nodes[node_index].y_nav = (top_offset + i * offset + offset/2)/zoom-yo;
    nodes[node_index].x_nav = (left_offset+5*actual_width/6)/zoom-xo;
    nodes[node_index].w_nav=diameter_size;
    nodes[node_index].h_nav=diameter_size;
  }
}

void story_show_menus() {
  if (i_select_node!=-1) {
    Unit u;
    switch(plot_generation_mode) {
      case "MANUAL": 
        nodes[i_select_node].show_tags();
        break;
      case "PROPP": 
        u = (Unit) nodes[i_select_node];
        u.show_tags();
        u.show_propp_tag();
        break;
      case "CONSTRAINTS": 
        u = (Unit) nodes[i_select_node];
        u.show_states();
      break;
      case "TENSION": 
        nodes[i_select_node].show_tags();
        break;
    }
  }
}
