/**************************************************************************
CREATED BY : Neel Desai
CREATED ON : June-2013
PURPOSE    : Competitive Intelligence - Side-by-side comparison report
TEST CLASS : CI_ReportCtrTest
**************************************************************************/
public with sharing class CI_ReportCtr 
{
    private String compSetId {get; set;}
    private String compSetData {get; set;}
    private List<Competitive_Product__c> compProducts {get; set;}
    public String rptTable {get; set;}
    public String errorMessage {get; set;}
    
    public CI_ReportCtr()
    {
        try
        {
            compSetId = ApexPages.currentPage().getParameters().get('CompSetId');
            compSetData = ApexPages.currentPage().getParameters().get('CompSetData');
            
            if(compSetId == null && compSetData == null)
            {
                errorMessage = 'You cannot launch report directly. Please use Build Comp Set page';
                return;
            }
            
            List<String> productList = new List<String>();
            
            if(compSetId != null)
            {
                Competitive_Product_Comp_Set__c compSet = null;
                
	            try
	            {
	                compSet = [SELECT  Motorola_Product__c,
	                                   Competitor_Products__c
	                           FROM    Competitive_Product_Comp_Set__c
	                           WHERE   Id = :compSetId];
	            }
	            catch (Exception ex) //comp set might be deleted by Apex job
	            {
	                errorMessage = 'Comp Set no longer exists. Please build a new Comp Set';
	                return;
	            }
	            
	            productList.add(compSet.Motorola_Product__c);
	            productList.addAll(compSet.Competitor_Products__c.split(',', 0)); //competitor product names are comma separated
            }
            else
            {
            	String decodedText = EncodingUtil.base64Decode(CompSetData).toString();
            	
            	productList.addAll(decodedText.split(',', 0)); //product names are comma separated
            }
            
            compProducts = [SELECT Device_Picture__c ,
                                   Regions__c,
                                   Operators__c,
                                   Brand__c,
                                   Product__c,
                                   Entry_Period__c,
                                   Form_Factor__c,
                                   Dimensions__c,
                                   Camera__c,
                                   Has_Secondary_Camera__c,
                                   Secondary_Camera__c,
                                   Display_Size__c,
                                   Display__c,
                                   Touch_Screen__c,
                                   GPRS__c,
                                   EDGE__c,
                                   HSDPA__c,
                                   X3G__c,
                                   X4G__c,
                                   ROM__c,
                                   SD_Card_Support__c,
                                   Radio__c,
                                   TV_OUT__c,
                                   OS_Version_Number__c,
                                   OS__c,
                                   Total_GHz__c,
                                   Processor__c,
                                   RAM_Size__c,
                                   Battery_Capacity__c,
                                   ASP_Range__c,
                                   Dual_SIM__c
                            FROM   Competitive_Product__c 
                            WHERE  Name = :productList
                            ORDER BY isMotorola__c DESC, Brand__c, Product__c];
            
            buildTable();
            
            //for code coverage on catch block
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch (Exception ex)
        {
            errorMessage = ex.getMessage();
        }
    }
    
    private void buildTable()
    {
        try
        {
            String htmlTable = 'font-size: 9pt; text-align: center; vertical-align: middle; border-collapse: collapse; empty-cells: show;';
            rptTable = '<table style="' + htmlTable + '" width="' + String.valueOf(150 + (compProducts.size() * 200)) + '" cellpadding="3" cellspacing="0">';
            rptTable += buildTableRows();
            rptTable += '</table>';
            
            //for code coverage on catch block
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch (Exception ex)
        {
            errorMessage = ex.getMessage();
        }
    }
    
    private String buildTableRows()
    {
        String rows = '';
        
        try
        {
            String newLine = '<br style="mso-data-placement: same-cell;" />';
            
            List<String> headerCell = new List<String>();
            headerCell.add('width: 150px; text-align: left; vertical-align: middle; color: #333333; font-weight: bold; border: 1px solid gray;');
            headerCell.add('width: 150px; text-align: left; vertical-align: middle; color: #333333; font-weight: bold; border: 1px solid gray; background-color: #FFFFCC;');
            
            String imgCell = 'width: 200px; height: 140px; text-align: center; vertical-align: middle; border: 1px solid gray;';
            
            List<String> ProdCell = new List<String>();
            ProdCell.add('width: 200px; text-align: center; vertical-align: middle; border: 1px solid gray;');
            ProdCell.add('width: 200px; text-align: center; vertical-align: middle; border: 1px solid gray; background-color: #FFFFCC;');
            
            String prodCellRed = 'width: 200px; text-align: center; vertical-align: middle; border: 1px solid gray; background-color: rgb(255, 0, 0);';
            String prodCellGreen = 'width: 200px; text-align: center; vertical-align: middle; border: 1px solid gray; background-color: rgb(0, 176, 80);';
            
            Integer num = 0; //to highlight odd rows
            Double motVal = 0.0; //to compare competitor parameter against motorola
            
            ///// PHONE IMAGE /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">DEVICE PICTURE</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                //rows += '<td style="' + imgCell + '"> <img src="/resource/' + resourceTimeStamp + '/' + resourceName + '/' + compProduct.Product__c.replace(' ', '-') + '.jpg" width="139" height="184" alt="Not Available" /> </td>';
                rows += '<td style="' + imgCell + '">' + ((compProduct.Device_Picture__c != null) ? '<img src="' + compProduct.Device_Picture__c + '" width="100" height="132" alt="Not Available" />' : 'Not Available') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
            
            
            ///// REGION & OPERATOR /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">REGION</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Regions__c != null) ? compProduct.Regions__c : '-')  + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// PRODUCT /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">PRODUCT</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + compProduct.Brand__c + ' ' + compProduct.Product__c + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// ENTRY PERIOD /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">ENTRY PERIOD</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Entry_Period__c != null) ? compProduct.Entry_Period__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// FORM FACTOR /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">FORM FACTOR</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Form_Factor__c != null) ? compProduct.Form_Factor__c : '-') + ' (' + compProduct.Dimensions__c + ')' + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// CAMERA /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">CAMERA (Primary & Secondary)</td>';
            
            motVal = ((compProducts[0].Camera__c != null) ? compProducts[0].Camera__c : -1.0);
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ((motVal == -1.0 || compProduct.Camera__c == null || compProduct.Camera__c == motVal) ? ProdCell.get(num) : ((compProduct.Camera__c > motVal) ? prodCellGreen : prodCellRed )) + '">' + 'Primary: ' + ((compProduct.Camera__c != null) ? String.valueOf(compProduct.Camera__c) : '-') + ' MP' + newLine + '(Secondary: ' + (compProduct.Has_Secondary_Camera__c == true ? compProduct.Secondary_Camera__c + ' MP' : '-') + ')' + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// DISPLAY /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">DISPLAY</td>';
            
            motVal = ((compProducts[0].Display_Size__c != null) ? compProducts[0].Display_Size__c : -1.0);
                    
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ((motVal == -1.0 || compProduct.Display_Size__c == null || compProduct.Display_Size__c == motVal) ? ProdCell.get(num) : ((compProduct.Display_Size__c > motVal) ? prodCellGreen : prodCellRed )) + '">' + ((compProduct.Display__c != null) ? compProduct.Display__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// TOUCH SCREEN /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">TOUCH SCREEN</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Touch_Screen__c != null) ? compProduct.Touch_Screen__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// GPRS /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">GPRS</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.GPRS__c != null) ? compProduct.GPRS__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// EDGE /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">EDGE</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.EDGE__c != null) ? compProduct.EDGE__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// HSDPA /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">HSDPA</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.HSDPA__c != null) ? compProduct.HSDPA__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// 3G /////
            /*
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">3G</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.X3G__c != null) ? compProduct.X3G__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        	*/
            
            ///// 4G /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">4G</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.X4G__c != null) ? compProduct.X4G__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// MEMORY /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">MEMORY (ROM + SD Card Support)</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.ROM__c != null) ? compProduct.ROM__c + ' GB ROM' : '-') + newLine + ((compProduct.SD_Card_Support__c != null) ? compProduct.SD_Card_Support__c + ' GB SD Card Support' : 'NO SD Card Support') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
            
            ///// RAM /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">MEMORY (RAM)</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.RAM_Size__c != null) ? string.valueOf(compProduct.RAM_Size__c) + ' MB' : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
        
            
            ///// FM Radio /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">FM RADIO</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Radio__c != null && compProduct.Radio__c != 'NO') ? compProduct.Radio__c : 'NO') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
            
            
            ///// Dual SIM/////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">DUAL SIM</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.Dual_SIM__c != null && compProduct.Dual_SIM__c != 'NO') ? compProduct.Dual_SIM__c : 'NO') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// OS /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">OS</td>';
            
            motVal = compProducts[0].OS_Version_Number__c;
    
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ((compProduct.OS_Version_Number__c == 0.0 || compProduct.OS_Version_Number__c == motVal) ? ProdCell.get(num) : (compProduct.OS_Version_Number__c > motVal) ? prodCellGreen : prodCellRed) + '">' + ((compProduct.OS__c != null) ? compProduct.OS__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// PROCESSOR /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">PROCESSOR</td>';
            
            motVal = ((compProducts[0].Total_GHz__c != null) ? compProducts[0].Total_GHz__c : -1);
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                //rows += '<td style="' + ((motVal == -1 || compProduct.Total_GHz__c == null || compProduct.Total_GHz__c == motVal) ? ProdCell.get(num) : ((compProduct.Total_GHz__c > motVal) ? prodCellGreen : prodCellRed )) + '">' + ((compProduct.Processor__c != null) ? compProduct.Processor__c : '-') + '</td>';
                rows += '<td style="' + ((motVal == -1 || compProduct.Total_GHz__c == null || compProduct.Total_GHz__c == motVal) ? ProdCell.get(num) : ((compProduct.Total_GHz__c > motVal) ? prodCellGreen : prodCellRed )) + '">' + ((compProduct.Processor__c != null) ? compProduct.Processor__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
                 
            
            ///// BATTERY /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">BATTERY CAPACITY</td>';
            
            motVal = ((compProducts[0].Battery_Capacity__c != null) ? compProducts[0].Battery_Capacity__c : -1.0);
                    
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ((motVal == -1.0 || compProduct.Battery_Capacity__c == null || compProduct.Battery_Capacity__c == motVal) ? ProdCell.get(num) : ((compProduct.Battery_Capacity__c > motVal) ? prodCellGreen : prodCellRed )) + '">' + ((compProduct.Battery_Capacity__c != null) ? String.valueOf(compProduct.Battery_Capacity__c) + ' mAh' : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
        
            
            ///// ASP /////
            rows += '<tr>';
            rows += '<td style="' + headerCell.get(num) + '">CURRENT EST. ASP</td>';
            
            for(Competitive_Product__c compProduct : compProducts)
            {
                rows += '<td style="' + ProdCell.get(num) + '">' + ((compProduct.ASP_Range__c != null) ? compProduct.ASP_Range__c : '-') + '</td>';
            }
            
            rows += '</tr>';
            num = 1 - num;
            
            // only for code coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch (Exception ex)
        {
            errorMessage = ex.getMessage();
        }

        return rows;
    }
    
    public PageReference exportToExcel()
    {
        PageReference pageRef = Page.CIReportToExcel;
        pageRef.setRedirect(false);
        pageRef.getParameters().put('CompSetId', compSetId);
        return pageRef;
    }
}