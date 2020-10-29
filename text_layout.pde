// ##########################################################
// LIBRARY FOR TEXT LAYOUT 
// ##########################################################

// TEXT GLOBAL VARIABLES
float default_font_size = 12;
String default_font_name = "SansSerif";
float default_font_aspect_ratio = 0.6; // 0.525;
PFont default_font_type;
color text_color;

void text_setup() {
  default_font_type = createFont(default_font_name, default_font_size); textFont(default_font_type); 
}


// split a string into lines of certain length, returning an array of strings
String[] split_string_into_lines (String s, float line_size) {
  // println("\ns = " + s + " and line size = " + line_size); 
  // extract all the original lines, according to RETURNs
  String[] words = split_text_into_words (s);  // for (int k=0; k < words.length; k++) {if (words[k].length() > line_size) {String[] s_={" "}; return s_;}}
  String original_lines[] = split(s, "\n");
  String actual_lines1[] = new String[s.length()]; // print("\n actual_lines1.length = " + actual_lines1.length);
  // count actual lines: for each line, split the string according to BLANKs or UNDERSCOREs, then split into words, count characters
  int line_count = 0; 
  for (int i = 0; i < original_lines.length; i++) {
    // words = split (original_lines[i], " "); 
    words = split_text_into_words(original_lines[i]); 
    int j = 0; 
    // print("\n number of words = " + words.length); for (int k = 0; k < words.length; k++) {print(" " + words[k]);} print("\n");
    while (j < words.length) { 
      int total_chars = 0; 
      String s_aux = "";
      while (j < words.length && total_chars + words[j].length()+1 < line_size) { // while there are words and do not exceed line size
        // println(j + " words[j] = " + words[j] + ", length " + words[j].length());
        total_chars = total_chars + words[j].length() + 1;  
        s_aux = s_aux + " " + words[j]; 
        j++; 
        s_aux = s_aux + " ";
      } // while char under single line size
      // print("\n line_count = " + line_count + " and j = " + j);
      if (s_aux.equals("")) {
        s_aux = " ..."; 
        j = words.length;
      }
      actual_lines1[line_count] = s_aux; 
      line_count++;
    } // END while all the words
  } // END for each line
  // fill actual lines to be returned
  String[] actual_lines = new String[line_count]; 
  for (int k = 0; k < line_count; k++) {
    actual_lines[k] = actual_lines1[k];
  } // END for each line
  return actual_lines;
}


// gives some text lines, computes the size of the box that contains it
int[] box_size(String lines[], int font_size) {
  int[] total_w_h = {0, 0}; 
  int curWidth = 0; 
  for (int i=0; i<lines.length; i++) {
    total_w_h[1] = total_w_h[1] + font_size;
    curWidth = (int) textWidth(lines[i]);
    if (int(curWidth) > int(total_w_h[0])) {
      total_w_h[0] = curWidth;
    }
  }
  total_w_h[1] = total_w_h[1] + font_size;
  return total_w_h;
}

// split a string into words (" ", "_")
String[] split_text_into_words (String text) {
  String[] words = split (text, " "); 
  if (words.length<=1) {
    words = splitTokens (text, "_-,;");
  }
  return words;
}

int longest_word (String[] words) {
  int max=0;
  for (int i=0; i<words.length; i++) {
    if (max < words[i].length()) {
      max = words[i].length();
    }
  }
  return max;
}

// combine words into lines of certain length, returning an array of strings
String[] combine_words_into_lines (String[] words, int line_size_in_characters) {
  // initialize a temporary array of lines that is as large as the number of words
  String[] actual_lines1 = new String[words.length+1]; 
  for (int i=0; i<words.length; i++) {actual_lines1[i]="";}
  // count actual lines: for each line, assemble words, count characters
  int line_count = 0;  
  for (int i = 0; i < words.length; i++) { // for each word    
    if (actual_lines1[line_count].length() + words[i].length() + 1 <= line_size_in_characters) { // while there are words and do not exceed line size
      actual_lines1[line_count] = actual_lines1[line_count] + words[i] + " "; 
    } else { 
      line_count = line_count+1; 
      actual_lines1[line_count] = words[i] + " "; // actual_lines1[line_count] + words[i] + " ";
    }
  } // END for each word
  // fill actual lines to be returned
  String[] actual_lines = new String[line_count+1]; 
  for (int k = 0; k < line_count+1; k++) {actual_lines[k] = actual_lines1[k];}
  
  return actual_lines;
}

