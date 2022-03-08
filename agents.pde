// LIBRARY FOR AGENTS

Agent[] agents;
String[] agent_ids; int agent_id_suffix = 0; // Agent id's are printed in the Agent box
int total_agents;
int i_cur_agent;
int i_select_agent;

void agents_settings() {
  total_agents = 1000; 
  i_cur_agent = 0;
  i_select_agent = -1;
}

void agents_setup() {
  agents = new Agent[total_agents]; 
  agent_ids = new String[total_agents];
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
    float agent_height = actual_height / i_cur_agent;
    if (agent_height >= diameter_size) {agent_height=diameter_size;} 
    for (int i=0; i < i_cur_agent; i++) {
      agents[i].h = agent_height; agents[i].w = agents[i].h; // square
      agents[i].x = agents[i].w/2; agents[i].y = top_offset + (agent_height + margin)*(i + 0.5);
      agents[i].tooltip.x = agents[i].x; agents[i].tooltip.y = agents[i].y;
    }
  }
}

void update_agents(String agt_name, String mode) {
  switch (mode) {
    case("ADD"):
      if (searchAgent(agt_name)==null) {
        agents[i_cur_agent]=new Agent(agt_name);
        i_cur_agent++;
      }
      break;
    case("DEL"):
      Agent[] agents_aux = new Agent[i_cur_agent-1]; String[] agent_ids_aux = new String[i_cur_agent-1];
      int index = searchAgentIndex(agt_name);
      if (index!=-1) {
        for (int i=0; i<index; i++) {agents_aux[i]=agents[i]; agent_ids_aux[i]=agent_ids[i];}
        for (int i=index; i<i_cur_agent-1; i++) {agents_aux[i]=agents[i+1]; agent_ids_aux[i]=agent_ids[i+1];}
        for (int i=0; i<agents_aux.length; i++) {agents[i]=agents_aux[i]; agent_ids[i]=agent_ids_aux[i];}
        i_cur_agent--;
      }
      break;
  } // END SWITCH
  agents_color_setup();
  agents_position_setup();
  // println("update_agents: " + i_cur_agent + " agents");
}

int agent_click() {
  int i_select_aux=-1;
  float x = mouseX; float y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_agent; i++) { // for each agent 
    if (x < (agents[i].x+agents[i].w/2)*zoom && x > (agents[i].x-agents[i].w/2)*zoom && // if the mouse is over the agent box
        y < (agents[i].y+agents[i].h/2)*zoom && y > (agents[i].y-agents[i].h/2)*zoom) {
        i_select_aux=i; 
    }
  } // END FOR
  return i_select_aux;
}

void agent_selection() {
  int i_select_aux = agent_click(); // choose an agent
  if (i_select_aux!=-1) { // if successful
    if (selection_possible) { // if nothing was selected before
      i_select_agent = i_select_aux; select_type = "AGENT";  selection_possible=false;
    } else 
    if (select_type.equals("AGENT")) { // if previous selection is an agent
      if (i_select_agent==i_select_aux) { // if same agent, deselect
        i_select_agent = -1; select_type = "NULL";  selection_possible=true;
      }
    } else
    if (select_type.equals("NODE")) { // if previous selection is a node, allow agent selection
      i_select_agent = i_select_aux; select_type = "NODE+AGENT";  selection_possible=false;
    }
  } // END AGENT WAS SELECTED
}

void draw_agents() {
  for (int i=0; i < i_cur_agent; i++) {
    // println("color of agent " + i);
    if ((select_type=="AGENT"||select_type=="NODE+AGENT") && i==i_select_agent) {fill(select_color);}
    else {fill(agents[i].agent_color);} 
    if (!agents[i].deleted) {
      rectMode(CENTER);
      rect(agents[i].x/zoom-xo,agents[i].y/zoom-yo,agents[i].w,agents[i].h);
      fill(text_color);
      flex_write_lines_in_box(agents[i].id, default_font_name, default_font_aspect_ratio, 
                              "CENTER", "CENTER", 
                              agents[i].x/zoom-xo, agents[i].y/zoom-yo, agents[i].w, agents[i].h);
    }
  }
}

