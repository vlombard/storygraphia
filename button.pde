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
    rect(x_coord, y_coord, x_width, y_height);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord, y_coord);
  }

  void draw_rectButtonRight() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord-x_width/2, y_coord, x_width, y_height);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord-x_width/2, y_coord);
  }

  void draw_rectButtonLeft() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord+x_width/2, y_coord, x_width, y_height);
    textAlign(CENTER, CENTER); fill(rbtc); textSize(font_size); text(text, x_coord+x_width/2, y_coord);
  }

  boolean click_rectButton() {
    if (mouseX > (x_coord-x_width/2)*zoom+xo && mouseX < (x_coord+x_width/2)*zoom+xo && 
        mouseY > (y_coord-y_height/2)*zoom+yo && mouseY < (y_coord+y_height/2)*zoom+yo) {return true;}
    return false;
  }
}