// given some box, with x,y corner + width + height and some text and font size write the text in the box, if capable enough
void flex_write_lines_in_box(String text, String font_type, float font_aspect_ratio, String x_align, String y_align, float x_center, float y_center, float x_width, float y_height) {
  // println(" = flex_write_lines_in_box = text: " + text + "; x_width: " + x_width);
  String[] words = split_text_into_words (text);
  //println(" = flex_write_lines_in_box = words[0]: " + words[0]);
  if (x_width >= y_height * 0.33) { //  
    // println("#### flex_write_lines_in_box x_width = " + x_width + "; y_height = " + y_height + ": GO HORIZONTAL!!!");
    float font_size = determine_font_size (words, font_aspect_ratio, x_width, y_height);
    //println(" = flex_write_lines_in_box = font_size: " + font_size);
    int line_size = int (x_width / (font_size * font_aspect_ratio)); // in terms of characters 
    // println(" = flex_write_lines_in_box = line_size: " + line_size);
    String lines[] = combine_words_into_lines (words, line_size); 
    // println("number of lines = " + lines.length);
    float x = x_center; float y = y_center; 
    if (font_size>0) {
      PFont tfont = createFont(font_type, font_size); textFont(tfont);
      if (x_align.equals("LEFT") && y_align.equals("CENTER")) {
        textAlign(LEFT, CENTER); x = x_center - x_width/2; 
        if (lines.length%2!=0) {y = y_center-floor(lines.length*0.5)*font_size;} else {y = y_center-(lines.length*0.5*font_size);}
      } else if (x_align.equals("LEFT") && y_align.equals("TOP")) {
        textAlign(LEFT, TOP); x = x_center - x_width/2; y = y_center - y_height/2;
      } else if (x_align.equals("CENTER") && y_align.equals("CENTER")) {
        textAlign(CENTER, CENTER); x = x_center; 
        if (lines.length%2!=0) {y = y_center-floor(lines.length*0.5)*font_size;} else {y = y_center-(lines.length*0.5*font_size);}
      }
      for (int i=0; i<lines.length; i++) {
        float y_txt; if (lines.length%2!=0) {y_txt = y+i*font_size;} else {y_txt = y+(i+0.5)*font_size;}
        // println("###### horizontal text: line = " + i + " of " + lines.length + ", " + lines[i] + "; x = " + x + ", y = " + y_txt);
        text(lines[i], x, y_txt); 
      }
    } else {
      PFont tfont = createFont(font_type, default_font_size); textFont(tfont);
      text("...", x, y);
    }
  } else { // VERTICAL
    // println("#### flex_write_lines_in_box x_width = " + x_width + "; y_height = " + y_height + ": GO VERTICAL!!!");
    // print the vertical text, in the center of the rectangle
    float font_size = determine_font_size (words, font_aspect_ratio, y_height, x_width);
    //println(" = flex_write_lines_in_box = font_size: " + font_size);
    int line_size = int (y_height / (font_size * font_aspect_ratio)); // in terms of characters 
    // println(" = flex_write_lines_in_box = line_size: " + line_size);
    String lines[] = combine_words_into_lines (words, line_size); 
    // println("number of lines = " + lines.length);
    float x = x_center; float y = y_center; 
    if (font_size > 0) {
      PFont tfont = createFont(font_type, font_size); textFont(tfont);
      if (x_align.equals("LEFT") && y_align.equals("CENTER")) {
        x = x_center - (lines.length*0.5)*font_size; y = y_center + y_height/2.0;
        // if (lines.length%2!=0) {y = y_center+y_height/2.0;} else {y = y_center+(lines.length*0.5*font_size);}
      } else if (x_align.equals("LEFT") && y_align.equals("TOP")) {
        x = x_center - x_width/2.0; y = y_center + y_height/2.0;
      } else if (x_align.equals("CENTER") && y_align.equals("CENTER")) {
        y = y_center; 
        if (lines.length%2!=0) {x = x_center-(lines.length*0.5)*font_size;} else {x = x_center-(lines.length*0.5*font_size);}
      }
      for (int i=0; i<lines.length; i++) {
        float x_txt; if (lines.length%2!=0) {x_txt = x+i*font_size;} else {x_txt = x+(i+0.5)*font_size;}
        if (lines[i].equals("timeline ") || lines[i].equals("drama ")) {
        println("###### vertical_text: line = " + i + " of " + lines.length + ", " + lines[i] + "; x = " + x_txt + ", y = " + y);
        }
        if (x_align.equals("CENTER") && y_align.equals("CENTER")) {vertical_text(lines[i], x_txt, y, CENTER, CENTER);} else
        if (x_align.equals("LEFT") && y_align.equals("CENTER")) {vertical_text(lines[i], x_txt, y, LEFT, CENTER);} else
        if (x_align.equals("LEFT") && y_align.equals("TOP")) {vertical_text(lines[i], x_txt, y, LEFT, DOWN);} 
      }
    } else {
      PFont tfont = createFont(font_type, default_font_size); textFont(tfont);
      text("...", x, y);
    }
  }
}

