// INTERACTIVE BUTTONS LIBRARY
color nav_edt_color, select_text_color;

class rectButton {
  String id; // button identifier
  String text; // button text to print
  float x_coord, y_coord; // coordinates of the button center
  float x_width, y_height; // width and height of the button
  color rbc; // rect button color (fill)
  color rbtc; // rect button text color
  float font_size; // size of text
  
  rectButton(String i, String t, float xc, float yc, float xw, float yh, color c, color tc, float fs) { 
    id = i; text = t; x_coord = xc; y_coord = yc; x_width = xw; y_height = yh; rbc=c; rbtc=tc; font_size=fs;
  } 
  
  void draw_rectButtonCenter() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord, y_coord, x_width, y_height, x_width/10);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord, y_coord);
  }

  void draw_rectButtonRight() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord-x_width/2, y_coord, x_width, y_height, x_width/10);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord-x_width/2, y_coord);
  }

  void draw_rectButtonLeft() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord+x_width/2, y_coord, x_width, y_height, x_width/10);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord+x_width/2, y_coord);
  }

  boolean click_rectButton() {
    if (mouseX > (x_coord-x_width/2)*zoom+xo && mouseX < (x_coord+x_width/2)*zoom+xo && 
        mouseY > (y_coord-y_height/2)*zoom+yo && mouseY < (y_coord+y_height/2)*zoom+yo) {return true;}
    return false;
  }
}

class imgButton {
  PImage img;
  String txt;
  float surface_width, surface_height;
  float display_width, display_height;
  float x_coord, y_coord;
  ToolTip tooltip;
  
  imgButton(PImage i, String t, float x, float y, float s_w, float s_h) { 
    img = i; txt = t; x_coord = x; y_coord = y; surface_width = s_w; surface_height = s_h;
    float[] display_sizes = img_fitting_surface(img, surface_width, surface_height);
    display_width = display_sizes[0]; display_height = display_sizes[1];
    tooltip = new ToolTip(txt, x_coord, y_coord, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);
  } 

  void draw_imgButtonCenter() {
    imageMode(CENTER); 
    image(img, x_coord, y_coord, display_width, display_height);
  }

  boolean click_imgButton() {
    if (mouseX > (x_coord-display_width/2)*zoom+xo && mouseX < (x_coord+display_width/2)*zoom+xo && 
        mouseY > (y_coord-display_height/2)*zoom+yo && mouseY < (y_coord+display_height/2)*zoom+yo) {return true;}
    return false;
  }
  
}

// button text layover through tooltip
void button_layover() {
  // search for the tooltip to display
  float x = mouseX; float y = mouseY; // capture mouse position
  if (x < (twine_button.x_coord+twine_button.display_width/2)*zoom+xo && x > (twine_button.x_coord-twine_button.display_width/2)*zoom+xo && // if the mouse is over the twine button
     (y < (twine_button.y_coord+twine_button.display_height/2)*zoom+yo && y > (twine_button.y_coord-twine_button.display_height/2)*zoom+yo)) {
      // ToolTip(String _text, float _x, float _y, float _max_w, float _max_h, String _font_name, float _font_size, float _font_aspect_ratio)
      ToolTip tt = new ToolTip(twine_button.txt,
                               twine_button.x_coord*zoom+xo, (twine_button.y_coord-twine_button.display_height)*zoom+yo, 
                               size_x/2, size_y/2, 
                               default_font_name, default_font_size, default_font_aspect_ratio);
      tt.x= x/zoom-xo; tt.y= y/zoom-yo; 
      color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
      tt.setBackground(c); // color(0,80,255,30));
      tt.display();
  } else 
  if (x < (sg_button.x_coord+sg_button.display_width/2)*zoom+xo && x > (sg_button.x_coord-sg_button.display_width/2)*zoom+xo && // if the mouse is over the sg button
      y < (sg_button.y_coord+sg_button.display_height/2)*zoom+yo && y > (sg_button.y_coord-sg_button.display_height/2)*zoom+yo) {
      // ToolTip(String _text, float _x, float _y, float _max_w, float _max_h, String _font_name, float _font_size, float _font_aspect_ratio)
      ToolTip tt = new ToolTip(sg_button.txt,
                               sg_button.x_coord*zoom+xo, (sg_button.y_coord-sg_button.display_height)*zoom+yo, 
                               size_x/2, size_y/2, 
                               default_font_name, default_font_size, default_font_aspect_ratio);
      tt.x= x/zoom-xo; tt.y= y/zoom-yo; 
      color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
      tt.setBackground(c); // color(0,80,255,30));
      tt.display();
  }
} 
