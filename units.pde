// STORY UNITS: GLOBAL VARIABLES
int max_agents_per_unit;

void unit_settings() {
  max_agents_per_unit = 1000;
}


class Unit extends Node {
  String[] unit_agents; int unit_agents_counter;
  String[] preconditions;
  String[] effects;
  String[] actions;
  String[] intentions;
  
  Unit(float x_aux, float y_aux, float w_aux, float h_aux, String id_aux, String text_aux, String tag_aux) {
    // Node(float x_aux, float y_aux, float w_aux, float h_aux, String id_aux, String text_aux, String tag_aux)
    super(x_aux, y_aux, w_aux, h_aux, id_aux, text_aux, tag_aux);
    unit_agents = new String[max_agents_per_unit]; unit_agents_counter=0;
  }
  
  // unit DRAWING
  void draw_unit() {
    // PRINT CHECK: println("Drawing unit " + id);
    draw_unit_agents();
    draw_node();
  } // END draw_node
  
  void draw_unit_agents() {
    //println("draw_unit_agents: " + unit_agents_counter);
    if (unit_agents_counter>0) {
      float arc_interval = TWO_PI / unit_agents_counter; 
      for (int i=0; i<unit_agents_counter; i++) {
        Agent a = searchAgent(unit_agents[i]);
        if (a!=null) {
          stroke(a.agent_color); strokeWeight(margin); // stroke(grey_level); // color: grey filling
          arc(x, y, w+margin, h+margin, i*arc_interval, (i+1)*arc_interval);
        }
      }
    }
  }
  
  void add_unit_agent() {
    String agt_name_aux = showInputDialog("Please enter agent");
    // if (text_aux == null) exit(); else
    if (agt_name_aux == null || agt_name_aux.equals(""))
      showMessageDialog(null, "Empty input!!!", "Alert", ERROR_MESSAGE);
    else if (searchStringIndex(agt_name_aux, unit_agents, 0, unit_agents_counter)!=-1)
      showMessageDialog(null, "Agent \"" + agt_name_aux + "\" already in this unit!!!", "Alert", ERROR_MESSAGE);
    else {
      showMessageDialog(null, "Agent \"" + agt_name_aux + "\" successfully added to unit!!!", "Info", INFORMATION_MESSAGE);
      unit_agents[unit_agents_counter++]=agt_name_aux;
      update_agents(agt_name_aux);
    }
  }

}
