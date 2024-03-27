PFont boldFont;
PImage backgroundImage;

class Screen{
  color background;
  ArrayList<Widget> screenWidgets;
  int event;
  int screenTracker;                          // Allows our screen class to know which screen it's on

  Screen(color background, ArrayList<Widget> widgets, int screenTracker){
    this.background = background;
    this.screenWidgets = widgets;
    this.screenTracker=screenTracker;
  }

  void addWidget(Widget widget1, Widget widget2){
    screenWidgets.add(widget1);
    screenWidgets.add(widget2);
  }
  
   void addWidget(Widget widget1){
    screenWidgets.add(widget1);
  }

  int getEvent(int mX, int mY){
    for(int i = 0; i < screenWidgets.size(); i++){
      if(mX > screenWidgets.get(i).x && mX < screenWidgets.get(i).x + screenWidgets.get(i).width && mY > screenWidgets.get(i).y
        && mY < screenWidgets.get(i).y + screenWidgets.get(i).height){
        return screenWidgets.get(i).event;
      }
    }
    return EVENT_NULL;
  }

  void draw(){
   background(background);
   
   if(screenTracker==1){                //If on main screen draw image and our Heading 
   image(backgroundImage, 0, 0);
   textSize(128);      //Heading
   fill(255);
   text("Flight Tracker", 165, 180);
   }  
   for(int i = 0; i < screenWidgets.size(); i++){
     screenWidgets.get(i).draw();
   } 
  }
  
  ArrayList getWidgets()
  {
    return screenWidgets;
  }
  
}
