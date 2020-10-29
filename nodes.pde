// GRAPH NODES: GLOBAL VARIABLES
int totalNum; 
int num = 0; 
int num_deleted = 0;
Node[] nodes; // array of nodes
int i_cur_node = 0; 
int node_counter = 0;
int[] deleted_nodes; // nodes deleted in one session
int diameter_size; 
color node_color;

void generic_graph_settings() {
  totalNum = 1000; 
  total_num_edges=totalNum^2;
  nodes = new Node[totalNum];
  edges = new Edge[total_num_edges];
  deleted_nodes = new int[totalNum]; 
}

class Node {
  float x,y; // node center coordinates
  float w,h; // node circle width and height, respectively
  String id; // node identifier
  String text; // node text
  String tag; // node tag
  ToolTip tooltip;
  boolean select1, select2, deleted;

  Node(float x_aux, float y_aux, float w_aux, float h_aux, String id_aux, String text_aux, String tag_aux) {
    x=x_aux; y=y_aux; w=w_aux; h=h_aux; id=id_aux; text=text_aux; tag=tag_aux; select1=false; select2=false; deleted=false;
    // Tooltip_box(String i, String tt, float xc, float yc, float xw, float yh)
    tooltip = new ToolTip(text, x, y-w, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);
  }
  
  void modify_text() {
    String text_aux = showInputDialog("Please enter new text");
    // if (text_aux == null) exit(); else
    if (text_aux == null || "".equals(text_aux))
      showMessageDialog(null, "Empty TEXT Input!!!", "Alert", ERROR_MESSAGE);
    else if (search_node_text(text_aux)!=-1)
      showMessageDialog(null, "TEXT \"" + text_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
    else {
      showMessageDialog(null, "TEXT \"" + text_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
      text=text_aux;
      tooltip.text=text;
    }
  }

  void modify_id() {
    String cur_id = id;
    String id_aux = showInputDialog("Please enter new ID");
    // if (text_aux == null) exit(); else
    if (id_aux == null || "".equals(id_aux))
      showMessageDialog(null, "Empty ID Input!!!", "Alert", ERROR_MESSAGE);
    else if (search_node_text(id_aux)!=-1)
      showMessageDialog(null, "ID \"" + id_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
    else {
      showMessageDialog(null, "ID \"" + id_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
      id=id_aux;
      if (text.equals("NULL")) {tooltip.text=id; text=id;}
      for (int j=0; j<i_cur_edge; j++) {
        Edge e = (Edge) edges[j];
        if (e.tail_id.equals(cur_id)) {e.tail_id = id;} 
        if (e.head_id.equals(cur_id)) {e.head_id = id;}
      }
    }
  }

  void delete() {
    println("deleting node " + id);
    deleted = true; 
    // deleted_nodes[num_deleted++]=i;
    for (int j=0; j<i_cur_edge; j++) {
      Edge e = (Edge) edges[j];
      if (e.tail_id==id || e.head_id==id) {e.delete();}
    }
  }

  void create_node() {
  }
  

  // node DRAWING
  void draw_node() {
    // PRINT CHECK: println("Drawing node " + id);
    if (!deleted) { 
      // *** possibly draw selection border (if it is the case)
      if (select1) {fill(select_color);} 
      else if (select2) {fill(select2_color);} 
      else {fill(node_color);}
      // *** draw node and text
      // int tag_index = searchTagIndex(nodes_tag[nodeIndex]);
      stroke(edge_color); ellipseMode(CENTER); strokeWeight(1);
      ellipse(x, y, w, h);
      fill(text_color);
      flex_write_lines_in_box(id, default_font_name, default_font_aspect_ratio, "CENTER", "CENTER", x, y, diameter_size, diameter_size);
    }
  } // END draw_node
}

int searchNodeIdIndex(String id) {
  // println(id);
  for (int i=0; i<i_cur_node; i++) {
    if (nodes[i].id.equals(id)) {return i;}
  }
  return -1;
}

int search_node_text(String t) {
  // println(t);
  for (int i=0; i<i_cur_node; i++) {
    if (nodes[i].text.equals(t)) {return i;}
  }
  return -1;
}
