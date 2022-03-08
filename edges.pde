// GRAPH EDGES
Edge[] edges;
int total_num_edges; 
int num_edges=0; 
int i_cur_edge=0; 
int edge_counter = 0; // = num*2; // numero di archi
color edge_color;

class Edge {
  String head_id, tail_id; 
  String id; // edge identifier
  String label;
  float label_x, label_y;
  float label_x_nav, label_y_nav;
  boolean select, deleted;
  ToolTip tooltip;

  Edge(String head_id_aux, String tail_id_aux, String id_aux, String label_aux) {
    head_id = head_id_aux; tail_id = tail_id_aux; id = id_aux; label = label_aux; select=false; deleted=false;
    label_coordinates(); 
    tooltip = new ToolTip(label, label_x, label_y-diameter_size, actual_width/2, actual_height/2, default_font_name, default_font_size, default_font_aspect_ratio);  
    // tooltip = new ToolTip(label, size_x/2, size_y/2, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);  
  }
  
  void delete() {
    // println("deleting edge " + id);
    deleted=true;
  }

  void modify_label() {
    // final String id = showInputDialog("Please enter new ID");
    String label_aux = showInputDialog("Please enter new label");
    // if (text_aux == null) exit(); else
    if (label_aux == null || "".equals(label_aux))
      showMessageDialog(null, "Empty ID Input!!!", "Alert", ERROR_MESSAGE);
    else if (search_node_text(label_aux)!=-1)
      showMessageDialog(null, "TEXT \"" + label_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
    else {
      showMessageDialog(null, "TEXT \"" + label_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
      label=label_aux;
      tooltip.text=label;
    }
  }
    
  void modify_id() {
    String cur_id = id;
    String id_aux = showInputDialog("Please enter new ID, currently " + cur_id);
    if (id_aux == null || id_aux.equals(""))
      showMessageDialog(null, "Empty ID Input!!!", "Alert", ERROR_MESSAGE);
    else if (search_edge_label_index(id_aux)!=-1) {
      showMessageDialog(null, "WARNING: ID \"" + id_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
      id=id_aux; tooltip.text=id; label=id;
    } else {
      showMessageDialog(null, "ID \"" + id_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
      id=id_aux; if (label.equals("NULL")) {tooltip.text=id; label=id;}
    }
  }

  void draw_labelled_edge() { 
    if (!deleted) {
      int head_index = searchNodeIdIndex(head_id); int tail_index = searchNodeIdIndex(tail_id);
      Node head = nodes[head_index]; Node tail = nodes[tail_index];
      fill(edge_color); stroke(edge_color); strokeWeight(1);// grey filling
      label_coordinates(); 
      if (modality.equals("EDT")) {
        drawExternalLine(tail.x, tail.y, label_x, label_y, diameter_size/2);
        drawExternalArrow(label_x, label_y, head.x, head.y, diameter_size/2);
      } else 
      if (modality.equals("NAV")) {
        Unit u = (Unit) nodes[cur_nav_node_index];
        if (u.id.equals(head.id)) {
          drawExternalLine(tail.x_nav, tail.y_nav, label_x_nav, label_y_nav, diameter_size/2);
          drawExternalArrowDiff(label_x_nav, label_y_nav, head.x_nav, head.y_nav, diameter_size/2, head.w_nav/2);}
        else if (u.id.equals(tail.id)) {
          drawExternalLine(tail.x_nav, tail.y_nav, label_x_nav, label_y_nav, diameter_size/2);
          drawExternalArrowDiff(label_x_nav, label_y_nav, head.x_nav, head.y_nav, head.w_nav/2, diameter_size/2);
        }
      } 
      if (modality.equals("EDT") && select) {fill(select_color); noStroke(); ellipse(label_x, label_y, diameter_size, diameter_size);}
      // *** draw label
      fill(text_color);
      if (modality.equals("EDT")) {
        flex_write_lines_in_box(id, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", label_x, label_y, diameter_size, diameter_size);
      } else 
      if (modality.equals("NAV")) {
        flex_write_lines_in_box(id, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", label_x_nav, label_y_nav, diameter_size, diameter_size);
      }  
    }
  }
  
  void label_coordinates() {
    int head_index = searchNodeIdIndex(head_id); int tail_index = searchNodeIdIndex(tail_id);
    Node head = nodes[head_index]; Node tail = nodes[tail_index];
    if (modality.equals("EDT")) {
      label_x = (tail.x + head.x) / 2;
      label_y = (tail.y + head.y) / 2;
    } else  
    if (modality.equals("NAV")) {
      float angle = atan2(tail.y_nav - head.y_nav, tail.x_nav - head.x_nav);
      label_x_nav = ((tail.x_nav - tail.w_nav*cos(angle)) + (head.x_nav+head.w_nav*cos(angle))) / 2;
      label_y_nav = ((tail.y_nav - tail.h_nav*sin(angle)) + (head.y_nav+head.h_nav*sin(angle))) / 2;
    }   
  }

}

int search_edge_id_index(String id) {
  // println(id);
  for (int i=0; i<i_cur_edge; i++) {
    if (edges[i].id.equals(id) && !edges[i].deleted) {return i;}
  }
  return -1;
}

int search_edge_label_index(String l) {
  // println(t);
  for (int i=0; i<i_cur_edge; i++) {
    if (edges[i].label.equals(l) && !edges[i].deleted) {return i;}
  }
  return -1;
}

int search_edge_head_tail_index(int unitHeadIndex, int unitTailIndex) {
  Unit head = (Unit) nodes[unitHeadIndex]; Unit tail = (Unit) nodes[unitTailIndex];
  for (int i=0; i<i_cur_edge; i++) {
    if (edges[i].head_id.equals(head.id) && edges[i].tail_id.equals(tail.id) && !edges[i].deleted) {return i;}
  }
  return -1;
}
