public class Tab_Con {
    
    public Integer randomSuffix{get;set;}
     public Boolean isExcelRender {get;set;} // jescamilla@levementum.com 9/26/14 Description: Sense if this is excel.
    
    public Tab_Con(){
        randomSuffix = getRandomNumber(1000000);
        PageReference myVFP = ApexPages.currentPage();
        if(myVFP.getParameters().get('rerenderPageToExcel') != null){
            isExcelRender = true;
        }
    }
    
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    static testMethod void testCon(){
        Tab_Con controller = new Tab_Con ();
        System.assertNotEquals(Null,controller.randomSuffix);
    }
    
}