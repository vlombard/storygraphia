// ******** ****************************** ************ 
// ******** **** EXPORT GENERIC GRAPH **** ************ 
// ******** ****************************** ************ 

File cur_selection = null;

void write_storygraph(File selection) { // responds to command 'w'; File is a Java class
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    cur_selection = selection;
    println("User selected " + selection.getAbsolutePath());
    JSONObject json_graph; json_graph = new JSONObject();
    // save graph name
    json_graph.setString("name", graph_name);
    // save nodes
    JSONArray json_nodes; json_nodes = new JSONArray(); int node_counter=0;
    for (int i=0; i<i_cur_node; i++) {
      Unit u = (Unit) nodes[i];
      if (!nodes[i].deleted) {
        JSONObject json_node = new JSONObject();
        json_node.setString("id", u.id);
        json_node.setString("text", u.text);
        json_node.setFloat("x", u.x);
        json_node.setFloat("y", u.y);
        json_node.setFloat("w", u.w);
        json_node.setFloat("h", u.h);
        // TAGS: save unit tags: first tag is the characterizing tag for positioning 
        JSONArray json_unit_tags; json_unit_tags = new JSONArray();
        for (int j=0; j<u.node_tags_counter; j++) {
          JSONObject json_tag = new JSONObject(); json_tag.setString(str(j), u.node_tags[j]);
          json_unit_tags.setJSONObject(j,json_tag);
        }
        json_node.setJSONArray("unit tags", json_unit_tags);
        // MEDIA: save node image 
        if (u.media_type.equals("image")) {
          json_node.setString("media_type", "image");
          u.node_image.save(u.id+"_img.png");
          json_node.setString("node_image", u.id+"_img.png");
        } else {json_node.setString("media_type", "null");}
        // PROPP TAG
        json_node.setFloat("unit propp tag index", u.unit_propp_tag_index);
        // CONSTRAINTS: preconditions and effects
        JSONArray json_unit_preconditions; json_unit_preconditions = new JSONArray();
        for (int j=0; j<u.unit_preconditions_counter; j++) {
          JSONObject json_precondition = new JSONObject(); json_precondition.setString(str(j), u.unit_preconditions[j]);
          json_unit_preconditions.setJSONObject(j,json_precondition);
        }
        json_node.setJSONArray("unit preconditions", json_unit_preconditions);
        JSONArray json_unit_effects; json_unit_effects = new JSONArray();
        for (int j=0; j<u.unit_effects_counter; j++) {
          JSONObject json_effect = new JSONObject(); json_effect.setString(str(j), u.unit_effects[j]);
          json_unit_effects.setJSONObject(j,json_effect);
        }
        json_node.setJSONArray("unit effects", json_unit_effects);
        // TENSION
        json_node.setInt("unit tension", u.unit_tension);
        // save unit agents
        JSONArray json_unit_agents; json_unit_agents = new JSONArray();
        for (int j=0; j<u.unit_agents_counter; j++) {
          JSONObject json_agent = new JSONObject(); json_agent.setString(str(j), u.unit_agents[j]);
          json_unit_agents.setJSONObject(j,json_agent);
        }
        json_node.setJSONArray("unit agents", json_unit_agents);
        
        json_nodes.setJSONObject(node_counter++, json_node);
      }
    }
    json_graph.setJSONArray("units", json_nodes);
    // save edges
    JSONArray json_edges; json_edges = new JSONArray(); int edge_counter=0;
    for (int i=0; i<i_cur_edge; i++) {
      if (!edges[i].deleted) {
        JSONObject json_edge = new JSONObject();
        //   Node head, tail; String id; // edge identifier String label;
        json_edge.setString("id", edges[i].id);
        json_edge.setString("label", edges[i].label);
        json_edge.setString("head", edges[i].head_id);
        json_edge.setString("tail", edges[i].tail_id);

        json_edges.setJSONObject(edge_counter++, json_edge);
      }
    }
    json_graph.setJSONArray("edges", json_edges);
    // save agents
    JSONArray json_agents; json_agents = new JSONArray(); int agent_counter=0;
    for (int i=0; i<i_cur_agent; i++) {
      // if (!agents[i].deleted) {
        JSONObject json_agent = new JSONObject();
        //   Node head, tail; String id; // edge identifier String label;
        json_agent.setString("name", agents[i].name);

        json_agents.setJSONObject(agent_counter++, json_agent);
      //}
    }
    json_graph.setJSONArray("agents", json_agents);
    // save tags
    JSONArray json_tags; json_tags = new JSONArray(); int tag_counter=0;
    for (int i=0; i<i_cur_tag; i++) {
      JSONObject json_tag = new JSONObject();
      json_tag.setString("name", tags[i].name);
      json_tags.setJSONObject(tag_counter++, json_tag);
    }
    json_graph.setJSONArray("tags", json_tags);
    // save states (preconditions and effects)
    JSONArray json_states; json_states = new JSONArray(); int state_counter=0;
    for (int i=0; i<i_cur_state; i++) {
      JSONObject json_state = new JSONObject();
      json_state.setString("name", states_names[i]);
      json_states.setJSONObject(state_counter++, json_state);
    }
    json_graph.setJSONArray("states", json_states);
    // write array in file
    saveJSONObject(json_graph, selection.getAbsolutePath());
  }
}


