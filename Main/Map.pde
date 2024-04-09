/*Relevant code for drawing map of America along with each state and displaying 
  flights from each state
  
  Author  : O.Kukoyi */

import javax.swing.JOptionPane;
import java.util.Map;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

PShape americaMap; // Declare a variable to hold the map outline
HashMap<String, PVector> stateDots; // Coordinates of dots representing each state
String selectedState = "";
String startDate, endDate;
HashMap<String, ArrayList<Flights>> flightsByState;

void loadMap() {
  americaMap = loadShape("MapOfAmerica.svg"); // Load the map outline from the SVG file
  americaMap.scale(0.9); // Scale the map to fit within the canvas
  americaMap.translate(0, 0);
  
  stateDots = new HashMap<String, PVector>();
  
  stateDots.put("CA", new PVector(160, 280));
  stateDots.put("TX", new PVector(480, 420));
  stateDots.put("WA", new PVector(200, 80)); // Washington
  stateDots.put("OR", new PVector(180, 140)); // Oregon
  stateDots.put("NV", new PVector(210, 230)); // Nevada
  stateDots.put("ID", new PVector(260, 160)); // Idaho
  stateDots.put("MT", new PVector(330, 100)); // Montana
  stateDots.put("WY", new PVector(370, 200)); // Wyoming
  stateDots.put("UT", new PVector(300, 260)); // Utah
  stateDots.put("CO", new PVector(380, 280)); // Colorado
  stateDots.put("AZ", new PVector(270, 350)); // Arizona
  stateDots.put("NM", new PVector(370, 370)); // New Mexico
  stateDots.put("ND", new PVector(480, 110)); // North Dakota
  stateDots.put("SD", new PVector(480, 180)); // South Dakota
  stateDots.put("NE", new PVector(480, 230)); // Nebraska
  stateDots.put("KS", new PVector(500, 290)); // Kansas
  stateDots.put("OK", new PVector(520, 350)); // Oklahoma
  stateDots.put("MN", new PVector(560, 140)); // Minnesota
  stateDots.put("IA", new PVector(570, 220)); // Iowa
  stateDots.put("MO", new PVector(590, 280)); // Missouri
  stateDots.put("AR", new PVector(590, 370)); // Arkansas
  stateDots.put("LA", new PVector(595, 430)); // Louisiana
  stateDots.put("WI", new PVector(620, 160)); // Wisconsin
  stateDots.put("IL", new PVector(630, 260)); // Illinois
  stateDots.put("IN", new PVector(690, 250)); // Indiana
  stateDots.put("MI", new PVector(700, 170)); // Michigan
  stateDots.put("OH", new PVector(740, 240)); // Ohio
  stateDots.put("KY", new PVector(720, 300)); // Kentucky
  stateDots.put("WV", new PVector(780, 270)); // West Virginia
  stateDots.put("PA", new PVector(810, 220)); // Pennsylvania
  stateDots.put("NY", new PVector(840, 170)); // New York
  stateDots.put("VT", new PVector(870, 140)); // Vermont
  stateDots.put("NH", new PVector(900, 150)); // New Hampshire
  stateDots.put("ME", new PVector(910, 90));  // Maine
  stateDots.put("MA", new PVector(880, 170)); // Massachusetts
  stateDots.put("CT", new PVector(885, 185)); // Connecticut
  stateDots.put("RI", new PVector(900, 185)); // Rhode Island
  stateDots.put("NJ", new PVector(865, 220)); // New Jersey
  stateDots.put("DE", new PVector(860, 250)); // Delaware
  stateDots.put("MD", new PVector(830, 250)); // Maryland
  stateDots.put("VA", new PVector(805, 290)); // Virginia
  stateDots.put("AL", new PVector(570, 440)); // Alabama
  stateDots.put("MS", new PVector(540, 490)); // Mississippi
  stateDots.put("NC", new PVector(810, 330)); // North Carolina
  stateDots.put("SC", new PVector(790, 370)); // South Carolina
  stateDots.put("GA", new PVector(750, 400)); // Georgia
  stateDots.put("FL", new PVector(800, 490)); // Florida
  stateDots.put("AL", new PVector(700, 400)); // Alabama
  stateDots.put("MS", new PVector(650, 400)); // Mississippi
  stateDots.put("TN", new PVector(680, 340)); // Tennessee
  stateDots.put("AK", new PVector(180, 550));
}

void promptForDateRange() {
  startDate = getDate("Enter start date (DDMMYYYY):");  // ask user for date range
  endDate = getDate("Enter end date (DDMMYYYY):");
}