String create_agent_id(String new_name) { // creates id's (3 letters) for agents
  boolean id_ok = false; String id_aux = "NULL"; 
  String suffix = str(agent_id_suffix); if (suffix.length()==1) {suffix = "0"+suffix;}
  int index1=0, index2=1, index3=2;
  while (!id_ok) {
    // proposal
    if (new_name.length()>=3) {id_aux = str(new_name.charAt(index1)) + str(new_name.charAt(index2)) + str(new_name.charAt(index3++));}
    else if (new_name.length()>=2) {id_aux = str(new_name.charAt(index1)) + str(new_name.charAt(index2++)) + str(0);}
    else if (new_name.length()>=1) {id_aux = str(new_name.charAt(index1)) + str(0) + str(0);}
    // disposal
    if (searchStringIndex(id_aux, agent_ids, 0, i_cur_agent)==-1) {
      id_ok=true;
    }
  }
  println("NEW AGENT ID = " + id_aux);
  return id_aux;
}  


class Agent {
  String id;
  String name;
  float x,y;
  float w,h;
  color agent_color;
  boolean deleted;
  ToolTip tooltip;
  
  Agent (String _name) {
    name = _name; x=-1; y=-1; w=diameter_size; h=diameter_size; deleted = false;
    tooltip = new ToolTip(name, x, y-w, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);
    id = create_agent_id(name); agent_ids[i_cur_agent]=id;
  }

  void delete() {
    // println("deleting agent " + name); //<>//
    deleted = true; 
    // deleted_nodes[num_deleted++]=i;
    for (int j=0; j<i_cur_node; j++) {
      Unit u = (Unit) nodes[j];
      // print4check("Before: Unit " + u.id + "(" + u.unit_agents_counter + " agents)", 0, u.unit_agents_counter, u.unit_agents);
      int k=0; boolean found = false;
      while (k<u.unit_agents_counter && !found) {
        if (u.unit_agents[k].equals(name)) {found = true;} else {k++;}
      } // END FOR EACH UNIT AGENT
      if (found) {println("DELETE"); u.unit_agents = deleteStringByIndex(k, u.unit_agents); u.unit_agents_counter--;}
      // print4check("After: Unit " + u.id + "(" + u.unit_agents_counter + " agents)", 0, u.unit_agents_counter, u.unit_agents);
    } // END FOR EACH UNIT
    update_agents(name,"DEL");
  }

  void modify_name() {
    Agent aux_a;
    String name_aux = showInputDialog("Please enter new agent name", name);
    if (name_aux == null || "".equals(name_aux))
      showMessageDialog(null, "Empty TEXT Input!!!", "Alert", ERROR_MESSAGE);
    else {
      aux_a = searchAgent(name_aux);
      if (aux_a!=null)
        {showMessageDialog(null, "AGENT \"" + name_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);}
      else {
      showMessageDialog(null, "AGENT \"" + name + "\" changed name into " + name_aux, "Info", INFORMATION_MESSAGE);
      for (int i=0; i<i_cur_node; i++) { // update agent name in all units containing it
        Unit u = (Unit) nodes[i];
        u.modify_agent_name(name, name_aux);
      }
      name=name_aux; tooltip.text=name;
      String old_id = id;
      id = create_agent_id(name); 
      replaceString(old_id, id, agent_ids, 0, i_cur_agent);
      }
    }
  }
  
} // END CLASS AGENT




Agent searchAgent(String agent_name) {
  for (int i=0; i<i_cur_agent; i++) {
    if (agents[i].name.equals(agent_name)) {return agents[i];} 
  }
  return null;
}

int searchAgentIndex(String agent_name) {
  for (int i=0; i<i_cur_agent; i++) {
    if (agents[i].name.equals(agent_name)) {return i;} 
  }
  return -1;
}

// agent name layover through tooltip
void agent_layover() {
  // search for the tooltip to display
  float x = mouseX; float y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_agent; i++) { // for each agent 
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
