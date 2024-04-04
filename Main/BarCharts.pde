import org.gicentre.utils.stat.*;

class aBarChart {            // Author: C.Kelly   Added a bar chart class that enables us to make bar charts quite easily 27/03
  BarChart barChart;
  float[] dataDisplay;
  String[] labelDisplay;
  String title;

  aBarChart(BarChart chart, float[]inputData, String[]inputLabels, String xLabel, String yLabel, String title) {
    
    this.title=title;
    barChart = chart;
    barChart.setData(inputData);

    barChart.setMinValue(0);
    barChart.setMaxValue(50);

    barChart.showValueAxis(true);
    barChart.setBarLabels(inputLabels);
    barChart.showCategoryAxis(true);
    barChart.setCategoryAxisLabel(xLabel);
    barChart.setValueAxisLabel(yLabel);
      
    //Colour
    barChart.setBarColour(#26e05b); // Green
    barChart.setAxisLabelColour(color(#e02626));    //Red
    barChart.setAxisValuesColour(color(0));
    barChart.setBarGap(10); 
    barChart.setBarPadding(10);
  }

  void draw() {
    barChart.draw(SCREENX/4, SCREENY/10, width - 400 , height - 100);
    fill(#9A2617);
    textSize(37);
    text(this.title, SCREENX/2-65,90);
  }
}
