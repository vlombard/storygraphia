// ******** ****************************** ************ 
// ******** **** EXPORT GENERIC GRAPH **** ************ 
// ******** ****************************** ************ 

void write_storygraph(File selection) { // responds to command 'w'; File is a Java class
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
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
        json_node.setString("tag", u.tag);
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

    // write array in file
    saveJSONObject(json_graph, selection.getAbsolutePath());
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
      Unit u = new Unit(json_node.getFloat("x")*zoom, json_node.getFloat("y")*zoom, 
                          json_node.getFloat("w")*zoom, json_node.getFloat("h")*zoom, 
                          json_node.getString("id"), json_node.getString("text"), json_node.getString("tag"));       
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
      println("new edge: " + edges[i].id);
    }
    // load agents
    JSONArray json_agents = json_graph.getJSONArray("agents"); 
    for (int i=0; i<json_agents.size(); i++) {
      JSONObject json_agent = json_agents.getJSONObject(i);
      update_agents(json_agent.getString("name"));
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
    for (int i = 0; i < lines.length; i++) {
      println("lines["+str(i)+"]= " + lines[i]);
      if (!lines[i].equals("")) {
        // Node(float x_aux, float y_aux, String id_aux, String text_aux, String tag_aux)
        nodes[i_cur_node++] = new Unit(random(-xo,width-xo), random(-yo,height-yo), diameter_size, diameter_size, 
                                       "N" + str(hour()) + str(minute()) + str(second()) + node_counter++, lines[i], "NULL TAG");  
      }
    } 
  }
  loop();
  for (int i = 0; i < i_cur_node; i++) {print(nodes[i] + ", ");} print("\n");
}
