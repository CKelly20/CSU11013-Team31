import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.Comparator;
import java.util.Collections;



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
       fill(255);
       textSize(20);
       text(dropdownQueryDisplay,30,300);
       break;
       case QUERY_3:
        drawShortestFlightDurations();     // Draw the bar chart for the third query
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
  