String getDate(String message) {
  String inputDate = JOptionPane.showInputDialog(message); // Prompt the user for input
  if (inputDate == null) { // Check if the user pressed cancel
    return null;
  }
  while (!isValidDate(inputDate)) { // Keep prompting until a valid date is entered
    inputDate = JOptionPane.showInputDialog("Invalid date format. Please enter a date in the format DD/MM/YYYY:");
    if (inputDate == null) { // Check if the user pressed cancel
      return null;
    }
  }
  return inputDate;
}

boolean isValidDate(String date) {
  // Check if the date string is in the format DDMMYYYY and is a valid date
  if (date.length() != 10) {
    return false;
  }
  try {
    int day = Integer.parseInt(date.substring(0, 2)); // extract day month and year from date
    int month = Integer.parseInt(date.substring(3, 5));
    int year = Integer.parseInt(date.substring(6));
    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1000 || year > 9999) {
      return false;
    }
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}
boolean hasFlightsDuringDateRange(String state, String startDate, String endDate) {
  if (startDate == null || endDate == null) {
        return false; // If startDate or endDate is null, return false
    } 
  for (Flights flight : flights) {
        if (flight != null && flight.originState.equalsIgnoreCase(state)) {
            // System.out.println("Flight Date: " + flight.flightDate);
            if (isDateInRange(flight.flightDate, startDate, endDate)) {
                //System.out.println("Flight within date range!");
                return true;
            }
        }
    }
    return false;
}

boolean isDateInRange(String date, String startDate, String endDate) {
  SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
  try {
    Date flightDate = dateFormat.parse(date);
    Date rangeStartDate = dateFormat.parse(startDate);
    Date rangeEndDate = dateFormat.parse(endDate);
    
    // Check if the flight date falls within the selected range
    return (flightDate.after(rangeStartDate) || flightDate.equals(rangeStartDate)) && (flightDate.before(rangeEndDate) || flightDate.equals(rangeEndDate));
  } catch (ParseException e) {
    e.printStackTrace(); // Handle parsing exception
    return false; // Return false if parsing fails
  }
}

void drawStateDots() {
  fill(255); // Set fill color to white for dots
  textSize(15); // Set text size for state names
  
  // Iterate through each state in the HashMap
  for (String state : stateDots.keySet()) {
    PVector dotPos = stateDots.get(state); // Get the coordinates of the dot for the current state
     
     if (hasFlightsDuringDateRange(state, startDate, endDate)) {
      // Check if the mouse is over the dot
      if (dist(dotPos.x, dotPos.y, mouseX, mouseY) < 10) {
        fill(255, 0, 0); // Change fill color to red if hovering
      } else if (selectedState.equals(state)) {
        fill(0, 255, 0); // Change fill color to green if selected
      } else {
        fill(255); // Set fill color to white for dots
      }
      
      // Draw the dot
      noStroke();
      ellipse(dotPos.x, dotPos.y, 10, 10);
     }
     text(state, dotPos.x + 15, dotPos.y);
  }
}

void handleMapScreenClick() {
  // Check if the mouse is over any dot
  if(mousePressed) {
    // If clicked on a state, set currentScreen to FLIGHT_INFO_SCREEN
    if(startDate != null || endDate != null){
      for (String state : stateDots.keySet()) {
        PVector dotPos = stateDots.get(state); // Get the coordinates of the dot for the current state
        // Check if the mouse is over the dot when pressed
        if (dotPos != null && dist(dotPos.x, dotPos.y, mouseX, mouseY) < 10) {
          selectedState = state; // Set the selected state
          currentScreen = screen5;
          // Switch to flight info screen
          return;
        }
      }
    }
  }
}

void drawFlightInfoScreen() {
  // Code to draw the flight info screen
  
  fill(0);
  textSize(20);
  int y = 50; // Starting y-coordinate for displaying flight information
  
  text("From", 50, y);
  text("Flight Number", 280, y);
  text("Departure Time", 450, y);
  text("Arrival Time", 600, y);
  text("Destination", 750, y);
  
  y += 30;

  int flightsDisplayed = 0; // Counter for the number of flights displayed
  
  // Iterate through flights and display information for flights from the selected state
  for (Flights flight : flights) {
    if (flightsDisplayed > 18) {
      break; // Exit the loop if the maximum number of flights has been displayed
    }
    
    if (flight != null && flight.originState.equalsIgnoreCase(selectedState)) {
      String departureTime = String.format("%02d:%02d", flight.crsDepTime / 100, flight.crsDepTime % 100);
      String arrTime = String.format("%02d:%02d", flight.crsArrTime / 100, flight.crsArrTime % 100);
      
      text(flight.originCityName, 50, y);
      text(flight.mktCarrier + flight.mktFlightNum, 280, y);
      text(departureTime, 450, y);
      text(arrTime, 600, y);
      text(flight.destCityName, 750, y);
      y += 30; // Increment y-coordinate for the next flight
      
      flightsDisplayed++; // Increment the counter for the number of flights displayed
    }
  }
}
