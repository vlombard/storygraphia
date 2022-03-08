// LIBRARY FOR TAGS

Tag[] tags;
String[] tag_ids; int tag_id_suffix = 0; // Tag id's are printed in the tag box
int total_tags;
int i_cur_tag;
int i_select_tag;

void tags_settings() {
  total_tags = 1000;
  i_cur_tag = 0;
  i_select_tag = -1;
}

void tags_setup() {
  tags = new Tag[total_tags];
  tag_ids = new String[total_tags];
}

void tags_color_setup() {
  colorMode(HSB, 360, 100, 100);
  if (i_cur_tag>0) {
    float color_interval = 360 / i_cur_tag; float start = 0; //random(360);
    for (int i=0; i < i_cur_tag; i++) {
      tags[i].tag_color = color((start+color_interval*i)%360,30,100);
    }
  }
}

void tags_position_setup() {
  if (i_cur_tag>0) {
    float tag_height = actual_height / i_cur_tag; // computes box height
    if (tag_height >= diameter_size) {tag_height=diameter_size;} // not more than diameter_size
    for (int i=0; i < i_cur_tag; i++) {
      tags[i].h = tag_height; tags[i].w = right_offset; // rectangle
      tags[i].x = width - tags[i].w/2; tags[i].y = top_offset + (tag_height + margin)*(i + 0.5);
      tags[i].tooltip.x = tags[i].x; tags[i].tooltip.y = tags[i].y;
    }
  }
}

void update_tags(String tag_name, String mode) {
  // println("update_tags: " + tag_name + ", of " + i_cur_tag + " tags");
  // print ("\n tags_checkbox items: "); for (int i=0; i<tags_checkbox.getItems().size(); i++) {print(tags_checkbox.getItem(i).getName() + " ");} print("\n");
  switch (mode) {
    case("ADD"):
      if (searchTag(tag_name)==null) {
        tags[i_cur_tag] = new Tag(tag_name);
        tags_checkbox.addItem(tag_name, i_cur_tag_checkbox++);
        i_cur_tag++;
      }
    break;
    case("DEL"):
      Tag[] tags_aux = new Tag[i_cur_tag-1]; String[] tag_ids_aux = new String[i_cur_tag-1];
      int index = searchTagIndex(tag_name);
      if (index!=-1) {
        for (int i=0; i<index; i++) {tags_aux[i]=tags[i]; tag_ids_aux[i]=agent_ids[i];}
        for (int i=index; i<i_cur_tag-1; i++) {tags_aux[i]=tags[i+1]; tag_ids_aux[i]=tag_ids[i+1];}
        for (int i=0; i<tags_aux.length; i++) {tags[i]=tags_aux[i]; tag_ids[i]=tag_ids_aux[i];}
        i_cur_tag--;
      }
    break;
  } // END SWITCH
  tags_color_setup(); 
  tags_position_setup();
  // println("update_tags: " + i_cur_tag + " tags");
}

int tag_click() {
  int i_select_aux=-1;
  float x = mouseX; float y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_tag; i++) { // for each agent 
    if (x < (tags[i].x+tags[i].w/2)*zoom && x > (tags[i].x-tags[i].w/2)*zoom && // if the mouse is over the tag box
        y < (tags[i].y+tags[i].h/2)*zoom && y > (tags[i].y-tags[i].h/2)*zoom) {
        i_select_aux=i; 
    }
  } // END FOR
  return i_select_aux;
}

void tag_selection() {
  int i_select_aux = tag_click(); // choose an agent
  if (i_select_aux!=-1) { // if successful
    if (selection_possible) { // if nothing was selected before
      i_select_tag = i_select_aux; select_type = "TAG";  selection_possible=false;
    } else 
    if (select_type.equals("TAG")) { // if previous selection is an agent
      if (i_select_tag==i_select_aux) { // if same agent, deselect
        i_select_tag = -1; select_type = "NULL";  selection_possible=true;
      }
    //} else
    //if (select_type.equals("NODE")) { // if previous selection is a node, allow agent selection
    //  i_select_agent = i_select_aux; select_type = "NODE+AGENT";  selection_possible=false;
    }
  } // END TAG WAS SELECTED
}

void draw_tags() {
  for (int i=0; i < i_cur_tag; i++) {
    // println("color of tag " + i);
    if ((select_type=="TAG") && i==i_select_tag) {fill(select_color);} // ||select_type=="NODE+AGENT")
    else {fill(tags[i].tag_color);} 
    if (!tags[i].deleted) {
      rectMode(CENTER);
      rect(tags[i].x/zoom-xo,tags[i].y/zoom-yo,tags[i].w,tags[i].h);
      fill(text_color);
      flex_write_lines_in_box(tags[i].id, default_font_name, default_font_aspect_ratio, 
                              "CENTER", "CENTER", 
                              tags[i].x/zoom-xo, tags[i].y/zoom-yo, tags[i].w, tags[i].h);
    }
  }
}


Tag searchTag(String tag_name) {
  for (int i=0; i<i_cur_tag; i++) {
    if (tags[i].name.equals(tag_name)) {return tags[i];} 
  }
  return null;
}

int searchTagIndex(String tag_name) {
  for (int i=0; i<i_cur_tag; i++) {
    if (tags[i].name.equals(tag_name)) {return i;} 
  }
  return -1;
}

