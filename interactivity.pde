// INTERACTIVITY GLOBAL VARIABLES
int flash_iter=0; // iterazione del flash
int flash_iter_up=1; // verso dell'iterazione
String registry_data = "NULL";
int i_move=-1; 
int i_select=-1; color select_color;
int i_select2=-1; color select2_color;
boolean select2=false; 
String select_type = "NULL";
String modality ="INI";

String start = "Start a new graph from scratch"; String init = "Init graph nodes from text file"; String load = "Load a saved graph";
rectButton start_button, init_button, load_button;

void initial_page_setup() { 
  start_button = new rectButton("start_button", start, 
    (width/2)*zoom-xo, (height/2-5*default_font_size)*zoom-yo, 
    start.length()*default_font_size*default_font_aspect_ratio+margin, 2*default_font_size, color(120, 50, 100), default_font_size); 
  init_button = new rectButton("init_button", init, 
    (width/2)*zoom-xo, (height/2-default_font_size)*zoom-yo, 
    init.length()*default_font_size*default_font_aspect_ratio+margin, 2*default_font_size, color(220, 50, 100), default_font_size);
  load_button = new rectButton("load_button", load, 
    (width/2)*zoom-xo, (height/2+3*default_font_size)*zoom-yo, 
    load.length()*default_font_size*default_font_aspect_ratio+margin, 2*default_font_size, color(0, 0, 90), default_font_size);
}

class Selection {
  String select_type;
  int select_index;
  
  Selection(String t, int i) {
    select_type=t; select_index=i;
  }
}

void initialization_choice() {
  start_button.draw_rectButton();
  init_button.draw_rectButton();
  load_button.draw_rectButton();
}

void initialization_go() {
  if (start_button.click_rectButton()) {
    modality="EDT";
  } else if (init_button.click_rectButton()) {
    selectInput("Select a file to process:", "loadTextFile"); 
    modality="EDT";
  } else if (load_button.click_rectButton()) {
    selectInput("Select a file to process:", "loadGraphFile"); 
    modality="EDT";
  }
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
//  nav_button.draw_rectButton();
//  edt_button.draw_rectButton();
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
  ellipse(x, y, r+margin*flash_iter, r+margin*flash_iter);
  // pop.play(); // sound
}

// select the nearest node or edge label to x,y coordinates
Selection select_node_or_edge_index_at_min_distance(float x, float y) {
  println("selecting node or edge"); //<>//
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

void node_edge_selection() {
    Selection i_select_aux = select_node_or_edge_index_at_min_distance(mouseX, mouseY);
    if (i_select_aux.select_type.equals("NODE")) {
      if (select_type.equals("NODE")) {
        if (i_select==i_select_aux.select_index) {
          nodes[i_select].select1=false; i_select = -1; // if click again on the same node, deselect 1
          if (i_select2==-1) {select_type="NULL";}
        } else if (i_select2==i_select_aux.select_index) {
          nodes[i_select2].select2=false;  i_select2 = -1; // if click again on the same node, deselect 2
          if (i_select==-1) {select_type="NULL";}
        } else if (i_select!=-1 && i_select2==-1) {
          i_select2=i_select_aux.select_index; nodes[i_select2].select2=true; // select second node
        }
      } 
      else if (select_type.equals("NULL")) { 
        if (i_select==-1) { 
          i_select=i_select_aux.select_index; nodes[i_select].select1=true; select_type="NODE"; // select first node
        }
      } 
      else if (select_type.equals("EDGE")) {
        edges[i_select].select=false; i_select=i_select_aux.select_index; nodes[i_select].select1=true; 
        select_type="NODE"; // change from edge to node selection
      } 
    } else if (i_select_aux.select_type.equals("EDGE")) {
      if (select_type.equals("EDGE")) {
        if (i_select==i_select_aux.select_index) { // if click again on the same edge, deselect
          edges[i_select].select=false; i_select = -1; select_type="NULL";
        }
      } else { //if (select_type.equals("NODE") || select_type.equals("NULL")) {
        if (i_select!=-1) {
          nodes[i_select].select1=false; i_select = -1; 
        } // possibly deselect first node
        if (i_select2!=-1) {
          nodes[i_select2].select1=false; i_select2 = -1; 
        } // possibly deselect second node
        i_select=i_select_aux.select_index; edges[i_select].select=true; select_type="EDGE";// select edge
      }
    }
}



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
  } else if (key=='d') { // delete the selected node or edge
    if (i_select!=-1 && i_select2==-1) {
      if (select_type.equals("NODE")) {nodes[i_select].delete();}
      else {edges[i_select].delete();} // select_type.equals("EDGE")
      i_select=-1; select_type="NULL";
    }
  } else if (key=='t') { // modify the text of the selected node
    if (i_select!=-1 && i_select2==-1) {
      nodes[i_select].modify_text(); // modify the text
      nodes[i_select].select1 = false; i_select=-1; select_type="NULL"; // unselect
    }
  } else if (key=='i') { // modify the identifier of the selected node
    if (i_select!=-1 && i_select2==-1) {
      if (select_type.equals("NODE")) {
        nodes[i_select].modify_id(); 
        nodes[i_select].select1 = false; i_select=-1; select_type="NULL";
      } else { // select_type.equals("EDGE")
        edges[i_select].modify_id(); 
        edges[i_select].select = false; i_select=-1; select_type="NULL";
      }
    }
  } else if (key=='e') { // create an edge between the selected nodes
    if (i_select!=-1 && i_select2!=-1) {
      edges[i_cur_edge]=new Edge(nodes[i_select2].id, nodes[i_select].id, "e"+str(i_cur_edge), "NULL"); 
      i_cur_edge++; num_edges++; 
      nodes[i_select].select1=false; i_select=-1; 
      nodes[i_select2].select2=false; i_select2=-1; select_type="NULL";
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
    i_move=-1; Node i_move_node= null; // node selected to move
    if (i_select!=-1 && select_type.equals("NODE") && mousePressed) { 
      if (mouseX > x_credits && mouseX < x_credits+credits_side && mouseY > y_credits && mouseY < y_credits+credits_side) {
        i_move = -1; // CREDITS
      } else {
        i_move = i_select; i_move_node=nodes[i_move]; 
        i_move_node.x= mouseX*zoom-xo; i_move_node.y= mouseY*zoom-yo;
      }
    }; // end if mousePressed  
    if (i_move_node!=null) {
      flashing_ellipse (i_move_node.x, i_move_node.y, i_move_node.w);
      write_lines_in_fixed_fontsize(i_move_node.id + " - TAG: " + nodes[i_move].tag, 
        default_font_name, default_font_aspect_ratio, default_font_size, "LEFT", "CENTER", i_move_node.x*zoom+xo, i_move_node.y*zoom+yo);
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
