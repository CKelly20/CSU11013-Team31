import org.gicentre.utils.stat.*;


/**
 * Class for creating and displaying a bar chart using gicentre utils.
 * It manages the data, labels, and appearance of the bar chart.
 * 
 * @author C. Kelly
 * @date 27 March
 */
class aBarChart {            
  BarChart barChart;
  float[] dataDisplay;
  String[] labelDisplay;
  String title;

  
  /**
   * Constructor for creating a new bar chart.
   * Sets up the bar chart with the given data, labels, and axis information.
   * Adjusts the maximum value of the bar chart based on the size of the input data.
   * 
   * @param chart       The BarChart object to be used for the bar chart.
   * @param inputData   Array of floats representing the data to be displayed.
   * @param inputLabels Array of strings representing the labels for the data.
   * @param xLabel      The label for the x-axis (category axis).
   * @param yLabel      The label for the y-axis (value axis).
   * @param title       The title of the bar chart.
   */  
  aBarChart(BarChart chart, float[]inputData, String[]inputLabels, String xLabel, String yLabel, String title) {
    
    this.title=title;
    barChart = chart;
    barChart.setData(inputData);

    barChart.setMinValue(0);
    
    if (flights.length >= 100000) {                 // Adjust max range based on amount of data.
    barChart.setMaxValue(1250); 
    } else if (flights.length >= 50000) {
    barChart.setMaxValue(750); 
    } else {
    barChart.setMaxValue(50);                       // Default value
    }
    
    barChart.showValueAxis(true);
    barChart.setBarLabels(inputLabels);
    barChart.showCategoryAxis(true);
    barChart.setCategoryAxisLabel(xLabel);
    barChart.setValueAxisLabel(yLabel);
      
    //Colour
    barChart.setBarColour(#26e05b);                 // Green
    barChart.setAxisLabelColour(color(#e02626));    // Red
    barChart.setAxisValuesColour(color(0));
    barChart.setBarGap(10); 
    barChart.setBarPadding(10);
  }

  /**
   * Draws the bar chart on the screen with the title.
   * Position and size of the chart are based on screen dimensions.
   */  
  void draw() {
    barChart.draw(SCREENX/4, SCREENY/10, width - 400 , height - 100);
    fill(#9A2617);
    textSize(37);
    text(this.title, SCREENX/2-65,90);
  }
}
