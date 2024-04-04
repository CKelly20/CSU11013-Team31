import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.swing.JOptionPane; 
import java.util.Map;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


HashMap<String, Float> currentHeights = new HashMap<String, Float>();
int animationStartFrame = 0; // Tracks the start frame of the animation
boolean isAnimationReset = false; // Flag to check if animation has been reset
float animationProgress = 0;
float animationDuration = 120; 



PShape americaMap; // variable to hold the map outline
HashMap<String, PVector> stateDots; // Coordinates of dots representing each state
String selectedState = "";
String startDate, endDate;
HashMap<String, ArrayList<Flights>> flightsByState;
int scrollValue = 0;

float lastUpdateTime = 0;
float updateInterval = 0.05;

class Render {
  int query;
  String[] data;    
  final int barHeight = 50;
  final color hoverColor = color(255, 0, 0);
  final color buttonColor = color(255);
  float[] values = {100, 200, 300}; // Example values
  float maxValue = 300; // Example max value
  String[] labels = {"Label 1", "Label 2", "Label 3"}; // Example labels
  

  Render(int userQuery, String[] data) {
    this.query = userQuery;
    this.data = data; // Pass the flight data to the Render
  }

  
  void draw() {
    switch(query){
      case QUERY_1:
        resetAnimation();
        drawBusiestAirports();
        break;
       case QUERY_2:
       cancellationChart.draw();
       cp5.draw();
       break;
       case QUERY_3:
        drawShortestFlightDurations(); // Draw the bar chart for the third query
        break;
        case QUERY_4:
        drawMap();
        break;
    }
  }
  
