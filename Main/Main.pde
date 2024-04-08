 //<>// //<>//
import controlP5.*;

String[] lines;
PFont stdFont;
PFont myFont;
Widget widget1, widget2, widget3, widget4, widget5, widget6, widget7; 
Screen currentScreen,screen1, screen2, screen3, screen4, screen5, screen6, screen7;
Render currentRender;

Flights[] flights;                         // Array containing all our Flights.

String[] cancelledStates;                  // Handles Query 2
float[]  cancellationCount;
aBarChart  cancellationChart;
ControlP5 cp5;
DropdownList d1;
String dropdownQueryDisplay="";

void settings(){
size(SCREENX, SCREENY);
}


void setup() {  
  frameRate(60);
  lines = loadStrings("flights2k.csv"); // Load data from file into an array of strings
  flights = new Flights[lines.length]; //// Create an array of Flights objects
  
  flightsByState = new HashMap<String, ArrayList<Flights>>();
  
  for (int i = 1; i < lines.length; i++) {
    String[] data = lines[i].split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    flights[i] = new Flights(data);
     Flights flight = flights[i];
    String originState = flight.originState;
    if (!flightsByState.containsKey(originState)) {
      flightsByState.put(originState, new ArrayList<Flights>());
    }
    flightsByState.get(originState).add(flight);
  }
  stdFont = loadFont("Candara-Italic-30.vlw");
  textFont(stdFont);
  
   widget1 = new Widget(30, 450, 400, 40, "Leading States in cancellations.", color(125, 150, 200),
          stdFont, EVENT_BUTTON1);
  widget2 = new Widget(110, 330, 220, 40, "Longest flights", color(125, 150, 200),        
         stdFont, EVENT_BUTTON2); 
  widget3 = new Widget(110, 390, 220, 40, "Busiest Airports", color(125, 150, 200),
          stdFont, EVENT_FORWARD); 
  widget4 = new Widget(40, 630, 200, 40, "Return", color(100, 155, 150),
          stdFont, EVENT_BACKWARD);
  widget5 =  new Widget(40, 630, 100, 40, "About", color(125, 150, 200),
          stdFont, EVENT_BUTTON3);
 Widget moreInfoButton = new Widget(width - 250, height - 100, 200, 50, "More Info",
                      color(125, 150, 200), stdFont, EVENT_MORE_INFO);
  moreInfoButton.draw();
  widget6 = new Widget(110,270,220,40,"Set Date Range", color(125, 150, 200),
          stdFont, EVENT_BUTTON6);
  widget7 =  new Widget(40, 630, 200, 40, "Return", color(100, 155, 150),
          stdFont, EVENT_BACKWARD2);
  
  screen1 = new Screen(color(200,204,225), new ArrayList<Widget>(), 1);
  screen2 = new Screen(color(24,162,154), new ArrayList<Widget>(), 2);
  screen3 = new Screen(color(24,162,154), new ArrayList<Widget>(), 3);
  screen4 =  new Screen(color(24,162,154), new ArrayList<Widget>(), 4);
  screen5 = new Screen(color(24,162,154), new ArrayList<Widget>(),5);
  screen6= new Screen(color(24,162,154), new ArrayList<Widget>(), 8);
  screen7=  new Screen(color(24,162,154), new ArrayList<Widget>(), 2);
  screen1.addWidget(widget1, widget2);
  screen1.addWidget(widget3, widget5);
  screen1.addWidget(widget6);
  screen2.addWidget(widget4);
  screen3.addWidget(widget4);
  screen4.addWidget(widget4);
  screen6.addWidget(widget4);
  screen7.addWidget(widget4, moreInfoButton);
  currentScreen = screen1;
  currentRender = new Render (QUERY_NULL, null);    //Setting up our render object 
  screen5.addWidget(widget7);  //Setting up a render object  

  
  backgroundImage = loadImage("background.jpg");    // This is for the screens class  
  backgroundImage.resize(width, height);
  logo = loadImage("logo.png");
 
  cancelledStates = topCancelledOriginStates(flights);                     // Find the data then create the chart for Query 2
  cancellationCount =  getAmountCancelled(flights,cancelledStates);
  BarChart barChart = new BarChart(this);                               
  cancellationChart = new aBarChart(barChart, cancellationCount, cancelledStates, "State", "No. of flights cancelled",
  "Top 5 States for flight Cancellations.");                               //Parameters (barChart, Data Array, LabelArray, xLabel, yLabel, Title)
  
  cp5 = new ControlP5(this);
  d1 = cp5.addDropdownList("myList-d1").setPosition(60, 100);              // Creating dropDown menu. 
  customize(d1); // customize the first list                               // Hide all the minor details getting assigned.
  cp5.setAutoDraw(false);                                                  // We decide when to draw the menu.
  myFont = createFont("Arial", 14);  
  cp5.setFont(myFont);     
}

