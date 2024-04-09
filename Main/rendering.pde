import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.Comparator;
import java.util.Collections;
import java.util.List;



HashMap<String, Float> currentHeights = new HashMap<String, Float>();
int animationStartFrame = 0; // Tracks the start frame of the animation
boolean isAnimationReset = false; // Flag to check if animation has been reset
float animationProgress = 0;
float animationDuration = 120; 
float lastUpdateTime = 0;
float updateInterval = 0.05;

class Render {
 List<Map.Entry<String, Float>> top5Routes;
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
        drawLongestFlightRoutes();
        break;
       case QUERY_5:
      drawFlightDurationPieChart();
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

  // Sort and limit to top 15 airports
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

    text(entry.getValue().toString(), x + (barWidth + 10) * i + barWidth / 2 - 5, y - finalHeight - 5);
  }

  // Title and labels
  textFont(boldFont);
  fill(0);
  textSize(30);
  text("Busiest Airports", 400, 50);
  text("Airports", 450, height - 80); // X-axis label
  pushMatrix();
  translate(120, height - 300); // Adjust position if needed
  rotate(-HALF_PI); // Rotate by -90 degrees (counter-clockwise)
  textFont(boldFont);
  fill(0);
  textSize(30);
  text("Number of Flights", -150, 0);
  textSize(14);
  popMatrix();
}
 void drawLongestFlightRoutes() {  //Ciarán Nolan
    if (data == null || data.length < 2) return; // Check for null data or insufficient rows



  
void drawShortestFlightDurations() {
  // Create a list to store flight durations
  ArrayList<FlightDuration> flightDurations = new ArrayList<>();
      
 for (int i = 1; i < data.length; i++) {

    // Initialize a HashMap to store flight durations for each route
    HashMap<String, Float> routeDurations = new HashMap<>();

    // Start from i = 1 to skip the first row
    for (int i = 1; i < data.length; i++) {

      String line = data[i];
      String[] parts = line.split(",");
      if (parts.length >= 16) { // Ensure parts has enough elements
        String origin = parts[4].trim();
        String destination = parts[9].trim();
        float depTime = Float.parseFloat(parts[13].trim()); // Departure time
        float arrTime = Float.parseFloat(parts[15].trim()); // Arrival time
        float timeDiffOrigin = getTimeDifference(origin);
        float timeDiffDest = getTimeDifference(destination);
        // Calculate duration considering time difference
        float duration = (arrTime + timeDiffDest * 100 - depTime - timeDiffOrigin * 100) / 100;
        String route = origin + " to " + destination;
        // Update route duration
        routeDurations.put(route, Math.max(routeDurations.getOrDefault(route, 0.0), duration));
      }
    }

    // Sort routes by duration in descending order
    List<Map.Entry<String, Float>> sortedRoutes = new ArrayList<>(routeDurations.entrySet());
    sortedRoutes.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));
   
    // Limit to the top 5 longest flight routes
    top5Routes = sortedRoutes.subList(0, Math.min(5, sortedRoutes.size()));

    // Calculate the maximum duration among the top 5 longest flight routes
    float maxDuration = top5Routes.get(0).getValue();

    // Draw the y-axis line and labels
    float y = height - 200; // Updated y position for the origin of the bar chart
    float maxBarHeight = 300; // Maximum bar height
    stroke(0);
    line(220, y, 220, y - maxBarHeight); // Draw y-axis line, moved to the left
    for (int i = 0; i <= 10; i++) {
      float scaledHeight = (i / 10.0) * maxBarHeight; // Scale height based on 0-10 hours
      text(String.valueOf(i), 195, y - scaledHeight + 5); //position of bar
    }
    text("Hours",  110, 350); // Label for y-axis
    text("Flight Routes", 450, 550);// label for x axis
   
    fill(250);
    textSize(50);
    text("Longest Flight Routes ", 100, 100);// title

    // Draw the x-axis line and labels
    float x = 250; // Updated starting x position for the first bar
    for (int i = 0; i < top5Routes.size(); i++) {
      float duration = top5Routes.get(i).getValue();
      String route = top5Routes.get(i).getKey();
      // Calculate the scaled height of the bar
      float scaledHeight = (duration / maxDuration) * maxBarHeight;
      // Draw the bar
      fill(100, 100, 250);
      rect(x, y, 100, -scaledHeight); // Updated width of the bar
      // Draw the x-axis line
      line(x + 50, y, x + 50, y + 5);
      // Display the route below the bar
      fill(0); // Set text color to black
      textSize(15); // Reduced text size for readability
      text(route, x + 50 - textWidth(route) / 2, y + 20); // Adjusted route position, below x-axis
      x += 150; // Adjust x position for the next bar
    }
}
  


  float getTimeDifference(String airport) { //Ciarán Nolan
    switch (airport.toLowerCase()) {
    case "new york":
    case "boston":
    case "philadelphia":
    case "washington":
      return 5; // Eastern Time
    case "chicago":
    case "dallas":
    case "houston":
    case "minneapolis":
    case "miami":
    case "atlanta":
      return 6; // Central Time
    case "denver":
    case "phoenix":
    case "salt lake city":
    case "albuquerque":
      return 7; // Mountain Time
    case "los angeles":
    case "san francisco":
    case "seattle":
    case "portland":
    case "san diego":
      return 8; // Pacific Time
    case "honolulu":
    case "lihue":
      return 10; // Hawaiian Time
    case "anchorage":
      return 8; // Alaska Time
    default:
      return 0;
    }
  }
void drawFlightDurationPieChart() {    //Ciarán Nolan
    if (top5Routes == null) {
        println("No data available for pie chart.");
        return;
    }

    // Calculate total duration of all flights
    float totalDuration = 0;
    for (Map.Entry<String, Float> entry : top5Routes) {
        totalDuration += entry.getValue();
    }

    // Initialize variables for drawing the pie chart
    float startX = 400; // X-coordinate of the center of the pie chart
    float startY = 400; // Y-coordinate of the center of the pie chart
    float diameter = 300; // Diameter of the pie chart
    float lastAngle = 0; // Starting angle for drawing segments

    // Define colors for each flight route
    int[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 0, 255)};

    // Initialize variables for drawing the key index
    float keyX = 650; // X-coordinate of the key index
    float keyY = 100; // Y-coordinate of the key index
    float keySpacing = 25; // Spacing between color and label in the key index
    fill(250);
    textSize(50);
    text("Longest Flight Routes ", 100, 100);// title
    
     textSize(14);
     noStroke();
    // Draw a pie chart segment for each flight route
    for (int i = 0; i < top5Routes.size(); i++) {
        Map.Entry<String, Float> entry = top5Routes.get(i);
        String route = entry.getKey();
        float duration = entry.getValue();
        
        // Calculate the angle of the segment based on the percentage of total duration
        float angle = (duration / totalDuration) * TWO_PI;

        // Set color for the segment
        fill(colors[i % colors.length]);

        // Draw the segment
        arc(startX, startY, diameter, diameter, lastAngle, lastAngle + angle);

        // Draw the corresponding color in the key index
        fill(colors[i % colors.length]);
        rect(keyX, keyY + i * keySpacing, 15, 15);
        fill(0);
        text(route, keyX + keySpacing, keyY + i * keySpacing + 10);

        // Update the starting angle for the next segment
        lastAngle += angle;
    }
}

}
  
