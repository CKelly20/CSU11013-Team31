import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

class Flights {  // O.Kukoyi and S.Onwubilo added flights class and initialized the variables for data
   String flightDate;
   String mktCarrier;
   int mktFlightNum;
   String origin;
   String originCityName;
   String originState;
   int originWac;
   String destination;
   String destCityName;
   String destState;
   int destWac;
   int crsDepTime;
   int depTime;
   int crsArrTime;
   int arrTime;
   boolean cancelled;
   boolean diverted;
   int distance;
 
 Flights(String[] data) {
  flightDate = data[0];
  mktCarrier = data[1]; //<>//
  mktFlightNum = int(data[2]);
  origin = data[3];
  originCityName = data[4];
  originState = data[5];
  originWac = int(data[6]);
  destination = data[7];
  destCityName = data[8];
  destState = data[9];
  destWac = int(data[10]);
  crsDepTime = int(data[11]);
  depTime = int(data[12]);
  crsArrTime = int(data[13]);
  arrTime = int(data[14]);
  cancelled = data[15].equals("1.00") || data[15].equals("1");
  diverted = data[16].equals("1");
  distance = int (data[17]);
 }
 
 }
