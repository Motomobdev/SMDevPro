global class DeviceDates{
	
    global class DeviceIDLEDate implements Comparable {
        public ID DeviceID {get;set;}
        public Date LEDate {get;set;}
        
        global Integer compareTo(Object compareTo) {
            DeviceIDLEDate compareDate = (DeviceIDLEDate)compareTo;
            if(LEDate == compareDate.LEDate) return 0;
            if(LEDate > compareDate.LEDate) return 1;
            return -1;
        }
    }
    
    global class DeviceIDTADate implements Comparable {
        public ID DeviceID {get;set;}
        public Date TADate {get;set;}
        
		global Integer compareTo(Object compareTo) {
        	DeviceIDTADate compareDate = (DeviceIDTADate)compareTo;
			if(TADate == compareDate.TADate) return 0;
            if(TADate > compareDate.TADate) return 1;
            return -1;
        }
    }
    
    global class DeviceIDSADate implements Comparable {
        public ID DeviceID {get;set;}
        public Date SADate {get;set;}

        global Integer compareTo(Object compareTo) {
			DeviceIDSADate compareDate = (DeviceIDSADate)compareTo;
            if(SADate == compareDate.SADate) return 0;
            if(SADate > compareDate.SADate) return 1;
            return -1;
        }
    }

}