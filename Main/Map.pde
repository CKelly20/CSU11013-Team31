import java.util.Map;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.swing.JOptionPane;


void drawMap(){
  shape(americaMap, -150, 20);
  drawStateDots();
 
 if (currentScreen == screen4) {
    drawMapScreen();
  } else if (currentScreen == screen5) {
    drawFlightInfoScreen();
  }
 handleMapScreenClick();
}

void drawStateDots() {
  fill(255); // Set fill color to white for dots
  textSize(12); // Set text size for state names
  
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
      ellipse(dotPos.x, dotPos.y, 10, 10);
      text(state, dotPos.x + 15, dotPos.y);
     }
  }
}
String getDate(String message) {
  if(currentScreen == screen4){
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
  return "";
}
boolean getDate() {
  String startDateInput = JOptionPane.showInputDialog("Enter start date (DD/MM/YYYY):"); // Prompt the user for input
  String endDateInput = JOptionPane.showInputDialog("Enter end date (DD/MM/YYYY):"); // Prompt the user for input
  
  // Check if both start date and end date inputs are valid
  if (isValidDate(startDateInput) && isValidDate(endDateInput)) {
    startDate = startDateInput;
    endDate = endDateInput;
    return true; // Return true if both dates are valid
  } else {
    JOptionPane.showMessageDialog(null, "Invalid date format. Please enter dates in the format DD/MM/YYYY.");
    return false; // Return false if either date is invalid
  }
}
boolean isValidDate(String date) {
  // Check if the date string is in the format DDMMYYYY and is a valid date
  if (date == null || date.isEmpty()) {
        return false;
    }
  if (date.length() != 10) {
    return false;
  }
  try {
    int day = Integer.parseInt(date.substring(0, 2));
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
   if (startDate == null || endDate == null) {
        return false; // If startDate or endDate is null, return false
      }
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
void drawMapScreen() {
  // Code to draw the map screen...
  background(24,162,154); // Set background color to white
  fill(200); // Set fill color to blue for the map

  // Draw the map outline
  shape(americaMap, -150, 20); // Draw the map at position (0, 0) on the canvas
  
  drawStateDots();
  
  fill(200);
  rect(10, height - 50, 100, 40); // Adjust position and size as needed
  fill(0);
  textSize(16);
  text("Return", 20, height - 25); // Adjust position as needed
}

void drawFlightInfoScreen() {
  // Code to draw the flight info screen...
  background(24,162,154); // Set background color to white
  fill(200); // Set fill color to blue for the map
  
  fill(0);
  textSize(20);
  int y = 50; // Starting y-coordinate for displaying flight information
  
  text("From", 50, y);
  text("Flight Number", 250, y);
  text("Departure Time", 400, y);
  text("Arrival Time", 550, y);
  text("Destination", 700, y);
  
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
      text(flight.mktCarrier + flight.mktFlightNum, 250, y);
      text(departureTime, 450, y);
      text(arrTime, 600, y);
      text(flight.destCityName, 750, y);
      y += 30; // Increment y-coordinate for the next flight
      
      flightsDisplayed++; // Increment the counter for the number of flights displayed
    }
  }

  fill(200);
  rect(40, 630 , 200, 40);
  fill(0);
  textSize(30);
  text("Return", 60, 660);
}

void handleMapScreenClick() {
  // Check if the mouse is over any dot
  if(mousePressed) {
    // If clicked on a state, set currentScreen to FLIGHT_INFO_SCREEN
    for (String state : stateDots.keySet()) {
      PVector dotPos = stateDots.get(state); // Get the coordinates of the dot for the current state
      
      // Check if the mouse is over the dot when pressed
      if (dist(dotPos.x, dotPos.y, mouseX, mouseY) < 10) {
        selectedState = state; // Set the selected state
        currentScreen = screen5; // Switch to flight info screen
        return;
      }
    }
  }
}

void handleFlightInfoScreenClick() {
  // Check if the mouse is over the "Back" button
  // If clicked on the "Back" button, set currentScreen to MAP_SCREEN
   if (mouseX >= 20 && mouseX <= 120 && mouseY >= height - 50 && mouseY <= height - 10) {
    // If clicked on the "Back" button
    currentScreen = screen4; // Switch back to the map screen
    selectedState = ""; // Reset selected state
    return;
  }
}


 
 
