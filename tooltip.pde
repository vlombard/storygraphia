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
    float bx = x+tooltipWidth/2; float by = y-tooltipHeight/2; // center coordinates of tooltip box rectangle  //<>//
    if (bx*zoom+xo <= 0){bx = (tooltipWidth/2)/zoom-xo;} //  
    if (bx*zoom+xo >= width){bx = (width-tooltipWidth/2)/zoom-xo;} 
    if (by*zoom+yo <= 0) {by = (tooltipHeight/2)/zoom-yo;}
    if (by*zoom+yo >= height) {by = (height-tooltipHeight/2)/zoom-yo;} //  
    //fill(tbackground); noStroke(); rectMode(CENTER); // rectMode(CORNER);  
    //rect(bx, by, tooltipWidth, tooltipHeight); 
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


// text layover through tooltip
void layover() {
  // search for the tooltips to display
  float x = mouseX-xo; float y = mouseY-yo; // capture mouse position
  for (int i=0; i<i_cur_node; i++) { // for each node that includes a tooltip 
    if (!nodes[i].deleted) {
      ToolTip tt = nodes[i].tooltip; 
      if (x < (nodes[i].x+nodes[i].w/2)*zoom && x > (nodes[i].x-nodes[i].w/2)*zoom) { // if the mouse is over such box
        if (y < (nodes[i].y+nodes[i].h/2)*zoom && y > (nodes[i].y-nodes[i].h/2)*zoom) {
          tt.x=x; tt.y=y; 
          //color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
          //tb.tooltip.setBackground(c); // color(0,80,255,30));
          tt.display();
        }
      }
    }
  } // END FOR nodes
  for (int i=0; i<i_cur_edge; i++) { // for each node that includes a tooltip 
    if (!edges[i].deleted) {
      ToolTip tt = edges[i].tooltip; 
      int head_index = searchNodeIdIndex(edges[i].head_id); 
      int tail_index = searchNodeIdIndex(edges[i].tail_id);
      Node head = nodes[head_index]; 
      Node tail = nodes[tail_index];
      float edgeLabel_x = (tail.x + head.x) / 2;
      float edgeLabel_y = (tail.y + head.y) / 2;
      if (x < (edgeLabel_x+diameter_size/2)*zoom && x > (edgeLabel_x-diameter_size/2)*zoom) { // if the mouse is over such box
        if (y < (edgeLabel_y+diameter_size/2)*zoom && y > (edgeLabel_y-diameter_size/2)*zoom) {
          tt.x= x; tt.y= y; 
          color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
          tt.setBackground(c); // color(0,80,255,30));
          tt.display();
        }
      }
    }
  } // END FOR 
}
