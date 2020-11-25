// INTERACTIVITY GLOBAL VARIABLES
int flash_iter=0; // flash iteration
int flash_iter_up=1; // direction tion
// String registry_data = "NULL";
int i_move=-1; 
int i_select=-1; color select_color;
int i_select2=-1; color select2_color;
boolean select2=false; 
String select_type = "NULL"; // type of current selection
String modality ="INI";
String plot_generation_mode = "MANUAL";


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% INITIALIZATION 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

String start = "Start a new graph from scratch"; String init = "Init graph nodes from text file"; String load = "Load a saved graph";
String manual = "Manual (default)"; String propp = "Propp categories + tags"; 
String pe_constraints = "PRECOND-EFFECT constraints"; String dramatic_arc = "Dramatic arc (tension value)";

rectButton start_button, init_button, load_button, manual_button, propp_button, constraints_button, arc_button;

void initial_page_setup() { 
  float button_height = 2*default_font_size;
  float start_width = start.length()*default_font_size*default_font_aspect_ratio+margin;
  start_button = new rectButton("start_button", start, 
    (width/2-margin-start_width/2)*zoom-xo, (2*height/6-5*default_font_size)*zoom-yo, 
    start_width, button_height, color(45, 20, 100), default_font_size); 
  float init_width = init.length()*default_font_size*default_font_aspect_ratio+margin;
  init_button = new rectButton("init_button", init, 
    (width/2-margin-init_width/2)*zoom-xo, (3*height/6-5*default_font_size)*zoom-yo, 
    init_width, button_height, color(45, 40, 100), default_font_size);
  float load_width = load.length()*default_font_size*default_font_aspect_ratio+margin;
  load_button = new rectButton("load_button", load, 
    (width/2-margin-load_width/2)*zoom-xo, (4*height/6-5*default_font_size)*zoom-yo, 
    load_width, button_height, color(45, 60, 90), default_font_size);
  float manual_width = manual.length()*default_font_size*default_font_aspect_ratio+margin;
  manual_button = new rectButton("manual_button", manual, 
    (width/2+margin+manual_width/2)*zoom-xo, (4*height/6-5*default_font_size)*zoom-yo, 
    manual_width, button_height, color(45, 20, 100), default_font_size); 
  float propp_width = propp.length()*default_font_size*default_font_aspect_ratio+margin;
  propp_button = new rectButton("propp_button", propp, 
    (width/2+margin+propp_width/2)*zoom-xo, (9*height/12-5*default_font_size)*zoom-yo, 
    propp_width, button_height, color(45, 40, 100), default_font_size);
  float pe_constraints_width = pe_constraints.length()*default_font_size*default_font_aspect_ratio+margin;
  constraints_button = new rectButton("constraints_button", pe_constraints, 
    (width/2+margin+pe_constraints_width/2)*zoom-xo, (10*height/12-5*default_font_size)*zoom-yo, 
    pe_constraints_width, button_height, color(45, 60, 90), default_font_size);
  float dramatic_arc_width = dramatic_arc.length()*default_font_size*default_font_aspect_ratio+margin;
  arc_button = new rectButton("arc_button", dramatic_arc, 
    (width/2+margin+dramatic_arc_width/2)*zoom-xo, (11*height/12-5*default_font_size)*zoom-yo, 
    dramatic_arc_width, button_height, color(45, 80, 90), default_font_size);
}

void initialization_choice() {
  // rectMode(RIGHT);
  start_button.draw_rectButtonCenter();
  init_button.draw_rectButtonCenter();
  load_button.draw_rectButtonCenter();
  manual_button.draw_rectButtonCenter();
  propp_button.draw_rectButtonCenter();
  constraints_button.draw_rectButtonCenter();
  arc_button.draw_rectButtonCenter();
}


