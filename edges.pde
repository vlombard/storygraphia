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
  boolean select, deleted;
  ToolTip tooltip;

  Edge(String head_id_aux, String tail_id_aux, String id_aux, String label_aux) {
    head_id = head_id_aux; tail_id = tail_id_aux; id = id_aux; label = label_aux; select=false; deleted=false;
    tooltip = new ToolTip(label, size_x/2, size_y/2, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);  
  }
  
  void delete() {
    println("deleting edge " + id);
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
    else if (search_edge_label_index(id_aux)!=-1)
      showMessageDialog(null, "ID \"" + id_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
    else {
      showMessageDialog(null, "ID \"" + id_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
      id=id_aux;
      if (label.equals("NULL")) {tooltip.text=id; label=id;}
    }
  }

  void draw_labelled_edge() { 
    if (!deleted) {
      int head_index = searchNodeIdIndex(head_id); int tail_index = searchNodeIdIndex(tail_id);
      Node head = nodes[head_index]; Node tail = nodes[tail_index];
      fill(edge_color); stroke(edge_color); strokeWeight(1);// grey filling
      float[] edgeLabel_coords = this.label_coordinates();
      drawExternalLine(tail.x, tail.y, edgeLabel_coords[0], edgeLabel_coords[1], diameter_size/2);
      drawExternalArrow(edgeLabel_coords[0], edgeLabel_coords[1], head.x, head.y, diameter_size/2);
      if (select) {
        fill(select_color); noStroke(); ellipse(edgeLabel_coords[0], edgeLabel_coords[1], diameter_size, diameter_size);}
      // *** draw label
      fill(text_color);
      flex_write_lines_in_box(id, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", edgeLabel_coords[0], edgeLabel_coords[1], diameter_size, diameter_size);
    }
  }
  
  float[] label_coordinates() {
    float[] coord_aux = {-1,-1};
    int head_index = searchNodeIdIndex(head_id); int tail_index = searchNodeIdIndex(tail_id);
    Node head = nodes[head_index]; Node tail = nodes[tail_index];
    float edgeLabel_x = (tail.x + head.x) / 2;
    float edgeLabel_y = (tail.y + head.y) / 2;
    coord_aux[0]=edgeLabel_x; coord_aux[1]=edgeLabel_y;
    return coord_aux;
  }

}

int search_edge_id_index(String id) {
  // println(id);
  for (int i=0; i<i_cur_edge; i++) {
    if (edges[i].id.equals(id)) {return i;}
  }
  return -1;
}

int search_edge_label_index(String l) {
  // println(t);
  for (int i=0; i<i_cur_edge; i++) {
    if (edges[i].label.equals(l)) {return i;}
  }
  return -1;
}
