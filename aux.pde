// AUX FUNCTIONS

// STRING FUNCTIONS
int searchStringIndex(String id, String[]list, int left, int right) {
  // println(id);
  for (int i=left; i<right; i++) {
    if (list[i].equals(id)) {return i;}
  }
  return -1;
}

String[] deleteStringByIndex(int index, String[]list) {
  int i = 0; String[] aux_s = new String[list.length];
  while (i<index) {aux_s[i]=list[i]; i++;}
  aux_s[list.length-1] = null;
  for (i=index; i<list.length-1;i++) {aux_s[i] = list[i+1];}
  return aux_s;
}

String[] insertStringAtIndex(String str, int index, String[]list) {
  int i = 0; String[] aux_s = new String[list.length];
  while (i<index) {aux_s[i]=list[i]; i++;}
  aux_s[index] = str;
  for (i=index+1; i<list.length-1;i++) {aux_s[i] = list[i-1];}
  return aux_s;
}


void replaceString(String old_name, String new_name, String[]list, int left, int right) {
  for (int i=left; i<right; i++) {
    if (list[i].equals(old_name)) {list[i]=new_name;}
  }
}

// PRINTING
void print4check(String header, int left_end, int right_end, String[] string_array) {
  print(header); 
  for (int j=left_end; j<right_end; j++) {print(" " + string_array[j]);} 
  print("\n");
}

// IMAGING
float[] img_fitting_surface (PImage img, float w, float h) {
  float img_aspect_ratio = img.width / img.height;  float surface_aspect_ratio = w/h;
  float display_w = img.width; float display_h = img.height;
  // If your rectangle's aspect ratio is greater than that of your image, then scale the image uniformly based on the heights (rectangle height / image height).
  // If your rectangle's aspect ratio is less than that of your image, then scale the image uniformly based on the widths (rectangle width / image width).
  float w_ratio = w/img.width; float h_ratio = h/img.height;
  if (surface_aspect_ratio >= img_aspect_ratio) {display_h = h; display_w = img.width*h_ratio;}
  else {display_w = w; display_h = img.height*w_ratio;}
  float[] dw_dh = {display_w, display_h};  
  return dw_dh;
}
