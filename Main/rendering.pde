class Render {
  int query;
  final int barHeight = 50;
  final color hoverColor = color(255, 0, 0);
  final color buttonColor = color(255);
  float[] values = {100, 200, 300}; // Example values
  float maxValue = 300; // Example max value
  String[] labels = {"Label 1", "Label 2", "Label 3"}; // Example labels

  Render(int userQuery) {
    this.query = userQuery;
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
}