//// rectButton(String i, String t, float xc, float yc, float xw, float yh, color c)
//String nav_text = "NAV"; String edt_text = "EDT";
//color neuter_color = color(255,255,255); color active_color = color(255,255,0); // RGB Mode
//rectButton nav_button = new rectButton("nav_button", nav_text, 
//                                        margin+((nav_text.length()+2)*default_font_size*default_font_aspect_ratio/2), margin+default_font_size, 
//                                        (nav_text.length()+2)*default_font_size*default_font_aspect_ratio, 2*default_font_size, neuter_color, default_font_size); 
//rectButton edt_button = new rectButton("edt_button", edt_text, 
//                                        2*margin + 1.5*(nav_text.length()+2)*default_font_size*default_font_aspect_ratio, margin+default_font_size, 
//                                        (edt_text.length()+2)*default_font_size*default_font_aspect_ratio, 2*default_font_size, active_color, default_font_size); 
//void nav_edt_choice() {
//  nav_button.draw_rectButtonCenter();
//  edt_button.draw_rectButtonCenter();
//}


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
Selection select_node_or_edge_index_at_min_distance(float x, float y) {
  // println("selecting node or edge"); //<>//
  Selection select_aux = new Selection("NULL", -1);
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
        float[] edge_label_coords = edges[i].label_coordinates();
        float diff_x=abs(edge_label_coords[0]*zoom+xo - x);  float diff_y=abs(edge_label_coords[1]*zoom+yo - y);
        if ((diff_x + diff_y) < min_distance && (diff_x + diff_y) < diameter_size) {
          min_distance = diff_x + diff_y;
          select_aux.select_index=i;  select_aux.select_type="EDGE";
        }; // end if min_distance changes
      }; // end if NOT DELETED
    }; // end for
    // println("selected type: " + select_aux.select_type + "; selected index " + select_aux.select_index);
  }
  return select_aux;
}

boolean selection_possible = true;
boolean creating_edge = false;

