// INTERACTIVITY GLOBAL VARIABLES
int flash_iter=0; // flash iteration
int flash_iter_up=1; // direction tion
// String registry_data = "NULL";
int i_move=-1; 
int i_select_node=-1; color select_color;
int i_select_edge=-1; 
boolean select2=false; 
String select_type = "NULL"; // type of current selection
String modality ="INI";
String plot_generation_mode = "MANUAL";
String plot_generation_submode = "MANUAL";
// HELP RECTANGLE
String[] help_lines;
boolean help_b = false;
float help_width, help_height;
// LAYOUT CONDITIONS
boolean white_page;
// INTERACTIVITY CONDITIONS
boolean display_b = false;


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% INITIALIZATION 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

String start = "Start a new graph";
String scratch = "from scratch (white page)"; String file = "from text file (one unit per row)"; 
// String init = "Init graph nodes from text file"; 
String load = "Load a saved graph";
String manual = "Manual (default)"; String propp = "Propp categories + tags"; 
String pe_constraints_sculpture = "PRECOND-EFFECT constraints (SCULPTURE)"; String pe_constraints_painting = "PRECOND-EFFECT constraints (PAINTING)"; 
String dramatic_arc = "Dramatic arc (tension value)";

rectButton start_button, init_button, load_button, 
           scratch_button, file_button, 
           manual_button, propp_button, constraints_sculpture_button, constraints_painting_button, arc_button;

void initial_page_setup() { 
  float button_height = 2*default_font_size;
  float start_width = start.length()*default_font_size*default_font_aspect_ratio+margin;
  textAlign(CENTER, CENTER); fill(text_color); textSize(default_font_size); 
  text(start, (width/2-margin-start_width/2)*zoom-xo, (2*height/6-5*default_font_size)*zoom-yo);
  // start_button = new rectButton("start_button", start, 
    // (width/2-margin-start_width/2)*zoom-xo, (2*height/6-5*default_font_size)*zoom-yo, 
    // start_width, button_height, color(100), text_color, default_font_size); 
  //start_button = new rectButton("start_button", start, 
  //  (width/2-margin-start_width/2)*zoom-xo, (2*height/6-5*default_font_size)*zoom-yo, 
  //  start_width, button_height, color(45, 20, 100), text_color, default_font_size); 
  float scratch_width = scratch.length()*default_font_size*default_font_aspect_ratio+margin;
  scratch_button = new rectButton("scratch_button", scratch, 
    (width/2+margin+scratch_width/2)*zoom-xo, (2.5*height/6-5*default_font_size)*zoom-yo, 
    scratch_width, button_height, color(45, 20, 100), text_color, default_font_size); 
  // float init_width = init.length()*default_font_size*default_font_aspect_ratio+margin;
  // init_button = new rectButton("init_button", init, 
    // (width/2-margin-init_width/2)*zoom-xo, (3*height/6-5*default_font_size)*zoom-yo, 
    // init_width, button_height, color(45, 40, 100), text_color, default_font_size);
  float file_width = file.length()*default_font_size*default_font_aspect_ratio+margin;
  file_button = new rectButton("file_button", file, 
    (width/2+margin+file_width/2)*zoom-xo, (3*height/6-5*default_font_size)*zoom-yo, 
    file_width, button_height, color(45, 40, 100), text_color, default_font_size);
  //float load_width = load.length()*default_font_size*default_font_aspect_ratio+margin;
  //load_button = new rectButton("load_button", load, 
  //  (width/2-margin-load_width/2)*zoom-xo, (4*height/6-5*default_font_size)*zoom-yo, 
  //  load_width, button_height, color(45, 60, 90), text_color, default_font_size);
  float manual_width = manual.length()*default_font_size*default_font_aspect_ratio+margin;
  manual_button = new rectButton("manual_button", manual, 
    (width/2+margin+manual_width/2)*zoom-xo, (4*height/6-5*default_font_size)*zoom-yo, 
    manual_width, button_height, color(45, 20, 100), text_color, default_font_size); 
  float propp_width = propp.length()*default_font_size*default_font_aspect_ratio+margin;
  propp_button = new rectButton("propp_button", propp, 
    (width/2+margin+propp_width/2)*zoom-xo, (9*height/12-5*default_font_size)*zoom-yo, 
    propp_width, button_height, color(45, 40, 100), text_color, default_font_size);
  float pe_constraints_sculpture_width = pe_constraints_sculpture.length()*default_font_size*default_font_aspect_ratio+margin;
  constraints_sculpture_button = new rectButton("constraints_sculpture_button", pe_constraints_sculpture, 
    (width/2+margin+pe_constraints_sculpture_width/2)*zoom-xo, (10*height/12-5*default_font_size)*zoom-yo, 
    pe_constraints_sculpture_width, button_height, color(45, 60, 90), text_color, default_font_size);
  float pe_constraints_painting_width = pe_constraints_sculpture.length()*default_font_size*default_font_aspect_ratio+margin;
  constraints_painting_button = new rectButton("constraints_painting_button", pe_constraints_painting, 
    (width/2+3*(margin+pe_constraints_painting_width/2))*zoom-xo, (10*height/12-5*default_font_size)*zoom-yo, 
    pe_constraints_painting_width, button_height, color(45, 60, 90), text_color, default_font_size);
  float dramatic_arc_width = dramatic_arc.length()*default_font_size*default_font_aspect_ratio+margin;
  arc_button = new rectButton("arc_button", dramatic_arc, 
    (width/2+margin+dramatic_arc_width/2)*zoom-xo, (11*height/12-5*default_font_size)*zoom-yo, 
    dramatic_arc_width, button_height, color(45, 80, 90), text_color, default_font_size);
}

