//Written by Somto 
import javax.swing.JOptionPane;
import processing.pdf.*;

Table table;
//This is the initialisation of all the data points using ArrayLists
ArrayList<String> MKT_CARRIER;        
ArrayList<String> ORIGIN_CITY_NAME;
ArrayList<Integer> ORIGIN_WAC;
ArrayList<String> DEST;
ArrayList<String> DEST_CITY;
ArrayList<String> DEST_STATE;
ArrayList<Integer> DEST_WAC;
ArrayList<Integer> CRS_DEP_TIME;
ArrayList<Integer> DEP_TIME;
ArrayList<Integer> CRS_ARR_TIME;
ArrayList<Integer> ARR_TIME;
ArrayList<Integer> CANCELLED;
ArrayList<Integer> DIVERTED;
ArrayList<Integer> DISTANCE;

//This is the void Setup, used to import the files and set the screen size
void setup() {
  size (800, 800);
  
  beginRecord(PDF, "flightData.pdf");
  background(20);
  
  table = loadTable("dataPoints2k.csv", "header");
  int rowCount = table.getRowCount();
  
  println(rowCount + " total rows in the table");
  
  // Initialisation of the ArrayLists
  MKT_CARRIER = new ArrayList<String>();
  ORIGIN_CITY_NAME = new ArrayList<String>();
  ORIGIN_WAC = new ArrayList<Integer>();
  DEST = new ArrayList<String>();
  DEST_CITY = new ArrayList<String>();
  DEST_STATE = new ArrayList<String>();
  DEST_WAC = new ArrayList<Integer>();
  CRS_DEP_TIME = new ArrayList<Integer>();
  DEP_TIME = new ArrayList<Integer>();
  CRS_ARR_TIME = new ArrayList<Integer>();
  ARR_TIME = new ArrayList<Integer>();
  CANCELLED = new ArrayList<Integer>();
  DIVERTED = new ArrayList<Integer>();
  DISTANCE = new ArrayList<Integer>();

  // this section is used to put the datapoints in the relevant ArrayLists so we can easily extract them later
  for (int i = 0; i < rowCount; i++) {
    TableRow row = table.getRow(i);
    String mktCarrier = row.getString("MKT_CARRIER");
    String originCityName = row.getString("ORIGIN_CITY_NAME");
    int originWAC = row.getInt("ORIGIN_WAC");
    String dest = row.getString("DEST");
    String destCity = row.getString("DEST_CITY_NAME");
    String destState = row.getString("DEST_STATE_ABR");
    int destWAC = row.getInt("DEST_WAC");
    int crsDepTime = row.getInt("CRS_DEP_TIME");
    int depTime = row.getInt("DEP_TIME");
    int crsArrTime = row.getInt("CRS_ARR_TIME");
    int arrTime = row.getInt("ARR_TIME");
    int cancelled = row.getInt("CANCELLED");
    int diverted = row.getInt("DIVERTED");
    int distance = row.getInt("DISTANCE");
    
    MKT_CARRIER.add(mktCarrier);
    ORIGIN_CITY_NAME.add(originCityName);
    ORIGIN_WAC.add(originWAC);
    DEST.add(dest);
    DEST_CITY.add(destCity);
    DEST_STATE.add(destState);
    DEST_WAC.add(destWAC);
    CRS_DEP_TIME.add(crsDepTime);
    DEP_TIME.add(depTime);
    CRS_ARR_TIME.add(crsArrTime);
    ARR_TIME.add(arrTime);
    CANCELLED.add(cancelled);
    DIVERTED.add(diverted);
    DISTANCE.add(distance);
  }
  
  //This section is for user input: The user is able to type in the flight number they want and extract the relevant information, 
  // Or they can type "A" to extract all the flight information
  //Or type "End" to back out of the page
  while (true) {
    String input = JOptionPane.showInputDialog("Enter the flight number, or type 'A' to view all flights. Type 'End' to stop.");
    
    if (input.equalsIgnoreCase("End")) {
      break;
    }
    
    if (input.equalsIgnoreCase("A")) {
      viewAllFlights();
    } else {
      int selectedFlight = Integer.parseInt(input);
      displayFlightInfo(selectedFlight);
    }
  }
  
  endRecord();
}

void displayFlightInfo(int flightNumber) {
  int index = flightNumber - 1;
  
  if (index < 0 || index >= MKT_CARRIER.size()) {
    println("Flight number is out of range.");
    return;
  }
  
  //The following code is to print out the relevant information to the console
  println();
  println("Flight Number: " + flightNumber);
  println("Market Carrier: " + MKT_CARRIER.get(index));
  println("City of Origin: " + ORIGIN_CITY_NAME.get(index));
  println("WAC of Origin: " + ORIGIN_WAC.get(index));
  println("Destination: " + DEST.get(index));
  println("Destination City: " + DEST_CITY.get(index));
  println("Destination State: " + DEST_STATE.get(index));
    println("WAC of Destination: " + DEST_WAC.get(index));
  println("Scheduled Departure Time: " + CRS_DEP_TIME.get(index));
  println("Actual Departure Time: " + DEP_TIME.get(index));
  println("Scheduled Arrival Time: " + CRS_ARR_TIME.get(index));
  println("Actual Arrival Time: " + ARR_TIME.get(index));
  println("Cancelled: " + CANCELLED.get(index));
  println("Diverted: " + DIVERTED.get(index));
  println("Distance: " + DISTANCE.get(index));
}

void viewAllFlights() {
  int totalFlights = MKT_CARRIER.size();
  println("Total Flights: " + totalFlights);
  
  for (int i = 0; i < totalFlights; i++) {
    println();
    println("Flight Number: " + (i + 1));
    println("Market Carrier: " + MKT_CARRIER.get(i));
    println("City of Origin: " + ORIGIN_CITY_NAME.get(i));
    println("WAC of Origin: " + ORIGIN_WAC.get(i));
    println("Destination: " + DEST.get(i));
    println("Destination City: " + DEST_CITY.get(i));
    println("Destination State: " + DEST_STATE.get(i));
    println("WAC of Destination: " + DEST_WAC.get(i));
    println("Scheduled Departure Time: " + CRS_DEP_TIME.get(i));
    println("Actual Departure Time: " + DEP_TIME.get(i));
    println("Scheduled Arrival Time: " + CRS_ARR_TIME.get(i));
    println("Actual Arrival Time: " + ARR_TIME.get(i));
    println("Cancelled: " + CANCELLED.get(i));
    println("Diverted: " + DIVERTED.get(i));
    println("Distance: " + DISTANCE.get(i));
  }
}
