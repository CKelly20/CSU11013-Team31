
String[] topCancelledOriginStates(Flights[] allFlights) {      // Function to find the top 5 states with the most cancelled flights
 
  Map<String, Integer> stateCancellationCounts = new HashMap<String, Integer>();  // Use a HashMap to count cancellations per state

  for (int i =1; i<allFlights.length;i++){
    Flights oneFlight =allFlights[i];
    if (oneFlight.cancelled) {                             
      String state = oneFlight.originState;                                                                                                                       
      stateCancellationCounts.put(state, stateCancellationCounts.getOrDefault(state, 0) + 1);    // Increase the count for the state or initialize it if it doesn't exist
    }
  }
  List<Map.Entry<String, Integer>> list = new ArrayList<>(stateCancellationCounts.entrySet());     // Convert the map to a list of map entries  
  list.sort((entry1, entry2) -> entry2.getValue().compareTo(entry1.getValue()));        // Sort the list by the number of cancellations, descending

  int size = Math.min(5, list.size());            // Create an array for the top 5 states
  String[] topStates = new String[size];
  
  for (int i = 0; i < size; i++) {                  // Fill the array with the states
    topStates[i] = list.get(i).getKey();
  }
  return topStates;
}

float[] getAmountCancelled(Flights[] allFlights, String[] fiveStates){
      
    float[] cancellationsCount = new float[fiveStates.length];     // Initialize an array to hold the cancellation counts for each of the five states
    for (int i=1; i<allFlights.length;i++){                        // Iterate through all flights and count cancellations for the specified states    
        Flights oneFlight =allFlights[i];
        if (oneFlight.cancelled) {
            for (int j = 0; j < fiveStates.length; j++) {              // Check if the origin state of the cancelled flight is one of the top 5 states
                if (oneFlight.originState.equals(fiveStates[j])) {
                    cancellationsCount[j]++;
                    break; 
                }
            }
        }
    }
    return cancellationsCount;
}
