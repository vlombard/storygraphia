// STORY UNITS: GLOBAL VARIABLES
int max_agents_per_unit;

void unit_settings() {
  max_agents_per_unit = 1000;
}


class Unit extends Node {
  String[] unit_agents; int unit_agents_counter;
  int unit_propp_tag_index; // one of {"Int", "Vio", "Cv", "L", "D", "E", "F", "G", "H", "I", "K", "Rew"}
  String[] unit_preconditions; int unit_preconditions_counter;
  String[] unit_effects; int unit_effects_counter;
  int unit_tension; // between 1 and 100
  
  Unit(float x_aux, float y_aux, float w_aux, float h_aux, String id_aux, String text_aux, String tag_aux) {
    // Node(float x_aux, float y_aux, float w_aux, float h_aux, String id_aux, String text_aux, String tag_aux)
    super(x_aux, y_aux, w_aux, h_aux, id_aux, text_aux, tag_aux);
    unit_agents = new String[max_agents_per_unit]; unit_agents_counter=0;
    unit_propp_tag_index = -1; unit_tension = -1;
    unit_preconditions = new String[max_states]; unit_preconditions_counter=0;
    unit_effects = new String[max_states]; unit_effects_counter=0;
  }

  void show_states() {
     if (unique_event) {
       unique_event=false;
    println("showing states:"); for (int j=0; j<unit_preconditions_counter; j++) {print(" " + unit_preconditions[j]);}
    int number_of_items = preconditions_checkbox.getItems().size();
    // PRECONDITIONS
    for (int j=0; j<number_of_items; j++) {preconditions_checkbox.getItem(j).setState(false);} // all items initialized to false
    for (int i=0; i<unit_preconditions_counter; i++) { // for each precondition state of this node
      for (int j=0; j<number_of_items; j++) { // for each item of preconditions checkbox
        if (preconditions_checkbox.getItem(j).getName().equals(unit_preconditions[i])) { // if the two names coincide
          preconditions_checkbox.getItem(j).setState(true);} // set item state to true 
      }
    }      
    preconditions_checkbox.setPosition((x-w/2-preconditions_checkbox.getWidth())*zoom+xo,y*zoom+yo).show();
    // EFFECTS
    for (int j=0; j<number_of_items; j++) {effects_checkbox.getItem(j).setState(false);} // all items initialized to false
    for (int i=0; i<unit_effects_counter; i++) { // for each effect state of this node
      for (int j=0; j<number_of_items; j++) { // for each item of effects checkbox
        if (effects_checkbox.getItem(j).getName().equals(unit_effects[i])) { // if the two names coincide
          effects_checkbox.getItem(j).setState(true);} // set item state to true 
      }
    }      
    effects_checkbox.setPosition((x+w/2)*zoom+xo,y*zoom+yo).show();
    unique_event=true;
    }
  }

  void modify_preconditions() { 
    println("modifying preconditions:"); for (int i=0; i<unit_preconditions_counter; i++) {print(" " + unit_preconditions[i]);}
    unit_preconditions_counter = 0; int i=0;
    while (!cur_unit_preconditions_from_checkbox[i].equals("NULL STATE") && i<cur_unit_preconditions_from_checkbox.length) {
      // println("modify_preconditions: unit_preconditions_from_checkbox " + i + "= " + cur_unit_preconditions_from_checkbox[i]); 
      unit_preconditions[unit_preconditions_counter] = cur_unit_preconditions_from_checkbox[i];
      unit_preconditions_counter++; i++;
    }
    hide_all_menus(); // tags_checkbox.hide();
    update_constraints_edges_preconditions();
    // initialize_state_list(cur_unit_preconditions_from_checkbox); // reset the temporary list of preconditions
    print("\n modified preconditions:"); for (int j=0; j<unit_preconditions_counter; j++) {print(" " + unit_preconditions[j]);}
  }

  void modify_effects() { 
    println("modifying effects:"); for (int i=0; i<unit_effects_counter; i++) {print(" " + unit_effects[i]);}
    unit_effects_counter = 0; int i=0;
    while (!cur_unit_effects_from_checkbox[i].equals("NULL STATE") && i<cur_unit_effects_from_checkbox.length) {
      // println("modify_effects: unit_effects_from_checkbox " + i + "= " + cur_unit_effects_from_checkbox[i]); 
      unit_effects[unit_effects_counter] = cur_unit_effects_from_checkbox[i];
      unit_effects_counter++; 
      i++;
    }
    hide_all_menus(); // tags_checkbox.hide();
    update_constraints_edges_effects();
    // initialize_state_list(cur_unit_effects_from_checkbox); // reset the temporary list of effects
    // println("modified effects:"); for (int j=0; j<unit_effects_counter; j++) {print(" " + unit_effects[j]);}
  }
  