void draw() {  
  currentScreen.draw();
  currentRender.draw();
  if(currentScreen == screen4){
    shape(americaMap, -150, 20);
    drawStateDots();
  }else if (currentScreen == screen5) {
    drawFlightInfoScreen();
  }
  }



void mousePressed(){
  switch(currentScreen.getEvent(mouseX, mouseY)) {
   case EVENT_BUTTON1:              //Button for Query 2   ie, Cancelled Flights
     currentRender.query= QUERY_2;
     currentScreen = screen2;
     break;
   case EVENT_BUTTON2:        //Button for Query 3
     currentRender.query= QUERY_3;
     currentScreen = screen7;
     currentRender.data= lines;
     break;
     case EVENT_BUTTON3:        //Button for About
     currentScreen = screen3;
     break;
   case EVENT_MORE_INFO:
      println("More Information button pressed!");
      currentScreen = screen6;// Switch to the new screen for pie chart
      currentRender.query=QUERY_5;
      currentRender.data=lines;
      break;
    case EVENT_FORWARD:              //Button for Query 1
      currentScreen = screen2;
      currentRender.query= QUERY_1;
      currentRender.data = lines;
      break;
   case EVENT_BACKWARD:                  // Home Button. Brings us back to screen 1 and resets query!
     currentScreen = screen1;
     currentRender.query= QUERY_NULL;
     break;
   case EVENT_BUTTON6:
     promptForDateRange();
     if (startDate != null || endDate != null) {
     currentScreen = screen4;
     loadMap();
     }
     else 
     currentScreen = screen1;
     break; 
    case EVENT_BACKWARD2:
     currentScreen = screen4;
     currentRender.query= QUERY_NULL;
     break;
   }
    handleMapScreenClick();
}
   
   void mouseMoved(){      //Changes Colour of widgets outline when mouse hovers them
  int event;
  ArrayList widgetList = currentScreen.getWidgets();
  for(int i = 0; i<widgetList.size(); i++){
  Widget aWidget = (Widget) widgetList.get(i);
  event = aWidget.getEvent(mouseX,mouseY);
  if(event != EVENT_NULL){
    aWidget.mouseOver();
  }
  else
    aWidget.mouseNotOver();  
}
}

/**
 * Sets the minor details for the provide dropDown menu.
 * These details include the addition of labels and the
 * proportions of all the different components that make the list.
 *
 *@author  C. Kelly
 *@param   ddl       A DropdownList object 
 */
void customize(DropdownList ddl) {     
  ddl.setItemHeight(40);
  ddl.setBarHeight(30);
  ddl.setCaptionLabel("Select State");
  ddl.setSize(125,200);

  addStatesToDropdown(ddl,flights);
  
  ddl.setColorBackground(color(204,102,0));
  ddl.setColorActive(color(255, 128, 128));
}


/**
 *Handles retrieving a value upon pressing 
 *an option from a drop down menu and processing 
 *that value to be displayed on the screen.
 *Implemented using the controlP5 library.
 *
 *@author  C. Kelly
 *@param   theEvent    A ControlEvent object created on button press by the controlP5 library
 */
void controlEvent(ControlEvent theEvent) {        

  if (theEvent.isController()) { 
    String selectedState = theEvent.getController().getLabel();

    int cancelledFlightsCount;
    
    Map test = d1.getItem(selectedState);
    if (test != null && test.containsKey("value")) {
      cancelledFlightsCount = (int)Float.parseFloat(test.get("value").toString());
      dropdownQueryDisplay=(selectedState+" had " +cancelledFlightsCount+" cancelled flights!");
      println(dropdownQueryDisplay);
    }
  }
}
