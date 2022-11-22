// ##########################################################
// Class to display a tooltip in a rectangle. 
// ##########################################################

class ToolTip{
  String text; // text of the tooltip
  float x,y; // x,y coordinate center
  float max_w, max_h;; // max width and height
  // aux variables
  int delta_x = 5; // horizontal space between mouse and tooltip 
  float tooltipWidth = 0; // width of the text
  float tooltipHeight = 0; // height of the text
  color tbackground = color(60, 60, 60, 10); //  // default background color  
  float font_size; float font_aspect_ratio; String font_name;
  
  // **** DEFINITION OF THE TOOLTIP OBJECT ****
  ToolTip(String _text, float _x, float _y, float _max_w, float _max_h, String _font_name, float _font_size, float _font_aspect_ratio){
    text = _text; x = _x; y = _y; max_w = _max_w; max_h = _max_h; font_name = _font_name; font_size = _font_size; font_aspect_ratio = _font_aspect_ratio; // set coordinates and text
    String[] words = split_text_into_words (text);
    float[] box_size = determine_box_size(words, font_aspect_ratio, font_size);
    if (box_size[0] <= max_w && box_size[1] <= max_h) {tooltipWidth = box_size[0]; tooltipHeight = box_size[1];}
    else {text = "NULL"; tooltipWidth = text.length()*font_aspect_ratio*font_size; tooltipHeight = font_size;}
  }
  
  void setBackground(color c){
    tbackground = c;
  }
        
  void display() { // display the tooltip (2017 july 3)
    float bx = x; float by = y; // center coordinates of tooltip box rectangle
    bx = check_horizontal_boundaries(x+tooltipWidth/2, tooltipWidth);
    by = check_vertical_boundaries(y-tooltipHeight/2, tooltipHeight);
    fill(0, 0, 100); //tbackground); 
    noStroke(); rectMode(CENTER); // rectMode(CORNER);  
    rect(bx, by, tooltipWidth, tooltipHeight); 
    write_lines_in_fixed_fontsize(text, font_name, font_aspect_ratio, font_size, "LEFT", "TOP", bx, by);
  } // END METHOD display

  void displayStatic() { // display the tooltip  
    float bx = x; // int(x+delta_x);
    float by = y; // -tooltipHeight/2; // int(y-tooltipHeight);    
    fill(#000000);
    flex_write_lines_in_box(text, font_name, font_aspect_ratio, "LEFT", "TOP", bx+margin, by, max_w-margin, max_h);     
    // }
  } // END METHOD display

} // END CLASS ToolTip


// text layover through tooltip, in editing mode
void layover() {
  // search for the tooltips to display
  float tt_x = mouseX; float tt_y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_node; i++) { // for each node that includes a tooltip 
    if (!nodes[i].deleted) {
      ToolTip tt = nodes[i].tooltip; 
      if (tt_x < (nodes[i].x+nodes[i].w/2)*zoom+xo && tt_x > (nodes[i].x-nodes[i].w/2)*zoom+xo) { // if the mouse is over such box
        if (tt_y < (nodes[i].y+nodes[i].h/2)*zoom+yo && tt_y > (nodes[i].y-nodes[i].h/2)*zoom+yo) {
          tt.x=tt_x/zoom-xo; tt.y=tt_y/zoom-yo; 
          tt.display();
        }
      }
    }
  } // END FOR nodes
  for (int i=0; i<i_cur_edge; i++) { // for each edge  
    if (!edges[i].deleted) { // if not deleted
      ToolTip tt = edges[i].tooltip; // retrieve tooltip
      // retrieve head and tail nodes
      int head_index = searchNodeIdIndex(edges[i].head_id);  
      int tail_index = searchNodeIdIndex(edges[i].tail_id);
      Node head = nodes[head_index]; 
      Node tail = nodes[tail_index];
      // retrieve edge label coordinates
      float edgeLabel_x = (tail.x + head.x) / 2;
      float edgeLabel_y = (tail.y + head.y) / 2;
      if (tt_x < (edgeLabel_x+diameter_size/2)*zoom+xo && tt_x > (edgeLabel_x-diameter_size/2)*zoom+xo) { // if the mouse is over such box
        if (tt_y < (edgeLabel_y+diameter_size/2)*zoom+yo && tt_y > (edgeLabel_y-diameter_size/2)*zoom+yo) {
          tt.x=tt_x/zoom-xo; tt.y=tt_y/zoom-yo; 
          color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
          tt.setBackground(c); // color(0,80,255,30));
          tt.display(); // display the tooltip
        }
      }
    }
  } // END FOR each edge
  
}

// text layover through tooltip, in navigation mode
void layover_nav() {
  // search for the tooltips to display
  float tt_x = mouseX; float tt_y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_node; i++) { // for each node that includes a tooltip 
    if (!nodes[i].deleted && i!=cur_nav_node_index) {
      ToolTip tt = nodes[i].tooltip; 
      if (tt_x < (nodes[i].x_nav+nodes[i].w/2)*zoom+xo && tt_x > (nodes[i].x_nav-nodes[i].w_nav/2)*zoom+xo) { // if the mouse is over such box
        if (tt_y < (nodes[i].y_nav+nodes[i].h_nav/2)*zoom+yo && tt_y > (nodes[i].y_nav-nodes[i].h_nav/2)*zoom+yo) {
          tt.x=tt_x/zoom-xo; tt.y=tt_y/zoom-yo; 
          tt.display();
        }
      }
    }
  } // END FOR nodes
  for (int i=0; i<i_cur_edge; i++) { // for each node that includes a tooltip 
    if (!edges[i].deleted) {
      ToolTip tt = edges[i].tooltip; 
      if (tt_x < (edges[i].label_x_nav+diameter_size/2)*zoom+xo && tt_x > (edges[i].label_x_nav-diameter_size/2)*zoom+xo) { // if the mouse is over such box
        if (tt_y < (edges[i].label_y_nav+diameter_size/2)*zoom+yo && tt_y > (edges[i].label_y_nav-diameter_size/2)*zoom+yo) {
          tt.x=tt_x/zoom-xo; tt.y=tt_y/zoom-yo; 
          color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
          tt.setBackground(c); // color(0,80,255,30));
          tt.display();
        }
      }
    }
  } // END FOR 
}
