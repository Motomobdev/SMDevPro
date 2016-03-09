// jescamilla@levementum.com 12/213/14 Description: I had to extract this class in order to be able to pass parameters to components.
    public class lineItemCol{

        public lineItemCol(){

        }        

        public string name {get;set;}
        public QuoteLineItem cwvLineItem {get;set;}
        public QuoteLineItem porLineItem {get;set;}
        public QuoteLineItem othLineItem {get;set;}
        public String commentField {get;set;}
        public String coopCommentField {get;set;}
        public String negotiationBufferCommentField{get;set;}
        public String feesCommentField {get;set;}
        public String tdfCommentField {get;set;}
        public String ilwCommentField {get;set;}
        public String tcCommentField {get;set;}
        public String qpCommentField {get;set;}
        public String csatCommentField {get;set;}
        public String nationalRetailCommentField {get;set;}
        public String ippCommentField {get;set;}
        public String svmCommentField {get;set;}
        public String imdfCommentField {get;set;}
        public String mdfCommentField {get;set;}
        public String discountCommentField {get;set;}
        public String nsadCommentField {get;set;}
        public String mcpuCommentField {get;set;}
        public String invoiceCommentField {get;set;}
        public String sdfCommentField {get;set;}
        
        public String minimumCommitOpCommentField{get; set;}
        public String nsbdOpCommentField {get;set;}
        public String sdfOpCommentField {get; set;}
        public String coopOpCommentField {get;set;}
        public String imdfOpCommentField {get;set;}
        public String mdfOpCommentField {get;set;}
        public String svmOpCommentField {get;set;}
        public String ippOpCommentField {get;set;}
        public String nationalRetailOpCommentField {get;set;}
        public String csatOpCommentField {get;set;}
        public String qpOpCommentField {get;set;}      
        public String negotiationBufferOpCommentField{get;set;}
        public String feesOpCommentField {get;set;}
        public String tdfOpCommentField {get;set;}
        public String ilwOpCommentField {get;set;}
        public String tcOpCommentField {get;set;}
        
        public string quarter {get;set;}
        public String  year {get;set;}
        public Integer quarterNumber {get;set;}
        public Integer yearNumber {get;set;}
        public Integer sortingExpresion {get;set;}
        public Boolean toDelete {get;set;} // jescamilla@levementum.com 10/31/14 Description: Task 44 Enable the deletion of products from the Deal View.

    }