void initialize_tag_list(String[] tag_list) {
  for (int i=0; i<tag_list.length; i++) {
    tag_list[i]="NULL TAG";
  }
}

String create_tag() {
  String tag_aux = showInputDialog("Please enter new tag");
  if (tag_aux == null || "".equals(tag_aux))
    showMessageDialog(null, "Empty tag!!!", "Alert", ERROR_MESSAGE);
  else if (searchTag(tag_aux)!=null)
    showMessageDialog(null, "ID \"" + tag_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);
  else {
    showMessageDialog(null, "ID \"" + tag_aux + "\" successfully added!!!", "Info", INFORMATION_MESSAGE);
    update_tags(tag_aux, "ADD");
  }
  return tag_aux;
}
  

void tags_areas_setup() {
  if (i_cur_tag>0) {
    float tag_area_width = (size_x-left_offset) / i_cur_tag;
    if (tag_area_width <= diameter_size) {diameter_size = tag_area_width;} 
    for (int i=0; i < i_cur_tag; i++) {
      tags[i].x_min = left_offset + i*tag_area_width; tags[i].x_max = tags[i].x_min + tag_area_width;
      tags[i].y_min = top_offset; tags[i].y_max = size_y;
    }
  }
}

String create_tag_id(String new_name) { // creates id's (3 letters) for tags
  boolean id_ok = false; String id_aux = "NULL"; 
  String suffix = str(tag_id_suffix); if (suffix.length()==1) {suffix = "0"+suffix;}
  int index1=0, index2=1, index3=2;
  while (!id_ok) {
    // proposal
    if (new_name.length()>=3) {id_aux = str(new_name.charAt(index1)) + str(new_name.charAt(index2)) + str(new_name.charAt(index3++));}
    else if (new_name.length()>=2) {id_aux = str(new_name.charAt(index1)) + str(new_name.charAt(index2++)) + str(0);}
    else if (new_name.length()>=1) {id_aux = str(new_name.charAt(index1)) + str(0) + str(0);}
    // disposal
    if (searchStringIndex(id_aux, tag_ids, 0, i_cur_tag)==-1) {
      id_ok=true;
    }
  }
  println("NEW TAG ID = " + id_aux);
  return id_aux;
}  

// tag name layover through tooltip
void tag_layover() {
  // search for the tooltip to display
  float x = mouseX; float y = mouseY; // capture mouse position
  for (int i=0; i<i_cur_tag; i++) { // for each tag 
    ToolTip tt = tags[i].tooltip; 
    if (x < (tags[i].x+tags[i].w/2)*zoom && x > (tags[i].x-tags[i].w/2)*zoom) { // if the mouse is over such tag box
      if (y < (tags[i].y+tags[i].h/2)*zoom && y > (tags[i].y-tags[i].h/2)*zoom) {
        tt.x= x-xo; tt.y= y-yo; 
        color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
        tt.setBackground(c); // color(0,80,255,30));
        tt.display();
      }
    }
  } // END FOR
} 

class Tag {
  String name;
  String id;
  float x,y;
  float w,h;
  float x_min, x_max, y_min, y_max;
  color tag_color;
  boolean deleted;
  ToolTip tooltip;
  
  Tag (String _name) {
    name = _name; x=-1; y=-1; w=right_offset; h=diameter_size; deleted = false;
    tooltip = new ToolTip(name, x, y-w, size_x/2, size_y/2, default_font_name, default_font_size, default_font_aspect_ratio);
    id = create_tag_id(name); tag_ids[i_cur_tag]=id;
  }
 
  void delete() {
    // println("deleting tag " + name);
    deleted = true; 
    for (int j=0; j<i_cur_node; j++) {
      Node n = nodes[j];
      // print4check("Before: Unit " + u.id + "(" + u.unit_tags_counter + " agents)", 0, u.unit_tags_counter, u.unit_tags);
      int k=0; boolean found = false;
      while (k<n.node_tags_counter && !found) {
        if (n.node_tags[k].equals(name)) {found = true;} else {k++;}
      } // END FOR EACH UNIT AGENT
      if (found) {println("DELETE"); n.node_tags = deleteStringByIndex(k, n.node_tags); n.node_tags_counter--;}
      // print4check("After: Node " + n.id + "(" + n.node_tags_counter + " tags)", 0, n.node_tags_counter, n.node_tags);
    } // END FOR EACH NODE
    update_tags(name,"DEL");
  }
  
  void modify_name() {
    Tag aux_a;
    String name_aux = showInputDialog("Please enter new tag", name);
    if (name_aux == null || "".equals(name_aux))
      showMessageDialog(null, "Empty TEXT Input!!!", "Alert", ERROR_MESSAGE);
    else {
      aux_a = searchTag(name_aux);
      if (aux_a!=null)
        {showMessageDialog(null, "TAG \"" + name_aux + "\" exists already!!!", "Alert", ERROR_MESSAGE);}
      else {
      showMessageDialog(null, "TAG \"" + name + "\" changed name into " + name_aux, "Info", INFORMATION_MESSAGE);
      for (int i=0; i<i_cur_node; i++) { // update agent name in all units containing it
        nodes[i].modify_tag_name(name, name_aux);
      }
      name=name_aux; tooltip.text=name;
      String old_id = id;
      id = create_tag_id(name); 
      replaceString(old_id, id, tag_ids, 0, i_cur_tag);
      }
    }
  }  
}