  void update_constraints_edges_preconditions() { // update edges that get at this node (head)
    // println("update_constraints_edges() for " + i_cur_node + " nodes and " + i_cur_edge + " edges");
    if (plot_generation_mode == "CONSTRAINTS") {
      for (int i=0; i<i_cur_node; i++) { // for each other unit
        Unit ui = (Unit) nodes[i];  
        // *** if ui satisfies all the preconditions of this unit, build an edge (if not already existent)
        int p=0; boolean satisfied = true;
        while (p<unit_preconditions_counter && satisfied) { // ; p++) { // for each precondition of this unit
          boolean found = false;
          for (int is=0; is<ui.unit_effects_counter; is++) { // find an effect that matches this precondition
            if (ui.unit_effects[is].substring(4).equals(unit_preconditions[p].substring(4))) {found=true;} 
          }
          if (!found) {satisfied=false;}
          p++;
        } // END WHILE 
        if (satisfied && search_edge_head_tail_index(searchNodeIdIndex(id), i)==-1) { // if all preconditions matched and edge does not exist, create edge
          // println("unit "+i+".unit_effects["+is+"] = " + ui.unit_effects[is]); println("unit "+j+".unit_preconditions["+js+"] = " + uj.unit_preconditions[js]); 
          edges[i_cur_edge]=new Edge(id, ui.id, "e"+str(i_cur_edge), "NULL"); 
          i_cur_edge++; num_edges++;
        } else 
        if (!satisfied && search_edge_head_tail_index(searchNodeIdIndex(id), i)!=-1) {           
          edges[search_edge_head_tail_index(searchNodeIdIndex(id), i)].delete(); 
          num_edges--;
        } 
      } // END FOR EACH OTHER UNIT
    } // END IF
  }

    void update_constraints_edges_effects() { // update edges that depart from this node (tail)
    // println("update_constraints_edges() for " + i_cur_node + " nodes and " + i_cur_edge + " edges");
    if (plot_generation_mode == "CONSTRAINTS") {
      for (int i=0; i<i_cur_node; i++) { // for each other unit
        Unit ui = (Unit) nodes[i];  
        // *** if this unit satisfies all the preconditions of ui, build an edge (if not already existent)
        int p=0; boolean satisfied = true;
        while (p<ui.unit_preconditions_counter && satisfied) { // ; p++) { // for each precondition of the unit
          boolean found = false;
          for (int is=0; is<unit_effects_counter; is++) { // find an effect that matches this precondition
            if (unit_effects[is].substring(4).equals(ui.unit_preconditions[p].substring(4))) {found=true;} 
          }
          if (!found) {satisfied=false;}
          p++;
        }
        if (satisfied && search_edge_head_tail_index(i, searchNodeIdIndex(id))==-1) {           
          // println("unit "+i+".unit_effects["+is+"] = " + ui.unit_effects[is]); println("unit "+j+".unit_preconditions["+js+"] = " + uj.unit_preconditions[js]); 
          edges[i_cur_edge]=new Edge(ui.id, id, "e"+str(i_cur_edge), "NULL"); 
          i_cur_edge++; num_edges++;
        } else
        if (!satisfied && search_edge_head_tail_index(i, searchNodeIdIndex(id))!=-1) {           
          // println("unit "+i+".unit_effects["+is+"] = " + ui.unit_effects[is]); println("unit "+j+".unit_preconditions["+js+"] = " + uj.unit_preconditions[js]); 
          edges[search_edge_head_tail_index(i, searchNodeIdIndex(id))].delete(); 
          num_edges--;
        }
      } // END FOR EACH OTHER UNIT
    } // END IF
  }

  void show_propp_tag() {
    if (plot_generation_mode == "PROPP") {
    // println("showing propp tag:"); 
    int number_of_items = propp_checkbox.getItems().size();
    if (unique_event) {
      unique_event=false;
      for (int j=0; j<number_of_items; j++) {propp_checkbox.getItem(j).setState(false);} // all items initialized to false
      if (unit_propp_tag_index!=-1) {propp_checkbox.getItem(unit_propp_tag_index).setState(true);}
      float bx = check_horizontal_boundaries(x-(propp_checkbox.getWidth()+3*default_font_width), propp_checkbox.getWidth()+3*default_font_width);
      float by = check_vertical_boundaries(y-propp_checkbox.getHeight(), propp_checkbox.getHeight());
      propp_checkbox.setPosition(bx*zoom+xo,by*zoom+yo).show();
    }
    unique_event = true;
    }
  }

  void modify_propp_tag() {
    unit_propp_tag_index=cur_unit_propp_tag_index;
    x = propp_layout_x[unit_propp_tag_index] - xo;
    hide_all_menus();     
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

  void modify_tension() {    
    int n = int(showInputDialog("Please enter tension:", unit_tension+"[1-100]")); 
    if (n < 1 || n > 100) {
      showMessageDialog(null, "Empty input!!!", "Alert", ERROR_MESSAGE);
    } else {
      unit_tension = n;
      showMessageDialog(null, "Tension \"" + n + "\" successfully added to unit!!!", "Info", INFORMATION_MESSAGE);
      y = tension_position(unit_tension)/zoom-yo;
    }
  }
} // END UNIT CLASS
