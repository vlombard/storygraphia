// INTERACTIVE BUTTONS LIBRARY

class rectButton {
  String id; 
  String text;
  float x_coord, y_coord; // center
  float x_width, y_height;
  color rbc;
  float font_size;

  rectButton(String i, String t, float xc, float yc, float xw, float yh, color c, float fs) { 
    id = i; text = t; x_coord = xc; y_coord = yc; x_width = xw; y_height = yh; rbc=c; font_size=fs;
  } 
  
  void draw_rectButton() {
    rectMode(CENTER); fill(rbc); 
    rect(x_coord, y_coord, x_width, y_height);
    textAlign(CENTER, CENTER); fill(0); textSize(font_size); text(text, x_coord, y_coord);
  }
  
  boolean click_rectButton() {
    if (mouseX > (x_coord-x_width/2)*zoom+xo && mouseX < (x_coord+x_width/2)*zoom+xo && 
        mouseY > (y_coord-y_height/2)*zoom+yo && mouseY < (y_coord+y_height/2)*zoom+yo) {return true;}
    return false;
  }
}