void write_twine_graph(File selection) { // responds to Twine export button; File is a Java class
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    cur_selection = selection;
    println("User selected " + selection.getAbsolutePath());
    // preamble of the HTML file
    // String[] preamble = {"<!DOCTYPE html>","<html>","<head>","<meta charset=\"utf-8\">",
                      // "<meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">","<title>",
                      // graph_name,
                      // "</title>","</head>","<body>"};
    String preamble = "<!DOCTYPE html>"+"\n<html>"+"\n<head>"+"\n<meta charset=\"utf-8\">"+
                      "\n<meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">"+"\n<title>"+
                      graph_name+
                      "\n</title>"+"\n</head>"+"\n<body>";
    String postamble = "\n</body>"+"\n</html>";
    
    // XML structure of story graph  
    XML tw_storydata; tw_storydata = new XML("tw-storydata");
    tw_storydata.setString("name",graph_name);
    tw_storydata.setString("creator","Storygraphia");
    tw_storydata.setString("creator-version","0.9.3");
    tw_storydata.setString("format","Harlowe");
    tw_storydata.setString("format-version","3.3.3");
    tw_storydata.setString("tags","");
    tw_storydata.setString("zoom","1");
    
    XML[] tw_passagedatae; tw_passagedatae = new XML[i_cur_node]; 
    
    // for each unit 
    for (int i=0; i<i_cur_node; i++) {
      Unit u = (Unit) nodes[i];
      if (!nodes[i].deleted) {
        tw_passagedatae[i] = new XML("tw-passagedata");
        // create attributes-values from unit data
        tw_passagedatae[i].setString("pid",str(i));
        tw_passagedatae[i].setString("name",u.id);
        // tags
        String tags = "";
        for (int t=0; t<u.node_tags_counter; t++) {
          tags = tags + u.node_tags[t];
        }
        tw_passagedatae[i].setString("tags",tags);
        tw_passagedatae[i].setString("position",str(u.x+actual_width/2)+","+str(u.y+actual_height/2));
        float unit_side = (actual_width+actual_height)/i_cur_node;
        tw_passagedatae[i].setString("size",str(unit_side)+","+str(unit_side));
        // create content string c from text
        String content = "\n"+u.text;
        // for each edge
        for (int j=0; j<i_cur_edge; j++) {
          Edge e = (Edge) edges[j];
          if (!edges[j].deleted) {
          // if the edge has this unit as tail
            if (e.tail_id.equals(u.id)) {
              // accumulate content in the content string c 
              content = content + "\n" + "[[" + e.label + "|" + e.head_id + "]]";
            } // END if tail = u
        } // END if edge not deleted
      } // END for each edge
      // setContent c
      tw_passagedatae[i].setContent(content);
      // addChild to array tw_passagedatae
      tw_storydata.addChild(tw_passagedatae[i]);
      } // END if node not deleted
    } // END for each unit
    PrintWriter output;
    // Create a new file in the sketch directory
    output = createWriter(selection.getAbsolutePath()); 
    output.println(preamble);
    output.println(tw_storydata.toString());
    //saveXML(tw_storydata,selection.getAbsolutePath());
    output.println(postamble);
    output.flush();
    output.close();
  }
}


