
Agent[] agents;
int total_agents;
int i_cur_agent = 0;

void agents_settings() {
  total_agents = 1000; 
}

void agents_setup() {
  agents = new Agent[total_agents]; 
}

void agents_color_setup() {
  colorMode(HSB, 360, 100, 100);
  if (i_cur_agent>0) {
    float color_interval = 360 / i_cur_agent; float start = random(360);
    for (int i=0; i < i_cur_agent; i++) {
      agents[i].agent_color = color((start+color_interval*i)%360,100,100);
    }
  }
}

void agents_position_setup() {
  if (i_cur_agent>0) {
    float agent_height = (size_y-y_credits) / i_cur_agent;
    if (agent_height >= diameter_size) {agent_height=diameter_size;} 
    for (int i=0; i < i_cur_agent; i++) {
      agents[i].h = agent_height; agents[i].w = agents[i].h; // square
      //agents[i].x = agents[i].w/2 - xo; agents[i].y = y_credits + (agent_height + margin)*(i + 0.5) - yo;
      agents[i].x = agents[i].w/2; agents[i].y = y_credits + (agent_height + margin)*(i + 0.5);
      agents[i].tooltip.x = agents[i].x; agents[i].tooltip.y = agents[i].y;
    }
  }
}

void update_agents(String agt_name) {
  if (searchAgent(agt_name)==null) {
    agents[i_cur_agent++]=new Agent(agt_name);
    agents_color_setup();
    agents_position_setup();
  }
  // println("update_agents: " + i_cur_agent + " agents");
}


void draw_agents() {
  for (int i=0; i < i_cur_agent; i++) {
    fill(agents[i].agent_color); rectMode(CENTER);
    rect(agents[i].x,agents[i].y,agents[i].w,agents[i].h);
  }
}

class Agent {
  String name;
  float x,y;
  float w,h;
  color agent_color;
  ToolTip tooltip;
  
  Agent (String _name) {
    name = _name; x=-1; y=-1; w=diameter_size; h=diameter_size;
    tooltip = new ToolTip(name, x, y-w, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);
  }
  
}

Agent searchAgent(String agent_name) {
  for (int i=0; i<i_cur_agent; i++) {
    if (agents[i].name.equals(agent_name)) {return agents[i];} 
  }
  return null;
}

// agent name layover through tooltip
void agent_layover() {
  // search for the tooltip to display
  float x = mouseX; float y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_agent; i++) { // for each node that includes a tooltip 
    ToolTip tt = agents[i].tooltip; 
    if (x < (agents[i].x+agents[i].w/2)*zoom && x > (agents[i].x-agents[i].w/2)*zoom) { // if the mouse is over such box
      if (y < (agents[i].y+agents[i].h/2)*zoom && y > (agents[i].y-agents[i].h/2)*zoom) {
        tt.x= x-xo; tt.y= y-yo; 
        color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
        tt.setBackground(c); // color(0,80,255,30));
        tt.display();
      }
    }
  } // END FOR
}  
