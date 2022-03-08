// AUX FUNCTIONS
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

void replaceString(String old_name, String new_name, String[]list, int left, int right) {
  for (int i=left; i<right; i++) {
    if (list[i].equals(old_name)) {list[i]=new_name;}
  }
}


void print4check(String header, int left_end, int right_end, String[] string_array) {
  print(header); 
  for (int j=left_end; j<right_end; j++) {print(" " + string_array[j]);} 
  print("\n");
}