// ******** ****************************** ************ 
// ******** **** IMPORT GENERIC GRAPH **** ************ 
// ******** ****************************** ************ 

void load_storygraph(File selection) { // File is a Java class
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    cur_selection = selection;
    JSONObject json_graph;
    json_graph = loadJSONObject(selection.getAbsolutePath());
    // load name
    graph_name = json_graph.getString("name");
    // load nodes
    JSONArray json_nodes = json_graph.getJSONArray("units"); i_cur_node=json_nodes.size();
    for (int i=0; i<i_cur_node; i++) {
      JSONObject json_node = json_nodes.getJSONObject(i);
      //println("load_storygraph: node is " + json_node.getString("id"));
      // Node(float x_aux, float y_aux, String id_aux, String text_aux, String tag_aux)
      Unit u = new Unit(json_node.getFloat("x"), json_node.getFloat("y"), 
                          json_node.getFloat("w"), json_node.getFloat("h"), 
                          json_node.getString("id"), json_node.getString("text"), "NULL TAG");   
      // TAGS
      JSONArray json_unit_tags = json_node.getJSONArray("unit tags"); int tags_number=json_unit_tags.size();
      if (tags_number > 0) {
        u.node_tags_counter = tags_number; 
        for (int j=0; j<u.node_tags_counter; j++) {
          JSONObject json_tag = new JSONObject(); json_tag = json_unit_tags.getJSONObject(j);
          u.node_tags[j] = json_tag.getString(str(j)); update_tags(u.node_tags[j], "ADD");
          // println("load_storygraph: tag " + u.node_tags[j]);
        }  
      } else {u.node_tags_counter = 0;}
      // MEDIA 
      if (json_node.getString("media_type")!=null) {
        u.media_type = json_node.getString("media_type");
        if (u.media_type.equals("image")) {u.node_image = loadImage(json_node.getString("node_image"));}
      }
      // PROPP TAG
      u.unit_propp_tag_index = json_node.getInt("unit propp tag index");
      // STATES (preconditions and effects)
      JSONArray json_unit_preconditions = json_node.getJSONArray("unit preconditions"); 
      int preconditions_number=json_unit_preconditions.size();
      if (preconditions_number > 0) {
        u.unit_preconditions_counter = preconditions_number; 
        for (int j=0; j<u.unit_preconditions_counter; j++) {
          JSONObject json_precondition = new JSONObject(); json_precondition = json_unit_preconditions.getJSONObject(j);
          u.unit_preconditions[j] = json_precondition.getString(str(j)); println(u.unit_preconditions[j].substring(4)); update_states(u.unit_preconditions[j].substring(4));
        }  
      } else {u.unit_preconditions_counter = 0;}
      JSONArray json_unit_effects = json_node.getJSONArray("unit effects"); 
      int effects_number=json_unit_effects.size();
      if (effects_number > 0) {
        u.unit_effects_counter = effects_number; 
        for (int j=0; j<u.unit_effects_counter; j++) {
          JSONObject json_effect = new JSONObject(); json_effect = json_unit_effects.getJSONObject(j);
          u.unit_effects[j] = json_effect.getString(str(j)); println(u.unit_effects[j].substring(4)); update_states(u.unit_effects[j].substring(4));
        }  
      } else {u.unit_effects_counter = 0;}
      // TENSION
      u.unit_tension = json_node.getInt("unit tension");
      // AGENTS
      // println("load_storygraph: agents are " + u.unit_agents_counter);
      JSONArray json_unit_agents = json_node.getJSONArray("unit agents"); u.unit_agents_counter=json_unit_agents.size();
        // println("load_storygraph: agents are " + u.unit_agents_counter);
      for (int j=0; j<u.unit_agents_counter; j++) {
        JSONObject json_agent = new JSONObject(); json_agent = json_unit_agents.getJSONObject(j);
        u.unit_agents[j] = json_agent.getString(str(j));
        // println("load_storygraph: agent " + u.unit_agents[j]);
      }
      nodes[i]=u;
    }
    // load edges
    JSONArray json_edges = json_graph.getJSONArray("edges"); i_cur_edge=json_edges.size();
    for (int i=0; i<i_cur_edge; i++) {
      JSONObject json_edge = json_edges.getJSONObject(i);
      // Edge(Node head_aux, Node tail_aux, String id_aux, String label_aux)
      int head_index = searchNodeIdIndex(json_edge.getString("head"));
      int tail_index = searchNodeIdIndex(json_edge.getString("tail"));
      edges[i] = new Edge(nodes[head_index].id, nodes[tail_index].id, json_edge.getString("id"), json_edge.getString("label"));
      // println("new edge: " + edges[i].id);
    }
    // load agents
    JSONArray json_agents = json_graph.getJSONArray("agents"); 
    for (int i=0; i<json_agents.size(); i++) {
      JSONObject json_agent = json_agents.getJSONObject(i);
      update_agents(json_agent.getString("name"), "ADD");
    }
    // load tags
    JSONArray json_tags = json_graph.getJSONArray("tags"); 
    for (int i=0; i<json_tags.size(); i++) {
      JSONObject json_tag = json_tags.getJSONObject(i);
      update_tags(json_tag.getString("name"), "ADD");
    }
    // load states
    JSONArray json_states = json_graph.getJSONArray("states"); 
    for (int i=0; i<json_states.size(); i++) {
      JSONObject json_state = json_states.getJSONObject(i);
      update_states(json_state.getString("name"));
    }
  }
}

