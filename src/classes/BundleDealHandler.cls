// jescamilla@levementum.com 12/22/14 Description: SYNC Mechanism for Bundle Deals a change on any children will cause the parent to update
// there will be a trigger on the parent to recalculate all its fields.

//QUOTE TRIGGER HANDLER
public class BundleDealHandler {
     public static void afterUpdate(Quote[] triggerNew, Map<Id, Quote> oldMap){
        System.debug('############### BundleDealHandler triggerNew:' + triggerNew);

        List<Id> parentQuoteIds = new List<Id>();
        List<Id> childQuoteIds = new List<Id>();
        for(Quote qt : triggerNew){
            if(qt.ParentQuote__c != null){
                    parentQuoteIds.add(qt.ParentQuote__c);
                    childQuoteIds.add(qt.Id);
               }
        }

          System.debug('############### parentQuoteIds:' + parentQuoteIds);
          System.debug('############### childQuoteIds:' + childQuoteIds);
          

          Map<Id,Quote> parentQuotes = new Map<Id,Quote>([SELECT Id, HasStoplight__c, HasSummary__c  FROM Quote WHERE Id IN :parentQuoteIds]); //gather all the parent quotes
        Map<Id,Quote> childQuotes = new Map<Id,Quote>([SELECT Id, HasStoplight__c, HasSummary__c, ParentQuote__c  FROM Quote WHERE Id IN :childQuoteIds]); //gather all the child quotes


          

          for(Quote parentQuote : parentQuotes.values()){ //if all children have stoplight and summary sync the parent (for approval process)
               parentQuote.HasStoplight__c = true;
               parentQuote.HasSummary__c = true;
               System.debug('############### parentQuote:' + JSON.serializePretty(parentQuote));
               
               for(Quote childQuote : childQuotes.values()){
                    if(childQuote.ParentQuote__c == parentQuote.Id){
                          //Check Stop Light
                          if(!childQuote.HasStoplight__c)
                              parentQuote.HasStoplight__c = false;

                         //Check has Summary
                          if(!childQuote.HasSummary__c)
                              parentQuote.HasSummary__c = false;
                    }
               }
          }

          Map<Id, QuoteLineItem> parentQlis = new Map<Id, QuoteLineItem>([SELECT Id, Units__c,InvoicePrice__c,SDF__c,COOP__c,MDF__c, iMDF__c, SVM__c,  MinimumCommitQuantity__c, IPP__c, National_Retail__c, CSAT__c, ParentQLI__c, QP__c, TC__c, ILW__c,TDF__c, Fees__c, Negotiation_Buffer__c, MCPU__c, AP__c, motoagents__c  FROM QuoteLineItem WHERE QuoteId IN :parentQuoteIds]); //gather all the child line items
          Map<Id, QuoteLineItem> childQlis = new Map<Id, QuoteLineItem>([SELECT Id, Units__c,InvoicePrice__c,SDF__c,COOP__c,MDF__c, iMDF__c, SVM__c,  MinimumCommitQuantity__c, IPP__c, National_Retail__c, CSAT__c, ParentQLI__c, QP__c, TC__c, ILW__c,TDF__c, Fees__c, Negotiation_Buffer__c, MCPU__c, AP__c, motoagents__c FROM QuoteLineItem WHERE ParentQLI__c IN :parentQlis.keySet()]); //gather all the child line items
          
          if(parentQlis == null)return;
          if(childQlis == null)return;

          try{
               System.debug('############### parentQlis:' + parentQlis);
               System.debug('############### childQlis:' + childQlis);
               
               
               //For Every Parent Sent to Update
               for(QuoteLineItem parentQli : parentQlis.values()){
                    resetFields(parentQli); //Initialize fields to ZERO
                    for(QuoteLineItem childQli : childQlis.values()){
                         if(childQli.ParentQLI__c == parentQli.Id){
                              aggregateFields(parentQli, childQli); //Roll up all the children to the parent.
                         }
                    }
               }

               //Now calculate weighted average on values
               for(QuoteLineItem parentQli : parentQlis.values()){
                  calculateWeightedAverages(parentQli); //Calcualte weighted averages on values.
               }

               update parentQlis.values();
               update parentQuotes.values();

          }catch(Exception e){
               System.debug('############### Error:' + e.getMessage() + ' On Line: ' + e.getLineNumber());
          }
     }

