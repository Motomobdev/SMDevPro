public without sharing class DateUtil {
	
	public static string getPrevQuarter(){
		Integer startMonth, currMonth, currYear, currQuarterNum, prevYearNum, prevQuarterNum;
        String currQuarter, prevQuarter;
        
        startMonth = [SELECT FiscalYearStartMonth FROM Organization LIMIT 1].FiscalYearStartMonth;
        currMonth = Date.today().month();
        currYear = Date.today().year();

        currQuarterNum = 0;
        if(currMonth - startMonth >= 0){
        	currQuarterNum = (Integer)(currMonth - startMonth)/3 + 1;
        }
        else{
        	currQuarterNum = 4 - (Integer)(startMonth - currMonth - 1)/3;
        }
       
        if(currQuarterNum == 1){
        	prevQuarterNum = 4;
        	prevYearNum = currYear - 1;
        	prevQuarter = 'Q' + string.valueOf(prevQuarterNum) + ' ' + string.valueOf(prevYearNum);
        }
        else{
	        prevQuarterNum = currQuarterNum - 1;
	        prevYearNum = currYear;
	        prevQuarter = 'Q' + string.valueOf(prevQuarterNum) + ' ' + string.valueOf(prevYearNum);
        }
        return prevQuarter;		
	}
	
	public static string getCurrQuarter(){
		Integer startMonth, currMonth, currYear, currQuarterNum;
        String currQuarter;
        String[] selectedQuarters;
        
        startMonth = [SELECT FiscalYearStartMonth FROM Organization LIMIT 1].FiscalYearStartMonth;
        currMonth = Date.today().month();
        currYear = Date.today().year();

        currQuarterNum = 0;
        if(currMonth - startMonth >= 0){
        	currQuarterNum = (Integer)(currMonth - startMonth)/3 + 1;
        	currQuarter = 'Q' + string.valueOf(currQuarterNum) + ' ' + string.valueOf(currYear);
        }
        else{
        	currQuarterNum = 4 - (Integer)(startMonth - currMonth - 1)/3;
        	currQuarter = 'Q' + string.valueOf(currQuarterNum) + ' ' + string.valueOf(currYear);
        }
        return currQuarter;       	
	}
	
	public static string getNextQuarter(){
		Integer startMonth, currMonth, currYear, currQuarterNum, nextYearNum, nextQuarterNum;
        String currQuarter, nextQuarter;
        
        startMonth = [SELECT FiscalYearStartMonth FROM Organization LIMIT 1].FiscalYearStartMonth;
        currMonth = Date.today().month();
        currYear = Date.today().year();

        currQuarterNum = 0;
        if(currMonth - startMonth >= 0){
        	currQuarterNum = (Integer)(currMonth - startMonth)/3 + 1;
        }
        else{
        	currQuarterNum = 4 - (Integer)(startMonth - currMonth - 1)/3;
        }

        if(currQuarterNum == 4){    
      		nextQuarterNum = 1;
            nextYearNum = currYear + 1;
            nextQuarter = 'Q' + string.valueOf(nextQuarterNum) + ' ' + string.valueOf(nextYearNum);
        }
        else{
      		nextQuarterNum = currQuarterNum + 1;
      		nextYearNum = currYear;
      		nextQuarter = 'Q' + string.valueOf(nextQuarterNum) + ' ' + string.valueOf(nextYearNum);
        }
        
        return nextQuarter;
		
	}
	
	public static string getNextPlusQuarter(){
		Integer startMonth, currMonth, currYear, currQuarterNum, nextYearNum, nextQuarterNum, nextPlusYearNum, nextPlusQuarterNum;
        String currQuarter, nextQuarter, nextplusQuarter;
        String[] selectedQuarters;
        
        startMonth = [SELECT FiscalYearStartMonth FROM Organization LIMIT 1].FiscalYearStartMonth;
        currMonth = Date.today().month();
        currYear = Date.today().year();

        currQuarterNum = 0;
        if(currMonth - startMonth >= 0){
        	currQuarterNum = (Integer)(currMonth - startMonth)/3 + 1;
        }
        else{
        	currQuarterNum = 4 - (Integer)(startMonth - currMonth - 1)/3;
        }      

        if(currQuarterNum == 4){    
            nextPlusQuarterNum = 2;
            nextPlusYearNum = currYear + 2;
            nextPlusQuarter = 'Q' + string.valueOf(nextPlusQuarterNum) + ' ' + string.valueOf(nextPlusYearNum);
        }
        else{
      		nextQuarterNum = currQuarterNum + 1;
      		nextYearNum = currYear;

	      	if(nextQuarterNum == 4){
	      		nextPlusQuarterNum = 1;
	            nextPlusYearNum = currYear + 1;
	            nextPlusQuarter = 'Q' + string.valueOf(nextPlusQuarterNum) + ' ' + string.valueOf(nextPlusYearNum);
	        }
	      	else{
	      		nextPlusQuarterNum = 1;
	        	nextPlusYearNum = currYear + 1;
	        	nextPlusQuarter = 'Q' + string.valueOf(nextPlusQuarterNum) + ' ' + string.valueOf(nextPlusYearNum);
	      	}
        }
		return nextPlusQuarter;
	}
}