// jescamilla@levementum.com 12/213/14 Description: I had to extract this class in order to be able to pass parameters to components.
public class SummaryCol  implements Comparable{
        public string productName {get;set;}
        public totalColItem cwvLineItem {get;set;}
        public totalColItem porLineItem {get;set;}
        //Add for other column, modified by qucw@lenovo.com  Jun/04/2015
        public totalColItem othLineItem {get;set;}
        
        //Add for product details on summary 
        public string yearQuarter {get;set;}
        
        //Cody Sechelski 10/24/2014 Added custom sorting method
        public Integer compareTo (Object compareTo){
            SummaryCol sc = (SummaryCol)compareTo;

            Integer val = 0;
            
            if(productName < sc.productName){
                val = -1;
            }
            if(productName > sc.productName){
                val = 1;
            }
            
            return val;
        }
    }