PrintWriter storyprint; // file that contains the story print

void headerStoryCountAndPrint() {
  storyprint = createWriter("storyprints/"+graph_name+"_storyprint.txt");
  storyprint.println("STORYGRAPHIA STORY PRINT"); // header 
  storyprint.println("===================================================== \n"); 
  int num_stories = storyCountAndPrint("", "", -1, 0); // empty story, empty unit list, no last unit, 0 stories
  storyprint.println("===================================================== \n"); 
  float ratio = (float) num_stories / i_cur_node;
  storyprint.println(" STORYGRAPHIA, " + num_stories + " potential linear stories, ratio " + ratio); 
  storyprint.flush();
}

String unitType(Unit u) { // returns one of {"START", "MIDDLE", "END", "NULL"}
  String unit_type = "NULL"; 
  boolean head_b = false; boolean tail_b = false; // default: isolated "NULL" unit 
  for (int i=0; i<i_cur_edge;i++) {if (edges[i].head_id==u.id) {head_b = true;}} // is unit head of at least one edge?
  for (int i=0; i<i_cur_edge;i++) {if (edges[i].tail_id==u.id) {tail_b = true;}} // is unit tail of at least one edge?
  if (head_b && tail_b) {unit_type = "MIDDLE";} else 
  if (head_b) {unit_type = "END";} else
  if (tail_b) {unit_type = "START";}
  return unit_type;
}

int storyCountAndPrint(String preStory, String unit_list, int lastUnitIndex, int preCount) { 
  String story = preStory; int count = preCount; String list = unit_list;
  // for each node
  for (int i=0; i<i_cur_node; i++) {
    Unit u = (Unit) nodes[i];
    if (story.equals("")) {// if story is empty string 
      if (unitType(u).equals("START") && lastUnitIndex==-1) { // if unit type == START and no previous unit
        String new_story = story + "\n" + u.text; // set story to unit text and call this function recursively
        int ret = storyCountAndPrint(new_story, list+str(i), i, count);
        if (ret==-1) {println("ERROR IN START STORY UNIT CHAINING!"); return -1;} else {count = ret;}
      } // END if correct START
    } else { // else (story is not empty)
      int edge_index = search_edge_head_tail_index(i,lastUnitIndex);
      if (edge_index!=-1) {// if lastUnit is a previous unit of the current one  
        String new_story = story + "\n-\n--> " + edges[edge_index].label + "\n-\n" + u.text; // add unit text to story        
        if (unitType(u).equals("END")) { // if unit type = END 
          // increment count and print story in the output file; then exit
          count++;
          storyprint.write("\n" + count + ": " + list+"-"+str(i) + "\n" + new_story + "\n+++++++++++++++++");
          println(count + " " + new_story);
          //return count;
        } else {// else 
          if (unitType(u).equals("MIDDLE")) { // if unit type = MIDDLE
            int ret = storyCountAndPrint(new_story, list+str(i), i, count); // call this function recursively
            if (ret==-1) {println("ERROR IN CONTINUING STORY UNIT CHAINING!"); return -1;} // if error, return -1
            else {count = ret;}
          }
        }
      }
    }
  }
  storyprint.flush();
  return count;
}