void initialization_choice() {
  // rectMode(RIGHT);
  // start_button.draw_rectButtonCenter();
  float start_width = start.length()*default_font_size*default_font_aspect_ratio+margin;
  textAlign(CENTER, CENTER); fill(text_color); textSize(default_font_size); 
  text(start, (width/2-margin-start_width/2)*zoom-xo, (2.5*height/6-5*default_font_size)*zoom-yo);
  scratch_button.draw_rectButtonCenter();
  // init_button.draw_rectButtonCenter();
  file_button.draw_rectButtonCenter();
  float load_width = load.length()*default_font_size*default_font_aspect_ratio+margin;
  textAlign(CENTER, CENTER); fill(text_color); textSize(default_font_size); 
  text(load, (width/2-margin-load_width/2)*zoom-xo, (4*height/6-5*default_font_size)*zoom-yo);
  // load_button.draw_rectButtonCenter();
  manual_button.draw_rectButtonCenter();
  propp_button.draw_rectButtonCenter();
  constraints_sculpture_button.draw_rectButtonCenter();
  constraints_painting_button.draw_rectButtonCenter();
  arc_button.draw_rectButtonCenter();
}

//// rectButton(String i, String t, float xc, float yc, float xw, float yh, color c)
rectButton nav_button, edt_button;
String nav_text = "NAV"; String edt_text = "EDT";

void nav_edt_setup() { // nav/edt button goes on the top-right corner 
  float button_height = top_offset;
  float button_width = right_offset;
  // String[] split_string_into_lines (String s, float line_size)
  String[] lines = split_string_into_lines (nav_text, button_width); 
  float font_size = determine_font_size(lines, default_font_aspect_ratio, button_width, button_height);
  nav_button = new rectButton("nav_button", nav_text, 
    (width - right_offset/2)/zoom-xo, (top_offset/2)/zoom-yo, 
    button_width, button_height, nav_edt_color, select_text_color, font_size); 
  lines = split_string_into_lines (edt_text, button_width);
  font_size = determine_font_size(lines, default_font_aspect_ratio, button_width, button_height);
  edt_button = new rectButton("edt_button", edt_text, 
    (width - right_offset/2)/zoom-xo, (top_offset/2)/zoom-yo, 
    button_width, button_height, nav_edt_color, select_text_color, font_size); 
}

imgButton sg_button, twine_button, twine_banner_button;;

void update_flash_iter() { 
  if (flash_iter==0) {flash_iter++; flash_iter_up=1;};
  if (flash_iter==1 && flash_iter_up==1) {flash_iter++;};
  if (flash_iter==1 && flash_iter_up==0) {flash_iter--;};
  if (flash_iter==2 && flash_iter_up==1) {flash_iter++;};
  if (flash_iter==2 && flash_iter_up==0) {flash_iter--;};
  if (flash_iter==3 && flash_iter_up==1) {flash_iter++;};
  if (flash_iter==3 && flash_iter_up==0) {flash_iter--;};
  if (flash_iter==4) {flash_iter--; flash_iter_up=0;};
}

