// jescamilla@levementum.com 12/213/14 Description: I had to extract this class in order to be able to pass parameters to components.

//Add new variants for other column Modified by qucw@lenovo.com Jun/04/2015
public class totalCol implements Comparable{
        public totalColItem cwvLineItem {get;set;}
        public totalColItem porLineItem {get;set;}
        public totalColItem othLineItem {get;set;}
        public totalColItem totalCwvLineItem {get;set;}
        public totalColItem totalPorLineItem {get;set;}
        public totalColItem totalOthLineItem {get;set;}
        public string quarter {get;set;}
        public Integer quarterNumber {get;set;}
        public Integer year {get;set;}
        public Integer sortingExpresion {get;set;}
        public Integer colCounter {get;set;}
        
        //Cody Sechelski 10/23/2014 Added custom sorting method
        public Integer compareTo (Object compareTo){
            totalCol tc = (totalCol)compareTo;
            string compString = string.valueOf(this.year) + string.valueOf(this.quarterNUmber);
            string compStringCompareTo = string.valueOf(tc.year) + string.valueOf(tc.quarterNUmber);
            Integer val = 0;
            
            if(compString < compStringCompareTo){
                val = -1;
            }
            if(compString > compStringCompareTo){
                val = 1;
            }
            
            return val;
        }
    }