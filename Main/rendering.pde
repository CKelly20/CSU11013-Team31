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
    if (query == QUERY_1) {
      float barWidth = 0;
      float startX = 560;
      float startY = 190;

      for (int i = 0; i < values.length; i++) {
        float normalizedWidth = map(values[i], 0, maxValue, 0, 600);
        fill(0, 0, 255);
        rect(startX, startY + i * 80, normalizedWidth, barHeight);

        fill(#F0E929);
        textAlign(RIGHT);
        text(labels[i], startX - 10, startY + i * 80 + barHeight / 2);
      }
       if (mouseX > 250 && mouseX < 550 && mouseY > 800 && mouseY < 850) {
        fill(hoverColor);
      } else {
        fill(buttonColor);
      }
      stroke(0);
      strokeWeight(2);
      rect(250, 800, 300, 50);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Backward", 400, 825);
    }
    }

  
  void drawBusiestAirports() {
  if (data == null) return; // Add this line to guard against null data

  HashMap<String, Integer> airportCounts = new HashMap<>();
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
  float y = height - 170; // y position, leaving space for text
  float barWidth = (width - 100) / sortedEntries.size() - 10; // Dynamically calculate bar width
  float maxBarHeight = 300; // Maximum bar height
  int maxCount = sortedEntries.get(0).getValue(); // Highest value for scaling
  
  textSize(12);
  textAlign(CENTER, BOTTOM);

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
}

  