void flashing_ellipse (float x, float y, float r) {
  update_flash_iter();
  ellipse(x*zoom-xo, y*zoom-yo, r+margin*flash_iter, r+margin*flash_iter);
  // pop.play(); // sound
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% MOUSE SELECTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class Selection { // class for the selection of entities
  String select_type; // can be node or edge
  int select_index; // index of selection in the set of nodes or edges, respectively
  
  Selection(String t, int i) {
    select_type=t; select_index=i;
  }
}

// select the nearest node or edge label to x,y coordinates
Selection select_node_or_edge_index_at_min_distance(float x, float y, String type_required) {
  Selection select_aux = new Selection("NULL", -1);
  if (type_required.equals("NODE_OR_EDGE")) {
    // println("selecting node or edge"); //<>//
    if (y > y_credits) {
      float min_distance=size_x+1; 
      for (int i=0; i<i_cur_node; i++) { // for each node, compute the block distance and update min_distance
        if (!nodes[i].deleted) {
          //float diff_x=abs(nodes[i].x - x);  float diff_y=abs(nodes[i].y - y);
          float diff_x=abs(nodes[i].x*zoom+xo - x);  float diff_y=abs(nodes[i].y*zoom+yo - y);
          if ((diff_x + diff_y) < min_distance && (diff_x + diff_y) < diameter_size) { // if min_distance changes
            min_distance = diff_x + diff_y;
            select_aux.select_index=i;  select_aux.select_type="NODE";
          }; // end if min_distance changes
        }; // end if NOT DELETED
      }; // end for
      for (int i=0; i<i_cur_edge; i++) { // for each edge, compute the block distance and update min_distance
        if (!edges[i].deleted) {
          edges[i].label_coordinates();
          float diff_x=abs(edges[i].label_x*zoom+xo - x);  float diff_y=abs(edges[i].label_y*zoom+yo - y);
          if ((diff_x + diff_y) < min_distance && (diff_x + diff_y) < diameter_size) {
            min_distance = diff_x + diff_y;
            select_aux.select_index=i;  select_aux.select_type="EDGE";
          }; // end if min_distance changes
        }; // end if NOT DELETED
      }; // end for
      // println("selected type: " + select_aux.select_type + "; selected index " + select_aux.select_index);
    }
  }
  return select_aux;
}

boolean selection_possible = true;
boolean creating_edge = false;

void node_selection() {
  if (selection_possible) {
    Selection i_select_aux = select_node_or_edge_index_at_min_distance(mouseX, mouseY, "NODE_OR_EDGE"); // select something
    if (i_select_aux.select_type.equals("NODE")) { // if clicking on a node
      if (select_type.equals("NODE")) { // if previous selection is node too
        if (i_select_node!=-1 && creating_edge) { // if no selection 2 and creating an edge (after "e") 
          hide_all_menus();
          int i_select_node2=i_select_aux.select_index; // SELECT NODE 2, second node
          edges[i_cur_edge]=new Edge(nodes[i_select_node2].id, nodes[i_select_node].id, "e"+str(i_cur_edge), "NULL"); // create edge
          i_cur_edge++; num_edges++; // increment edge counter
          // nodes[i_select_node].select1=false; i_select_node=-1; // deselect node 1
          node_deselection();
          select_type="NULL"; creating_edge = false;
        }
      } else // previous selection type is NOT NODE
      if (select_type.equals("NULL")) { // if previous selection is NULL
        if (i_select_node==-1) { // if no node selected before
          i_select_node=i_select_aux.select_index; nodes[i_select_node].select1=true; select_type="NODE"; // SELECT NODE 1, first node
          selection_possible = false;
          story_show_menus();
        }
      } else // previous selection type is NOT NODE and NOT NULL, 
      if (select_type.equals("EDGE")) { // if current selection is EDGE
        edges[i_select_edge].select=false;  // change from edge to node selection
        i_select_node=i_select_aux.select_index; nodes[i_select_node].select1=true; 
        select_type="NODE"; selection_possible = false; 
      } 
    } 
  } // END selection possible
}

void node_deselection() {
  nodes[i_select_node].select1=false; 
  select_type="NULL";
  i_select_node=-1; 
  selection_possible=true;
}

void edge_selection() {
  if (selection_possible) {
    Selection i_select_aux = select_node_or_edge_index_at_min_distance(mouseX, mouseY, "NODE_OR_EDGE"); // select something
    if (i_select_aux.select_type.equals("EDGE")) { // current selection is EDGE
      if (select_type.equals("NODE") || select_type.equals("NULL")) { // if previous selection was NODE or NULL
        if (i_select_node!=-1) { // possibly deselect first node
          node_deselection();
        } 
      }
      i_select_edge=i_select_aux.select_index; // select edge
      edges[i_select_edge].select=true; select_type="EDGE"; selection_possible = false;
    } // END current selection is EDGE
  } // END selection possible
}

// select the nearest edge label to x_nav,y_nav coordinates
int select_edge_index_at_min_distance_nav(float x, float y) {
  float min_distance=size_x+1; int select_aux = -1;
  for (int i=0; i<i_cur_edge; i++) { // for each edge, compute the block distance and update min_distance
    if (!edges[i].deleted) {
      edges[i].label_coordinates();
      float diff_x=abs(edges[i].label_x_nav*zoom+xo - x);  float diff_y=abs(edges[i].label_y_nav*zoom+yo - y);
      if ((diff_x + diff_y) < min_distance && (diff_x + diff_y) < diameter_size) {
        min_distance = diff_x + diff_y;
        select_aux=i; 
      }; // end if min_distance changes
    }; // end if NOT DELETED
  }; // end for
  // println("selected index " + select_aux);
  return select_aux;
}

void edge_selection_nav() {
  //if (selection_possible) {
    i_select_edge = select_edge_index_at_min_distance_nav(mouseX, mouseY); // select something
    if (i_select_edge!=-1) {
      Edge e = edges[i_select_edge];
      if (searchNodeIdIndex(e.head_id)==cur_nav_node_index) { // predecessor
        cur_nav_node_index = searchNodeIdIndex(e.tail_id);} else
      if (searchNodeIdIndex(e.tail_id)==cur_nav_node_index) { // subsequent
        cur_nav_node_index = searchNodeIdIndex(e.head_id);} 
      // edges[i_select_edge].select=true; select_type="EDGE"; selection_possible = false;
    }
  // } // END selection possible //<>//
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% KEYBOARD INTERACTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
void generic_graph_keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {yo=yo+margin;}
    else if (keyCode == DOWN) {yo=yo-margin;}
    else if (keyCode == RIGHT) {xo=xo-margin;}
    else if (keyCode == LEFT) {xo=xo+margin;}
  } else if (key == ESC) {key = 0; showMessageDialog(null, "Press q to exit!!!", "Alert", ERROR_MESSAGE);
  } else if (key == '+') {zoom += .03;
  } else if (key == '-') {zoom -= .03;
  } else if (key == 32) {zoom = 1; xo = width/2; yo = height/2;
  } else if (key == 'q') {exit();
  } else if (key == 'z') {
    if (i_select_node!=-1 && select_type.equals("NODE")) {nodes[i_select_node].select1 = false; i_select_node=-1;}
    if (i_select_edge!=-1 && select_type.equals("EDGE")) {edges[i_select_edge].select = false; i_select_edge=-1;}
    select_type="NULL"; selection_possible = true;  hide_all_menus(); //tags_checkbox.hide();
    if (help_b) {help_b = false;}
    if (display_b) {display_b = false;}
  } else if (key=='d') { // delete the selected node or edge
    if (i_select_node!=-1 && select_type.equals("NODE")) {
      hide_all_menus(); nodes[i_select_node].delete(); i_select_node=-1;}
    else if (i_select_edge!=-1 && select_type.equals("EDGE")) {
      edges[i_select_edge].delete(); i_select_edge=-1;} 
    else if (i_select_tag!=-1 && select_type.equals("TAG")) {
      tags[i_select_tag].delete(); i_select_tag=-1;} 
    select_type="NULL"; selection_possible = true;
  } else if (key=='t') { // modify the text of the selected node
    if (i_select_node!=-1 && select_type.equals("NODE")) {
      hide_all_menus();
      nodes[i_select_node].modify_text(); // modify the text
      nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true; // unselect
    } else if (select_type=="TAG" && i_select_tag!=-1) {
        hide_all_menus();
        tags[i_select_tag].modify_name(); // modify the text
        i_select_tag=-1; select_type="NULL"; selection_possible = true; // unselect
    }
  } else if (key=='g') { // modify the tags of the selected node
    if (i_select_node!=-1 && select_type.equals("NODE")) {
      nodes[i_select_node].modify_tags(); // modify the tags through the checkbox
      nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true; // unselect
    }
  } else if (key=='h') { // display help
    if (!help_b) {
      help_b = true;
      display_help(); 
    }
  } else if (key=='i') { // modify the identifier of the selected node
    if (i_select_node!=-1 && select_type.equals("NODE")) {
      hide_all_menus();
      nodes[i_select_node].modify_id(); 
      nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true;
    } else if (i_select_edge!=-1 && select_type.equals("EDGE")){ 
      edges[i_select_edge].modify_id(); 
      edges[i_select_edge].select = false; i_select_edge=-1; select_type="NULL"; selection_possible = true;
    }
  } else if (key=='e') { // create an edge between the selected nodes
    if (i_select_node!=-1) {
      hide_all_menus(); selection_possible = true; creating_edge = true;
    }
  } else if (key=='f') { // associate an image with a node
    if (i_select_node!=-1) {
      selectInput("Select an image file:", "load_image_in_selected_node");
    }      
  } else if (key=='v') { // display an image with a node
    if (modality.equals("EDT") && i_select_node!=-1) {
      display_b = true;
      nodes[i_select_node].display_image();
      hide_all_menus(); 
      nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true;
    } else if (modality.equals("NAV")) {
      display_b = true;      
      nodes[cur_nav_node_index].display_image();
    }
  } else if (key=='n') { // create a new node 
    if (i_select_node==-1) {
      nodes[i_cur_node]=new Node(0, 0, diameter_size, diameter_size, "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, "NULL", "NULL");                                          
      i_cur_node++;
    }
  } else if (key=='l') { // insert a new label for an edge
    if (i_select_edge!=-1 && select_type.equals("EDGE")) {
      edges[i_select_edge].modify_label(); 
      edges[i_select_edge].select = false; i_select_edge=-1; select_type="NULL"; selection_possible=true;
    }
  } else if (key=='m') { // move a node
    hide_all_menus();
    i_move=-1; Node i_move_node= null; // node selected to move
    if (i_select_node!=-1 && select_type.equals("NODE") && mousePressed) { 
      if (mouseX > x_credits && mouseX < x_credits+top_offset && mouseY > y_credits && mouseY < y_credits+top_offset) {
        i_move = -1; // CREDITS
      } else {
        i_move = i_select_node; i_move_node=nodes[i_move]; // cp5.hide(); // tags_checkbox.hide(); // tags_checkbox.deactivateAll();
        i_move_node.x= mouseX/zoom-xo; i_move_node.y= mouseY/zoom-yo;
      }
    }; // end if mousePressed  
    if (i_move_node!=null) {
      flashing_ellipse (i_move_node.x, i_move_node.y, i_move_node.w);
    }
  }
}

void load_image_in_selected_node(File selected_image_file) {
  println("i_select_node = " + i_select_node);
  nodes[i_select_node].modify_image(selected_image_file.getAbsolutePath());
  hide_all_menus(); 
  nodes[i_select_node].select1 = false; i_select_node=-1; select_type="NULL"; selection_possible = true;
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% DISPLAY HELP 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void help_settings() {
  help_lines = loadStrings("commands.txt");
  help_width = (size_x/2)/zoom; help_height = (size_x/2)/zoom;
}

void display_help() {
  if (help_b) {
    imageMode(CENTER); image(sg_menu, width/2-xo, height/2-yo); //, sg_logo.width*2*y_credits/sg_logo.height, 2*y_credits);
    /*
    fill(0,0,100,200); rectMode(CENTER);
    rect((size_x/2)/zoom-xo, (size_y/2)/zoom-yo, width, height);
    fill(0,0,100); rectMode(CENTER);
    rect((size_x/2)/zoom-xo, (size_y/2)/zoom-yo, help_width, help_height);
    float x = ((size_x/2)/zoom-xo) - help_width/2;
    float y_base = (size_y/2)/zoom-yo - help_height/2;
    text_settings(); 
    for (int i=0; i<help_lines.length;i++) {
      fill(0,0,0); textAlign(LEFT,TOP);
      text(help_lines[i], x, y_base+i*default_font_size); //, help_width, default_font_size);
      //flex_write_lines_in_box(help_lines[i], default_font_name, default_font_aspect_ratio, 
        //                      "LEFT", "CENTER", x, y_base+i*default_font_size, help_width, default_font_size);
    }
    */
  }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% DISPLAY CREDITS 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void display_credits() {
  // rectMode(CENTER); 
  fill(180,100,100);
  rect(size_x/2, size_y/2, size_x/2, size_y/5);
  fill(0); textAlign(CENTER,CENTER); textFont(default_font_type, 12);
  text("Dynamic and interactive graph \n design by VL, CC(4.0) license \n pop sound by DannyBro, freesound.org, CC(0) license", size_x/2, size_y/2);
  
}
