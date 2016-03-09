trigger UpdateFederationId on User (before update, before insert) {
    /*
     * Author: Rajesh Krishnaiah
     * Creation Date: 18-Mar-2010
     * Description: Converts federation ID to uppercase. 
     *              This is a requirement for single sign on to work.
     */
    for (User u : Trigger.new) {
        if (u.FederationIdentifier != null) {
            U.FederationIdentifier = U.FederationIdentifier.toUpperCase();
        }
    }
}