     public static void aggregateFields(QuoteLineItem parentQli, QuoteLineItem childQli){
          parentQli.Units__c += childQli.Units__c == null ? 0 : childQli.Units__c;
          parentQli.MinimumCommitQuantity__c += childQli.MinimumCommitQuantity__c == null ? 0 : childQli.MinimumCommitQuantity__c;
          parentQli.InvoicePrice__c += childQli.InvoicePrice__c == null ? 0 : childQli.InvoicePrice__c * childQli.Units__c;
          parentQli.SDF__c += childQli.SDF__c == null ? 0 : childQli.SDF__c * childQli.Units__c;
          parentQli.COOP__c += childQli.COOP__c == null ? 0 : childQli.COOP__c * childQli.Units__c;
          parentQli.MDF__c += childQli.MDF__c == null ? 0 : childQli.MDF__c * childQli.Units__c;
          parentQli.iMDF__c += childQli.iMDF__c == null ? 0 : childQli.iMDF__c * childQli.Units__c;
          parentQli.SVM__c += childQli.SVM__c == null ? 0 : childQli.SVM__c * childQli.Units__c;
          parentQli.IPP__c += childQli.IPP__c == null ? 0 : childQli.IPP__c * childQli.Units__c;
          parentQli.National_Retail__c += childQli.National_Retail__c == null ? 0 : childQli.National_Retail__c * childQli.Units__c;
          parentQli.CSAT__c += childQli.CSAT__c == null ? 0 : childQli.CSAT__c * childQli.Units__c;
          parentQli.QP__c += childQli.QP__c == null ? 0 : childQli.QP__c * childQli.Units__c;
          parentQli.TC__c += childQli.TC__c == null ? 0 : childQli.TC__c * childQli.Units__c;
          parentQli.ILW__c += childQli.ILW__c == null ? 0 : childQli.ILW__c * childQli.Units__c;
          parentQli.TDF__c += childQli.TDF__c == null ? 0 : childQli.TDF__c * childQli.Units__c;
          parentQli.Fees__c += childQli.Fees__c == null ? 0 : childQli.Fees__c * childQli.Units__c;
          parentQli.Negotiation_Buffer__c += childQli.Negotiation_Buffer__c == null ? 0 : childQli.Negotiation_Buffer__c * childQli.Units__c;
          parentQli.MCPU__c += childQli.MCPU__c == null ? 0 : childQli.MCPU__c * childQli.Units__c;
          parentQli.AP__c += childQli.AP__c == null ? 0 : childQli.AP__c * childQli.Units__c;
          parentQli.motoagents__c += childQli.motoagents__c == null ? 0 : childQli.motoagents__c * childQli.Units__c;
     }
     
     //Calculate weighted averages for the parent deal view.
     public static void calculateWeightedAverages(QuoteLineItem parentQli){
          parentQli.InvoicePrice__c = parentQli.Units__c != 0 ? (parentQli.InvoicePrice__c / parentQli.Units__c) : 0;
          parentQli.SDF__c = parentQli.Units__c != 0 ? (parentQli.SDF__c / parentQli.Units__c) : 0;
          parentQli.COOP__c = parentQli.Units__c != 0 ? (parentQli.COOP__c / parentQli.Units__c) : 0;
          parentQli.MDF__c = parentQli.Units__c != 0 ? (parentQli.MDF__c / parentQli.Units__c) : 0;
          parentQli.iMDF__c = parentQli.Units__c != 0 ? (parentQli.iMDF__c / parentQli.Units__c) : 0;
          parentQli.SVM__c = parentQli.Units__c != 0 ? (parentQli.SVM__c / parentQli.Units__c) : 0;
          parentQli.IPP__c = parentQli.Units__c != 0 ? (parentQli.IPP__c / parentQli.Units__c) : 0;
          parentQli.National_Retail__c = parentQli.Units__c != 0 ? (parentQli.National_Retail__c / parentQli.Units__c) : 0;
          parentQli.CSAT__c = parentQli.Units__c != 0 ? (parentQli.CSAT__c / parentQli.Units__c) : 0;
          parentQli.QP__c = parentQli.Units__c != 0 ? (parentQli.QP__c / parentQli.Units__c) : 0;
          parentQli.TC__c = parentQli.Units__c != 0 ? (parentQli.TC__c / parentQli.Units__c) : 0;
          parentQli.ILW__c = parentQli.Units__c != 0 ? (parentQli.ILW__c / parentQli.Units__c) : 0;
          parentQli.TDF__c = parentQli.Units__c != 0 ? (parentQli.TDF__c / parentQli.Units__c) : 0;
          parentQli.Fees__c = parentQli.Units__c != 0 ? (parentQli.Fees__c / parentQli.Units__c) : 0;
          parentQli.Negotiation_Buffer__c = parentQli.Units__c != 0 ? (parentQli.Negotiation_Buffer__c / parentQli.Units__c) : 0;
          parentQli.MCPU__c = parentQli.Units__c != 0 ? (parentQli.MCPU__c / parentQli.Units__c) : 0;
          parentQli.AP__c = parentQli.Units__c != 0 ? (parentQli.AP__c / parentQli.Units__c) : 0;
          parentQli.motoagents__c = parentQli.Units__c != 0 ? (parentQli.motoagents__c / parentQli.Units__c) : 0;
     }
     
     public static void resetFields(QuoteLineItem parentQli){
          parentQli.Units__c = 0;
          parentQli.MinimumCommitQuantity__c = 0;
          parentQli.InvoicePrice__c = 0;
          parentQli.SDF__c = 0;
          parentQli.COOP__c = 0;
          parentQli.MDF__c = 0;
          parentQli.iMDF__c = 0;
          parentQli.SVM__c = 0;
          parentQli.IPP__c = 0;
          parentQli.National_Retail__c = 0;
          parentQli.CSAT__c = 0;
          parentQli.QP__c = 0;
          parentQli.TC__c = 0;
          parentQli.ILW__c = 0;
          parentQli.TDF__c = 0;
          parentQli.Fees__c = 0;
          parentQli.Negotiation_Buffer__c = 0;
          parentQli.MCPU__c = 0;
          parentQli.AP__c = 0;
          parentQli.motoagents__c = 0;
     }


}