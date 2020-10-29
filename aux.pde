// AUX FUNCTIONS
int searchStringIndex(String id, String[]list, int left, int right) {
  // println(id);
  for (int i=left; i<right; i++) {
    if (list[i].equals(id)) {return i;}
  }
  return -1;
}
