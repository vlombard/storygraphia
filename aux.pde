// AUX FUNCTIONS
int searchStringIndex(String id, String[]list, int left, int right) {
  // println(id);
  for (int i=left; i<right; i++) {
    if (list[i].equals(id)) {return i;}
  }
  return -1;
}

void print4check(String header, int left_end, int right_end, String[] string_array) {
  print(header); 
  for (int j=left_end; j<right_end; j++) {print(" " + string_array[j]);} 
  print("\n");
}