void node_edge_selection() {
  if (selection_possible) {
    Selection i_select_aux = select_node_or_edge_index_at_min_distance(mouseX, mouseY); // select something
    if (i_select_aux.select_type.equals("NODE")) { // if node
      if (select_type.equals("NODE")) { // if current selection is node too
        if (i_select!=-1 && i_select2==-1 && creating_edge) { // if click again on the same node (selection 2), 
          hide_all_menus();
          i_select2=i_select_aux.select_index; nodes[i_select2].select2=true; // SELECT NODE 2, second node
          edges[i_cur_edge]=new Edge(nodes[i_select2].id, nodes[i_select].id, "e"+str(i_cur_edge), "NULL"); 
          i_cur_edge++; num_edges++; 
          nodes[i_select].select1=false; i_select=-1; 
          nodes[i_select2].select2=false; i_select2=-1; select_type="NULL";
          selection_possible = true; creating_edge = true;
        }
      } else // current selection type is NOT NODE
      if (select_type.equals("NULL")) { // if current selection is NULL
        if (i_select==-1) { 
          i_select=i_select_aux.select_index; nodes[i_select].select1=true; select_type="NODE"; // SELECT NODE 1, first node
          // cp5.show(); //nodes[i_select].show_tags(); 
          selection_possible = false;
          story_show_menus();
        }
      } else // current selection type is NOT NULL
      if (select_type.equals("EDGE")) { // if current selection is EDGE
        edges[i_select].select=false; i_select=i_select_aux.select_index; nodes[i_select].select1=true; 
        select_type="NODE"; // change from edge to node selection
      } 
    } else 
    if (i_select_aux.select_type.equals("EDGE")) {
      // if (select_type.equals("EDGE")) {
        // if (i_select==i_select_aux.select_index) { // if click again on the same edge, deselect
          // edges[i_select].select=false; i_select = -1; select_type="NULL"; 
        // }
      //} else { //if (select_type.equals("NODE") || select_type.equals("NULL")) {
        if (i_select!=-1) {
          nodes[i_select].select1=false; i_select = -1; 
        } // possibly deselect first node
        if (i_select2!=-1) {
          nodes[i_select2].select1=false; i_select2 = -1; 
        } // possibly deselect second node
        i_select=i_select_aux.select_index; edges[i_select].select=true; select_type="EDGE";// select edge
      // } // END ELSE
    }
  }
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
  } else if (key == '+') {zoom += .03;
  } else if (key == '-') {zoom -= .03;
  } else if (key == 32) {zoom = 1; xo = width/2; yo = height/2;
  } else if (key == 'q') {exit();
  } else if (key == 'z') {
    if (i_select!=-1 && select_type.equals("NODE")) {nodes[i_select].select1 = false; i_select=-1; }
    if (i_select!=-1 && select_type.equals("EDGE")) {edges[i_select].select = false; i_select=-1; }
    if (i_select2!=-1) {nodes[i_select2].select2 = false; i_select2=-1; }
    select_type="NULL"; selection_possible = true;  hide_all_menus(); //tags_checkbox.hide();
  } else if (key=='d') { // delete the selected node or edge
    if (i_select!=-1 && i_select2==-1) {
      if (select_type.equals("NODE")) {nodes[i_select].delete();}
      else {edges[i_select].delete();} // select_type.equals("EDGE")
      i_select=-1; select_type="NULL"; selection_possible = true;
    }
  } else if (key=='t') { // modify the text of the selected node
    if (i_select!=-1 && i_select2==-1) {
      hide_all_menus();
      nodes[i_select].modify_text(); // modify the text
      nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; // unselect
    }
  } else if (key=='g') { // modify the tags of the selected node
    if (i_select!=-1 && i_select2==-1) {
      nodes[i_select].modify_tags(); // modify the tags through the checkbox
      nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true; // unselect
    }
  } else if (key=='i') { // modify the identifier of the selected node
    if (i_select!=-1 && i_select2==-1) {
      hide_all_menus();
      if (select_type.equals("NODE")) {
        nodes[i_select].modify_id(); 
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; selection_possible = true;
      } else { // select_type.equals("EDGE")
        edges[i_select].modify_id(); 
        edges[i_select].select = false; i_select=-1; select_type="NULL"; selection_possible = true;
      }
    }
  } else if (key=='e') { // create an edge between the selected nodes
    if (i_select!=-1) {
      hide_all_menus(); selection_possible = true; creating_edge = true;
    }
  } else if (key=='n') { // create a new node 
    if (i_select==-1 && i_select2==-1) {
      nodes[i_cur_node]=new Node(0, 0, diameter_size, diameter_size, "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, "NULL", "NULL");                                          
      i_cur_node++;
    }
  } else if (key=='l') { // insert a new label for an edge
    if (i_select!=-1 && select_type.equals("EDGE")) {
      edges[i_select].modify_label(); 
      edges[i_select].select = false; i_select=-1; select_type="NULL";
    }
  } else if (key=='m') { // move a node
    hide_all_menus();
    i_move=-1; Node i_move_node= null; // node selected to move
    if (i_select!=-1 && select_type.equals("NODE") && mousePressed) { 
      if (mouseX > x_credits && mouseX < x_credits+vertical_offset && mouseY > y_credits && mouseY < y_credits+vertical_offset) {
        i_move = -1; // CREDITS
      } else {
        i_move = i_select; i_move_node=nodes[i_move]; // cp5.hide(); // tags_checkbox.hide(); // tags_checkbox.deactivateAll();
        i_move_node.x= mouseX*zoom-xo; i_move_node.y= mouseY*zoom-yo;
      }
    }; // end if mousePressed  
    if (i_move_node!=null) {
      flashing_ellipse (i_move_node.x, i_move_node.y, i_move_node.w);
    }
  }
}

void display_credits() {
  // rectMode(CENTER); 
  fill(180,100,100);
  rect(size_x/2, size_y/2, size_x/2, size_y/5);
  fill(0); textAlign(CENTER,CENTER); textFont(default_font_type, 12);
  text("Dynamic and interactive graph \n design by VL, CC(4.0) license \n pop sound by DannyBro, freesound.org, CC(0) license", size_x/2, size_y/2);
  
}
