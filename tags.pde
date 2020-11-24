Tag[] tags;
String[] tags_names;
int max_tags;
int max_tags_per_node;
int i_cur_tag;

void tags_settings() {
  max_tags = 1000;
  i_cur_tag = 0;
  max_tags_per_node = max_tags;
  tags = new Tag[max_tags];
  tags_names = new String[max_tags];
  // tags_names[0] = "fake_tag_0"; tags_names[1] = "fake_tag_1"; i_cur_tag=2;
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

Tag searchTag(String tag_name) {
  for (int i=0; i<i_cur_tag; i++) { //<>//
    if (tags[i].name.equals(tag_name)) {return tags[i];} 
  }
  return null;
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
    update_tags(tag_aux);
  }
  return tag_aux;
}
  
void update_tags(String tag_name) {
  // println("update_tags: " + tag_name + ", of " + i_cur_tag + " tags");
  // print ("\n tags_checkbox items: "); for (int i=0; i<tags_checkbox.getItems().size(); i++) {print(tags_checkbox.getItem(i).getName() + " ");} print("\n");
  if (searchTag(tag_name)==null) {
    tags_names[i_cur_tag] = tag_name;
    tags[i_cur_tag] = new Tag(tag_name);
    tags_checkbox.addItem(tag_name, i_cur_tag_checkbox++);
    i_cur_tag++;
    tags_color_setup(); 
    //update_menu_tags_colors();
  }
  // println("update_tags: " + i_cur_tag + " tags");
}

void tags_areas_setup() {
  if (i_cur_tag>0) {
    float tag_area_width = (size_x-horizontal_offset) / i_cur_tag;
    if (tag_area_width <= diameter_size) {diameter_size = tag_area_width;} 
    for (int i=0; i < i_cur_tag; i++) {
      tags[i].x_min = horizontal_offset + i*tag_area_width; tags[i].x_max = tags[i].x_min + tag_area_width;
      tags[i].y_min = vertical_offset; tags[i].y_max = size_y;
    }
  }
}


class Tag {
  String name;
  float x_min, x_max, y_min, y_max;
  color tag_color;
  
  Tag (String _name) {
    name = _name;
  }
  
}
