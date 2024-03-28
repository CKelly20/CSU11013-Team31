import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.Comparator;

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
        drawLongestFlightDurations(); // Draw the bar chart for the third query
        break;
    }
  }

  
  void drawBusiestAirports() {
  if (data == null) return; // Add this line to guard against null data

  HashMap<String, Integer> airportCounts = new HashMap<>(data.length);
  for (String line : data) {
    String[] parts = line.split(",");
    String airportName = parts[3].trim(); // Adjust the index according to your data structure
    airportCounts.put(airportName, airportCounts.getOrDefault(airportName, 0) + 1);
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
  
  textSize(12);

  for (int i = 0; i < sortedEntries.size(); i++) {
    Entry<String, Integer> entry = sortedEntries.get(i);
    fill(100, 100, 250); // Bar color
    float scaledHeight = (entry.getValue().floatValue() / maxCount) * maxBarHeight; // Scale height based on max value
    rect(x + (barWidth + 10) * i, y - scaledHeight, barWidth, scaledHeight);
    fill(0);
    text(entry.getKey(), x + (barWidth + 10) * i + barWidth / 2, y + 20); // Display the airport name below the bar, adjusting position for readability

    // Display count next to each bar
    fill(50);
    text(entry.getValue(), x + (barWidth + 10) * i + barWidth / 2, y - scaledHeight - 5);
  }
}

void drawLongestFlightDurations() {
    float longestDuration = 0;
    for (String line : data) {
      String[] parts = line.split(","); // Split the line by comma
      int depTime = int(parts[12]); // Get departure time 
      int arrTime = int(parts[14]); // Get arrival time 
      float duration = (arrTime - depTime) / 60.0; // Calculate duration in minutes
      longestDuration = max(longestDuration, duration); // Update longest duration if necessary
    }
    
    // Draw the bar chart for the longest flight duration
    fill(255);
    textSize(20);
    textAlign(CENTER, BOTTOM);
    text("Longest Flight Durations", width / 2, 50);

    float barHeight = 30;
    float startX = 200;
    float startY = 100;
    float barWidth = longestDuration * 5; // Scale the bar width based on the longest duration

    fill(0, 0, 255);
    rect(startX, startY, barWidth, barHeight);

    fill(0);
    textAlign(LEFT, BOTTOM);
    text("Longest Duration: " + nf(longestDuration, 0, 2) + " minutes", startX + barWidth + 10, startY + barHeight);
  }
}

  
