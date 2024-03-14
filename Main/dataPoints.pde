String[] lines;

void setup() {                                    // reads data and converts to bytes, to string, then printData method is initialised.
  byte[] fileBytes = loadBytes("flights.csv");    
  String fileContent = new String(fileBytes);
  lines = split(fileContent, "\n");
  printData();
}

void draw() {
  // empty rn as havnt progressed that far in project to date.
}

void printData() {
  // This loops through every line and prints it until last one is read.
  for (String line : lines) {
    println(line);
  }
}