// ******** ********************************************* ************ 
// ******** INIT STORYGRAPH FROM TEXT FILE (ONE LINE PER NODE) ********** 
// ******** ********************************************* ************ 
void load_storytext(File selection) { // File is a Java class
  noLoop();
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String[] lines = loadStrings(selection);
    String cur_tag = "NULL TAG"; // tags[i_cur_tag++]=new Tag(cur_tag);
    for (int i = 0; i < lines.length; i++) {
      println("lines["+str(i)+"]= " + lines[i]);
      if (!lines[i].equals("")) {
        if (lines[i].charAt(0)=='[') { // this is a tag line
          // add this to tags
          cur_tag = lines[i]; update_tags(cur_tag, "ADD"); println(cur_tag + " is a TAG!");
        } else { // this is a node line
          // Node(float x_aux, float y_aux, String id_aux, String text_aux, String tag_aux)
          nodes[i_cur_node++] = new Unit(random(left_offset/zoom-xo,(left_offset+actual_width)/zoom-xo), 
                                         random(top_offset/zoom-yo,(top_offset+actual_height)/zoom-yo), 
                                         diameter_size, diameter_size, 
                                         "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, 
                                         lines[i], cur_tag);  
        }
      }
    }
    tags_areas_setup();
    // for (int i = 0; i < i_cur_tag; i++) {println(i + ", x_min =" + tags[i].x_min + ", x_max =" + tags[i].x_max + ", y_min =" + tags[i].y_min + ", y_max =" + tags[i].y_max);}
    for (int i = 0; i < i_cur_node; i++) {
      println(nodes[i].node_tags[0]);
      if (nodes[i].node_tags[0]!=null) {
        Tag t = searchTag(nodes[i].node_tags[0]);
        println(t.name + ": " + t.x_min);
        nodes[i].x = random(t.x_min - xo, t.x_max - xo); nodes[i].y = random(t.y_min - yo, t.y_max - yo);
      }
    }
  }
  loop();
  for (int i = 0; i < i_cur_node; i++) {print(nodes[i] + ", ");} print("\n");
}