// given some text and font size, write the text in the box
void write_lines_in_fixed_fontsize(String text, String font_type, float font_aspect_ratio, float font_size, String x_align, String y_align, float x_center, float y_center) {
  // println(" = write_lines_in_fixed_fontsize = text: " + text + "; font_size: " + font_size);
  float x = x_center; float y = y_center; 
  String[] words = split_text_into_words (text);
  float[] box_size = determine_box_size(words, font_aspect_ratio, font_size);
  String lines[] = combine_words_into_lines (words, (int)(box_size[0]/(font_size*font_aspect_ratio))); 
  // println("number of lines = " + lines.length);
  if (x_align.equals("LEFT") && y_align.equals("CENTER")) {
    textAlign(LEFT, CENTER); 
    x = x_center - box_size[0]/2; 
    rectMode(CORNER);
  } else 
  if (x_align.equals("LEFT") && y_align.equals("TOP")) {
    textAlign(LEFT, TOP); 
    x = x_center - box_size[0]/2; 
    y = y_center - box_size[1]/2; 
    rectMode(CORNER);
  } else 
  if (x_align.equals("CENTER") && y_align.equals("CENTER")) {
    textAlign(CENTER, CENTER); 
    rectMode(CENTER);
  }  
  fill(0, 0, 100, 10); 
  noStroke(); // rectMode(CORNER);  
  rect(x, y, box_size[0], box_size[1]); 
  //println(" = write_lines_in_fixed_fontsize = box_size[0]: " + box_size[0] + "; box_size[1]: " + box_size[1]);
  fill(0); 
  if (font_size>0) {
    PFont tfont = createFont(font_type, font_size); 
    textFont(tfont);
    for (int i=0; i<lines.length; i++) {        
      text(lines[i], x, y+i*font_size);
      // text(lines[i],x_corner,y_corner);
    }
  } else {
    PFont tfont = createFont(font_type, default_font_size); 
    textFont(tfont);
    text("...", x, y);
  }
}

// given width, height, and font aspect ratio, this determines the font size for some text
float determine_font_size (String[] words, float font_aspect_ratio, float x_width, float y_height) {
  int font_size = 1; // CLASS with font size 1
  int longest_word_length = longest_word(words); // compute the longest word length (minimum for line size)
  boolean max_size_found = false; // boolean for finding the possible max font size 
  while (!max_size_found) { // while not found the max font size
    int line_size = int (x_width / (font_size * font_aspect_ratio)); // compute the current line size in number of chars
    if (line_size > longest_word_length) { // if it is more than the longest word length
      String lines[] = combine_words_into_lines (words, line_size); // form the lines of the text 
      // println("font_size = " + font_size + "; line_size = " + line_size + "; lines[0] = " + lines[0]);
      if (lines.length * font_size <= y_height) {
        font_size=font_size+1;
      } else {
        max_size_found=true;
      }
    } else {
      max_size_found=true;
    }
  }
  if (font_size>1) {
    font_size = font_size - 1;
  } 
  //println("font_size = " + str(font_size-1));
  return font_size;
}

// given font size and aspect ratio, this determines the size of the box for some text
float[] determine_box_size(String[] words, float font_aspect_ratio, float font_size) {
  float[] box_size = {0, 0}; // set to max size
  float box_aspect_ratio = 25/9;
  int line_size_in_chars = longest_word(words) + 1; // longest word length (minimum for line size) + blank after word
  float line_size = font_size * font_aspect_ratio * line_size_in_chars; // compute the current line size in number of pixels
  boolean box_size_found = false;
  while (!box_size_found) {
    line_size_in_chars = line_size_in_chars+1;
    line_size = font_size * font_aspect_ratio * line_size_in_chars;
    // if (line_size <= width/3) { // if it is more than the longest word length 
    String lines[] = combine_words_into_lines (words, line_size_in_chars); // form the lines of the text 
    //println("line_size = " + line_size + "; lines[0] = " + lines[0] + "; longest_word_length = " + longest_word_length);
    if (lines.length * font_size <= line_size/box_aspect_ratio) { 
      box_size[0] = line_size; 
      box_size[1] = line_size/box_aspect_ratio;
      box_size_found = true;
      //println("box_size[0] = " + box_size[0] + "; box_size[1] = " + box_size[1]);
    } 
    //}
  }
  for (int i=0; i<words.length;i++) {if (words[i].equals("\n")) {box_size[1]++;}}
  //println("font_size = " + str(font_size-1));
  return box_size;
}

// writing vertically
void vertical_text(String phrase, float x, float y, int x_align, int y_align) {
  if (phrase.equals("timeline ") || phrase.equals("drama ")) {
  println("###### vertical_text inside: phrase = " + phrase + "; x = " + x + ", y = " + y);
  }
  pushMatrix();
  translate(x, y);
  rotate(-HALF_PI);
  textAlign(x_align, y_align);
  text(phrase, 0, 0);
  popMatrix();
}

// writing vertically
// void vertical_text_box(String phrase, PFont font, color c, float x, float y, float x_w, float y_h) {
void vertical_text_box(String phrase, PFont font, float x, float y, float x_w, float y_h) {
  // fill(c);
  textAlign(CENTER, CENTER);
  // rectMode(CENTER);
  textFont(font);

  pushMatrix();
  translate(x, y+y_h);
  rotate(-HALF_PI);
  text(phrase, 0, 0, y_h, x_w);
  popMatrix();
}

// writing horizontally
void horizontal_text_box(String phrase, PFont font, color c, float x, float y, float x_w, float y_h) {
  fill(c);
  textAlign(CENTER, CENTER);
  // rectMode(CENTER);
  textFont(font);

  pushMatrix();
  // translate(x, y+y_h);
  translate(x, y);
  text(phrase, 0, 0, x_w, y_h);
  popMatrix();
}
