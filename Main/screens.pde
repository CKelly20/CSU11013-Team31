PFont boldFont;
PImage backgroundImage;

class Screen{
  color background;
  ArrayList<Widget> screenWidgets;
  int event;

  Screen(color background, ArrayList<Widget> widgets){
    this.background = background;
    this.screenWidgets = widgets;
  }

  void addWidget(Widget widget1, Widget widget2){
    screenWidgets.add(widget1);
    screenWidgets.add(widget2);
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
   image(backgroundImage, 0, 0);
   for(int i = 0; i < screenWidgets.size(); i++){
     screenWidgets.get(i).draw();
   }
   
   // Heading
   textSize(128);
   fill(255);
   text("Flight Tracker", 165, 180);
   
   
  }
  
  ArrayList getWidgets()
  {
    return screenWidgets;
  }
  
}
