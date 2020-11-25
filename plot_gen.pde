
// PROPP
// based on Lakoff elaboration of Propp functions
String[] proppTags = {"Int(erdiction)", "Vio(lation)", "Cv (Complication\nvillany)", "L(eave)", "D(onor)", 
                      "hEro\nreacts", "F (gain\nmagic", "G (uses\nmagic)", "H (fights\nvillain)", "I (defeats\nvillain)", 
                      "K (misfortune\nliquidated)", "Rew(ard)"};
int cur_unit_propp_tag_index = -1;
float[] propp_layout_x = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
color[] propp_layout_colors = {color(0), color(0), color(0), color(0), color(0), color(0), color(0), color(0), color(0), color(0), color(0), color(0)};

void propp_setup() {
  float rect_width = actual_width/proppTags.length;
  for (int i=0; i<proppTags.length; i++) {
    propp_layout_x[i] = horizontal_offset+i*rect_width+rect_width/2;
    if (i%2==0) {propp_layout_colors[i] = bg_color_1;} else  {propp_layout_colors[i] = bg_color_2;}
  }  
}

void propp_settings() {
  float rect_width = actual_width/proppTags.length;
  for (int i=0; i<proppTags.length; i++) {
    propp_layout_x[i] = horizontal_offset+i*rect_width+rect_width/2;
    if (i%2==0) {propp_layout_colors[i] = bg_color_1;} else  {propp_layout_colors[i] = bg_color_2;}
  }  
}

void propp_layout_bg_matrix() {
  noStroke();
  for (int i=0; i<proppTags.length; i++) {
    fill(propp_layout_colors[i]);
    rect(propp_layout_x[i]/zoom-xo, (vertical_offset+actual_height/2)/zoom-yo,
           actual_width/proppTags.length, actual_height);
    fill(text_color); textFont(default_font_type);
    text(proppTags[i], propp_layout_x[i]/zoom-xo, (vertical_offset+default_font_size)/zoom-yo);
  }
}


// CONSTRAINTS
// based upon preconditions and effects 
State[] states;
String[] states_names;
int max_states;
int max_states_per_node;
int i_cur_state;

void states_settings() {
  max_states = 1000;
  i_cur_state = 0;
  max_states_per_node = max_states;
  states = new State[max_states];
  states_names = new String[max_states];
  // states_names[0] = "fake_state_0"; states_names[1] = "fake_state_1"; i_cur_state=2;
}

void states_color_setup() {
  colorMode(HSB, 360, 100, 100);
  if (i_cur_state>0) {
    float color_interval = 360 / i_cur_state; float start = 0; //random(360);
    for (int i=0; i < i_cur_state; i++) {
      states[i].state_color = color((start+color_interval*i)%360,30,100);
    }
  }
}

int searchStateIndex(String state_name) {
  for (int i=0; i<i_cur_state; i++) {
    if (states[i].name.equals(state_name)) {return i;} 
  }
  return -1;
}

void initialize_state_list(String[] state_list) {
  for (int i=0; i<state_list.length; i++) {
    state_list[i]="NULL STATE";
  }
}

String create_state() {
  String state_aux = showInputDialog("Please enter new state");
  if (state_aux == null || "".equals(state_aux))
    showMessageDialog(null, "Empty state!!!", "Alert", ERROR_MESSAGE);
  else if (searchStateIndex(state_aux)!=-1)
    showMessageDialog(null, "ID \"" + state_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
  else {
    showMessageDialog(null, "ID \"" + state_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
    update_states(state_aux);
  }
  return state_aux;
}
  
void update_states(String state_name) {
  // println("update_states: " + state_name + ", of " + i_cur_state + " states");
  if (searchStateIndex(state_name)==-1) {
    // println("i_cur_preconditions_checkbox: " + i_cur_preconditions_checkbox);
    states_names[i_cur_state] = state_name;
    states[i_cur_state] = new State(state_name);
    preconditions_checkbox.addItem("PRE:"+state_name, i_cur_preconditions_checkbox); 
    preconditions_checkbox.getItem(i_cur_preconditions_checkbox).getCaptionLabel().alignX(RIGHT)._myPaddingX=preconditions_checkbox.getItem(i_cur_preconditions_checkbox).getWidth();
    i_cur_preconditions_checkbox++;
    effects_checkbox.addItem("EFF:"+state_name, i_cur_effects_checkbox); i_cur_effects_checkbox++;
    i_cur_state++;
  }
  // println("update_states: " + i_cur_state + " states");
}


class State {
  String name;
  float x_min, x_max, y_min, y_max;
  color state_color;
  
  State (String _name) {
    name = _name;
  }
  
}

// DRAMATIC TENSION (integer number between 1 and 100) 
int min_tension = 1; int max_tension = 100; 
PImage tension_bg;

void tension_setup() {
  tension_bg = loadImage("tension.png");
}

float tension_position(int tension) {
  float y = -1; int tension_interval = max_tension-min_tension;
  float y_relative = (tension * actual_height) / tension_interval;
  y = vertical_offset + (actual_height - y_relative);
  return y;
}

void tension_layout_bg() {
  image(tension_bg, horizontal_offset/zoom-xo, vertical_offset/zoom-yo, actual_width, actual_height);
}
