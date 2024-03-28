class FlightDuration implements Comparable<FlightDuration> {
  String airportName;
  float duration;
  
  FlightDuration(String airportName, float duration) {
    this.airportName = airportName;
    this.duration = duration;
  }
  
  @Override
  public int compareTo(FlightDuration other) {
    return Float.compare(this.duration, other.duration);
  }
}