  void resetAnimation() {
  animationStartFrame = frameCount; // Reset start frame to current frame
  isAnimationReset = true; // Indicate that animation is reset
}

void drawBusiestAirports() {

  if (data == null) return; // Early return if data is null

  // Parse your data into a counts map
  HashMap<String, Integer> airportCounts = new HashMap<>();
  for (String line : data) {
    String[] parts = line.split(",");
    // Update these indices according to your data's format
    String airportName = parts[3].trim();
    String arrivalAirport = parts[8].trim();
    airportCounts.put(airportName, airportCounts.getOrDefault(airportName, 0) + 1);
    airportCounts.put(arrivalAirport, airportCounts.getOrDefault(arrivalAirport, 0) + 1);
  }

  // Sort and limit to top 10 airports
  List<Map.Entry<String, Integer>> sortedEntries = new ArrayList<>(airportCounts.entrySet());
  sortedEntries.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));
  sortedEntries = sortedEntries.subList(0, Math.min(15, sortedEntries.size()));

  float x = 170, y = height - 150;
  float barWidth = (width - 400) / sortedEntries.size() - 10;
  float maxBarHeight = 300;
  int maxCount = sortedEntries.get(0).getValue();

  // Update animation heights
  if (millis() - lastUpdateTime > updateInterval * 1000) {
    lastUpdateTime = millis();
    for (Map.Entry<String, Integer> entry : sortedEntries) {
      String airportName = entry.getKey();
      float targetHeight = map(entry.getValue(), 0, maxCount, 0, maxBarHeight);
      currentHeights.put(airportName, lerp(currentHeights.getOrDefault(airportName, 0.0), targetHeight, 0.05));
    }
  }
    

  // Draw bars and labels
  for (int i = 0; i < sortedEntries.size(); i++) {
    Map.Entry<String, Integer> entry = sortedEntries.get(i);
    String airportName = entry.getKey();
    float finalHeight = currentHeights.getOrDefault(airportName, 0.0f);
    fill(63, 81, 181); // Bar color
    stroke(0);
    rect(x + (barWidth + 10) * i, y - finalHeight, barWidth, finalHeight);

    textSize(15);
    fill(0);
    text(airportName, x + (barWidth + 10) * i + barWidth / 2, y + 20);

    text(entry.getValue().toString(), x + (barWidth + 10) * i + barWidth / 2, y - finalHeight - 5);
  }

  // Title and labels
  textFont(boldFont);
  fill(0);
  textSize(30);
  text("Busiest Airports", 400, 50);
  text("Airports", 450, height - 30); // X-axis label
  pushMatrix();
  translate(20, height / 2);
  rotate(-HALF_PI);
  text("Number of Flights", 0, -350); // Adjust positioning as needed
  popMatrix();
}

  
void drawShortestFlightDurations() {
  // Create a list to store flight durations
  ArrayList<FlightDuration> flightDurations = new ArrayList<>();
      
 for (int i = 1; i < data.length; i++) {
      String line = data[i];
      String[] parts = line.split(","); // Split the line by comma
      int depTime = Integer.parseInt(parts[13]); // Get departure time 
      int arrTime = Integer.parseInt(parts[15]); // Get arrival time 
      float duration = (arrTime - depTime) /600; // Calculate duration in hours
      String airportName = parts[4].trim(); // Get origin airport name
      String destAirportName= parts[9].trim();
      
      // Add flight duration to the list
      flightDurations.add(new FlightDuration(airportName, duration));
    }
  // Sort flight durations by duration in descending order
  Collections.sort(flightDurations, Collections.reverseOrder());
  
  // Select the top 5 longest flight durations
  List<FlightDuration> top5FlightDurations = flightDurations.subList(0, Math.min(5, flightDurations.size()));
  
  // Draw the bar chart for the top 5 longest flight durations
  float startX = 200;
  float startY = 100;
  float barWidth = 200;
  float maxDuration = top5FlightDurations.get(0).duration;
  float scaleFactor = 200 / maxDuration; // Scale factor for bar heights
  noStroke();
  fill(255);
  textSize(20);
  text("Top 5  shortest Durations", width / 2, 50);
  
  for (int i = 0; i < top5FlightDurations.size(); i++) {
    FlightDuration flightDuration = top5FlightDurations.get(i);
    String airportName = flightDuration.airportName;
    float duration = flightDuration.duration;
    
    // Draw the bar for each flight duration
    fill(0, 0, 255);
    rect(startX, startY + i * 80, duration * scaleFactor, 50);
    
    // Display airport name below the bar
    fill(0);
    text(airportName, startX, startY + i * 80 + 70);
    
    // Display duration above the bar
    fill(0);
    text(String.format("%.2f", duration) + " hours", startX + duration * scaleFactor, startY + i * 80 + 45);
  }
}


}
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
  while (!isValidDate(inputDate)) { // Keep prompting until a valid date is entered
    inputDate = JOptionPane.showInputDialog("Invalid date format. Please enter a date in the format DD/MM/YYYY:");
  }
  return inputDate;
  }
  return "";
}
boolean getDate() {
  String startDateInput = JOptionPane.showInputDialog("Enter start date (DDMMYYYY):"); // Prompt the user for input
  String endDateInput = JOptionPane.showInputDialog("Enter end date (DDMMYYYY):"); // Prompt the user for input
  
  // Check if both start date and end date inputs are valid
  if (isValidDate(startDateInput) && isValidDate(endDateInput)) {
    startDate = startDateInput;
    endDate = endDateInput;
    return true; // Return true if both dates are valid
  } else {
    JOptionPane.showMessageDialog(null, "Invalid date format. Please enter dates in the format DDMMYYYY.");
    return false; // Return false if either date is invalid
  }
}
boolean isValidDate(String date) {
  // Check if the date string is in the format DDMMYYYY and is a valid date
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

  // Iterate through flights and display information for flights from the selected state
  for (Flights flight : flights) {
    if (flight != null && flight.originState.equalsIgnoreCase(selectedState)) {
      String departureTime = String.format("%02d:%02d", flight.crsDepTime / 100, flight.crsDepTime % 100);
      String arrTime = String.format("%02d:%02d", flight.crsArrTime / 100, flight.crsArrTime % 100);
      
      
      text(flight.originCityName, 50, y);
      text(flight.mktCarrier + flight.mktFlightNum, 250, y);
      text(departureTime, 400, y);
      text(arrTime, 550, y);
      text(flight.destCityName, 700, y);
      y += 30; // Increment y-coordinate for the next flight
    }
  }
  scroll(0, 0, width - 20, height - 20);
  // Draw a "Back" button
  fill(200);
  rect(0, height - 50, 50, 40);
  fill(0);
  textSize(16);
  text("Back", 0, height - 25);
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

void scroll(int x, int y, int w, int h) {
  int x1 = x + w;
  int y1 = y + h;
  if (mouseX > x && mouseX < x1 && mouseY > y && mouseY < y1) {
    if (mousePressed && mouseY < (height - 20)) { // Check if the mouse is pressed inside the scrolling area
      if (mouseY < (height - 20) && mouseY > (height - 40)) { // Scrolling down
        if (h + scrollValue > height - 20) {
          scrollValue -= 20;
        }
      } else if (mouseY > 20 && mouseY < 40) { // Scrolling up
        if (scrollValue < 0) {
          scrollValue += 20;
        }
      }
    }
  }
}
