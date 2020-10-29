
// LAYOUT GLOBAL VARIABLES
int size_x=1280; // 640; // 1280; 
int size_y=760; // 380; // 760;
float margin = 5; // margin from borders
float credits_side = size_y/20; 
float x_credits = size_x/2; 
float y_credits = credits_side;
// TRANSLATE AND ZOOM
float xo=width/2;
float yo=height/2;
float zoom = 1;

// DRAWING AUXILIARY FUNCTIONS

void generic_layout_settings() {
  size(size_x, size_y); // size of the display window
  diameter_size = size_x/30;
  xo = width/2;
  yo = height/2;
}

void color_setup() {
  colorMode(HSB, 360, 100, 100);
  node_color = color(0, 0, 100); edge_color = color(0, 0, 0); text_color = color(0, 0, 0);
  select_color = color(0,0,33); select2_color = color(0,0,66);
}

// HEADER
void draw_header() {
  stroke(edge_color); fill(node_color); rectMode(CENTER); 
  int s = (int) credits_side-2; textSize(s); textFont(default_font_type, s);   
  line((x_credits-(graph_name.length()/2)*default_font_aspect_ratio*s), credits_side, 
       (x_credits+(graph_name.length()/2)*default_font_aspect_ratio*s), credits_side);
  textAlign(CENTER,DOWN); fill(text_color);
  text(graph_name, x_credits, y_credits);
}

String set_graph_name() {
  String name = showInputDialog("Please enter a name for the graph");
  if (name == null || name.equals("")) {
    showMessageDialog(null, "Empty name!!!", "Alert", ERROR_MESSAGE);
    name = set_graph_name();}
  return name;
}


// EDGE DRAWING AUXILIARY FUNCTIONS

// by ketakahashi @ https://gist.github.com/ketakahashi/81b7f22b4ecee1fa5d84393ab670ef99
void drawArrow(float x1, float y1, float x2, float y2) { 
  float a = dist(x1, y1, x2, y2) / 50;
  pushMatrix();
  translate(x2, y2);
  rotate(atan2(y2 - y1, x2 - x1));
  triangle(-a * 2, -a, 0, 0, - a * 2, a);
  popMatrix();
  line(x1, y1, x2, y2);  
}

// draws external arrow from a circle
void drawExternalArrow(float x1, float y1, float x2, float y2, float r) { 
  float angle = atan2(y2 - y1, x2 - x1);
  // float a = dist(x1, y1, x2, y2) / 50;
  // float a = dist(x1, y1, x2-r * cos(angle), y2-r * sin(angle)) / 50;
  float a = height/150;
  // build the tip of the arrow (triangle in the arrow direction)
  pushMatrix();
  // translate(x2, y2);
  translate(x2-(r*cos(angle)), y2-(r*sin(angle)));
  rotate(angle);
  triangle(-a * 2, -a, 0, 0, -a * 2, a);
  popMatrix();
  line(x1+r*cos(angle), y1+r*sin(angle), x2-(r*cos(angle)), y2-(r*sin(angle)));  
}

// draws external line from a circle
void drawExternalLine(float x1, float y1, float x2, float y2, float r) { 
  float angle = atan2(y2 - y1, x2 - x1);
  // build the tip of the arrow (triangle in the arrow direction)
  line(x1+r*cos(angle), y1+r*sin(angle), x2-(r*cos(angle)), y2-(r*sin(angle)));  
}
