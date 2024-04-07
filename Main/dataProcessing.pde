
String[] topCancelledOriginStates(Flights[] allFlights) {      // Author: C.Kelly   Function to find the top 5 states with the most cancelled flights
 
  Map<String, Integer> stateCancellationCounts = new HashMap<String, Integer>();  // Use a HashMap to count cancellations per state

  for (int i =1; i<allFlights.length;i++){
    Flights oneFlight =allFlights[i];
    if (oneFlight.cancelled) {                             
      String state = oneFlight.originState;                                                                                                                       
      stateCancellationCounts.put(state, stateCancellationCounts.getOrDefault(state, 0) + 1);    // Increase the count for the state or initialize it if it doesn't exist
    }
  }
  List<Map.Entry<String, Integer>> list = new ArrayList<>(stateCancellationCounts.entrySet());     // Convert the map to a list of map entries  
  list.sort((entry1, entry2) -> entry2.getValue().compareTo(entry1.getValue()));        // Sort the list by the number of cancellations, descending //<>//

  int size = Math.min(5, list.size());            // Create an array for the top 5 states
  String[] topStates = new String[size];
  
  for (int i = 0; i < size; i++) {                  // Fill the array with the states
    topStates[i] = list.get(i).getKey();
  }
  return topStates;
}

float[] getAmountCancelled(Flights[] allFlights, String[] fiveStates){    // Author: C.Kelly  Takes in an array of states and returns their amount of cancellations in order they were entered.
      
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

/**
Author: C.Kelly

 Any state that appears in the data gets included in the drop down menu,
 along with the amount of cancelled flights it has.
 
 Method modifies the passed in DropdownList with the data mentioned
 above.
 
 @param ddl a DropdownList object
 @param allFlights  an array containing all flight objects
*/
void addStatesToDropdown(DropdownList ddl, Flights[] allFlights) {      
  
  HashMap<String, Integer> stateCancelCount = new HashMap<String, Integer>();    // This HashMap will keep track of states and their cancelled flights count
  
  for (int i =1; i<allFlights.length;i++){
    Flights oneFlight =allFlights[i];
    String state = oneFlight.originState;  
    
        
    if (!stateCancelCount.containsKey(state)) {      // Initialize the count for the state if it hasn't been added yet
      stateCancelCount.put(state, 0);
    }

    if (oneFlight.cancelled) {                            // If the flight is cancelled, increment the state's count
      stateCancelCount.put(state, stateCancelCount.get(state) + 1);
    }
  }
  
  for (Map.Entry<String, Integer> entry : stateCancelCount.entrySet()) {      // Now add states to the dropdown list with the count of cancelled flights as the value
    ddl.addItem(entry.getKey(), entry.getValue());
  }
}
