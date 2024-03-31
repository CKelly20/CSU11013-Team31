import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
        drawBusiestAirports();
        break;
       case QUERY_2:
       cancellationChart.draw();
       break;
       case QUERY_3:
        drawShortestFlightDurations(); // Draw the bar chart for the third query
        break;
    }
  }

  
  void drawBusiestAirports() {
  if (data == null) return; // Add this line to guard against null data

  HashMap<String, Integer> airportCounts = new HashMap<>(data.length);
  for (String line : data) {
    String[] parts = line.split(",");
    String airportName = parts[3].trim(); // Adjust the index according to your data structure
    String arrivalAirport = parts[8].trim();
    airportCounts.put(airportName, airportCounts.getOrDefault(airportName, 0) + 1);
    airportCounts.put(arrivalAirport, airportCounts.getOrDefault(arrivalAirport, 0) + 1);
  }

  

  // Limit to top 10 airports
  List<Entry<String, Integer>> sortedEntries = new ArrayList<>(airportCounts.entrySet());
  sortedEntries.sort(Entry.comparingByValue(Comparator.reverseOrder()));
  sortedEntries = sortedEntries.subList(0, Math.min(20, sortedEntries.size())); // Top 10 or fewer

  float x = 50; // Starting x position for the first bar
  float y = height - 250; // y position, leaving space for text
  float barWidth = (width - 100) / sortedEntries.size() - 10; // Dynamically calculate bar width
  float maxBarHeight = 300; // Maximum bar height
  int maxCount = sortedEntries.get(0).getValue(); // Highest value for scaling
  
  textSize(14);
  
  pushMatrix();
  translate(25, height - 400); // Adjust position if needed
  rotate(-HALF_PI); // Rotate by -90 degrees (counter-clockwise)
  boldFont = createFont("Arial Bold", 30);
  textFont(boldFont);
  fill(0);
  textSize(30);
  text("Number of Flights", -150, 0);
  textSize(14);
  popMatrix();


  for (int i = 0; i < sortedEntries.size(); i++) {
    Entry<String, Integer> entry = sortedEntries.get(i);
    fill(100, 100, 250); // Bar color
    float scaledHeight = (entry.getValue().floatValue() / maxCount) * maxBarHeight; // Scale height based on max value
    noStroke();
    rect(x + (barWidth + 10) * i, y - scaledHeight, barWidth, scaledHeight);
    fill(0);
    text(entry.getKey(), x + (barWidth + 10) * i + barWidth / 2, y + 20); // Display the airport name below the bar, adjusting position for readability

    // Display count next to each bar
    fill(50);
    text(entry.getValue(), x + (barWidth + 10) * i + barWidth / 2, y - scaledHeight - 5);
  }
  
  boldFont = createFont("Arial Bold", 70);
  textFont(boldFont);
  fill(255);
  text("Busiest Airports", 275, 100);
  
  boldFont = createFont("Arial Bold", 30);
  textFont(boldFont);
  fill(0);
  text("Airports", 450, 500);
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
  
