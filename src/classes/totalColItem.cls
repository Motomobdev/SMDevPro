public class totalColItem{
        public decimal nsbd {get;set;}
        public decimal discount {get;set;}
        public decimal visibleSDF {get;set;}
        public decimal coop {get;set;}
        public decimal mdf {get;set;}
        public decimal imdf {get;set;}
        public decimal svm {get;set;}
        public decimal ipp {get;set;}
        public decimal nationalRetail {get;set;}
        public decimal csat {get;set;}
        public decimal qp {get;set;}
        public decimal tc {get;set;}
        public decimal tdf {get;set;}
        public decimal fees {get;set;}
        public decimal negotiationBuffer {get;set;}
        public decimal nsad {get;set;}
        public decimal aspnsad {get;set;}
        public decimal mcpu {get;set;}
        public decimal grossMargin {get;set;}
        public decimal gm {get;set;}
        public decimal aAndP {get;set;}
        public decimal motoagents {get;set;}
        public decimal contributionMargin {get;set;}
        public decimal cm {get;set;}
        public decimal ilw {get;set;}
        public decimal units {get;set;}
        public decimal minCommit {get;set;}
        public decimal sdf {get;set;}
        public decimal cog {get;set;}
        public decimal invoice {get;set;}

        public String nsbd_dis {get;set;}
        public String discount_dis {get;set;}
        public String visibleSDF_dis {get;set;}
        public String coop_dis {get;set;}
        public String mdf_dis {get;set;}
        public String imdf_dis {get;set;}
        public String svm_dis {get;set;}
        public String ipp_dis {get;set;}
        public String nationalRetail_dis {get;set;}
        public String csat_dis {get;set;}
        public String qp_dis {get;set;}
        public String tc_dis {get;set;}
        public String tdf_dis {get;set;}
        public String fees_dis {get;set;}
        public String negotiationBuffer_dis {get;set;}
        public String nsad_dis {get;set;}
        public String aspnsad_dis {get;set;}
        public String mcpu_dis {get;set;}
        public String grossMargin_dis {get;set;}
        public String aAndP_dis {get;set;}
        public String motoagents_dis {get;set;}
        public String contributionMargin_dis {get;set;}
        public String ilw_dis {get;set;}
        public String units_dis {get;set;}
        public String minCommit_dis {get;set;}
        public String sdf_dis {get;set;}
        public String cog_dis {get;set;}
        public String invoice_dis {get;set;}

        public integer index {get;set;}
        
        //value maker tab
        public String payment_dis {get;set;}
        public String warranty_dis {get;set;}
        public String inbox_dis {get;set;}
        public String freeunitsCost_dis {get;set;}
        public String forecast_dis {get;set;}
        public String other_dis {get;set;}
        public String vmUnitTotal_dis {get;set;}
        public String pocketMargin_dis{get;set;}
        public String vmGMCMImpact_dis{get;set;}
        public String unitPayment_dis {get;set;}
        public String unitWarranty_dis {get;set;}
        public String unitInbox_dis {get;set;}
        public String unitFreeunitsCost_dis {get;set;}
        public String unitForecast_dis {get;set;}
        public String unitOther_dis {get;set;}
        public String unitVmUnitTotal_dis {get;set;}

        public decimal payment {get;set;}
        public decimal warranty {get;set;}
        public decimal inbox {get;set;}
        public decimal freeunitsCost {get;set;}
        public decimal forecast {get;set;}
        public decimal other {get;set;}
        public decimal vmUnitTotal {get;set;}
        public decimal pocketMargin{get;set;}
        public decimal vmGMCMImpact{get;set;}
        public decimal unitPayment {get;set;}
        public decimal unitWarranty {get;set;}
        public decimal unitInbox {get;set;}
        public decimal unitFreeunitsCost {get;set;}
        public decimal unitForecast {get;set;}
        public decimal unitOther {get;set;}
        public decimal unitVmUnitTotal {get;set;}
        
        //cmunoz@levementum.com
        public Decimal totalGMPercentage {get; set;}
        public Decimal totalCMPercentage {get; set;}

        public String calculateCurrencyString(decimal attr){
            String attr_dis = '';
            attr_dis = '$'+(attr/1000000).setScale(3).format()+'M';
            
            return attr_dis;

        }

        public String calculateQuantityString(decimal attr){
            String attr_dis = '';
            //attr_dis = String.valueOf((attr/1000).setScale(1))+'K';
            attr_dis = (attr/1000).setScale(1).format()+'K';
            return attr_dis;

        }

        public void displayValueCal(){
            
            // nsbd_dis calculation
            nsbd_dis = calculateCurrencyString(nsbd);  
            // discount_dis calculation
            discount_dis = calculateCurrencyString(discount);
            // visibleSDF_dis calculation
            visibleSDF_dis = calculateCurrencyString(visibleSDF);
            // coop_dis calculation
            coop_dis = calculateCurrencyString(coop);
            // mdf_dis calculation
            mdf_dis = calculateCurrencyString(mdf);
            // imdf_dis calculation
            imdf_dis = calculateCurrencyString(imdf);
            // svm_dis calculation
            svm_dis = calculateCurrencyString(svm);
            // ipp_dis calculation
            ipp_dis = calculateCurrencyString(ipp);
            // nationalRetail_dis calculation
            nationalRetail_dis = calculateCurrencyString(nationalRetail);
            // csat_dis calculation
            csat_dis = calculateCurrencyString(csat);
            // qp_dis calculation
            qp_dis = calculateCurrencyString(qp);
            // tc_dis calculation
            tc_dis = calculateCurrencyString(tc);
            // tdf_dis calculation
            tdf_dis = calculateCurrencyString(tdf);
            // fees_dis calculation
            fees_dis = calculateCurrencyString(fees);
            // negotiationBuffer_dis calculation
            negotiationBuffer_dis = calculateCurrencyString(negotiationBuffer);
            // nsad_dis calculation
            nsad_dis = calculateCurrencyString(nsad);
            // aspnsad_dis calculation
            aspnsad_dis = calculateCurrencyString(aspnsad);
            // mcpu_dis calculation
            mcpu_dis = calculateCurrencyString(mcpu);
            // grossMargin_dis calculation
            grossMargin_dis = calculateCurrencyString(grossMargin);
            // aAndP_dis calculation
            aAndP_dis = calculateCurrencyString(aAndP);
            // motoagents_dis calculation
            motoagents_dis = calculateCurrencyString(motoagents);
            // contributionMargin_dis calculation
            contributionMargin_dis = calculateCurrencyString(contributionMargin);
            // ilw_dis calculation
            ilw_dis = calculateCurrencyString(ilw);
            // units_dis calculation
            units_dis = calculateQuantityString(units);     
            // minCommit_dis calculation
            minCommit_dis = calculateQuantityString(minCommit);
            // sdf_dis calculation
            sdf_dis = calculateCurrencyString(sdf);
            // cog_dis calculation
            cog_dis = calculateCurrencyString(cog);
            // invoice_dis calculation
            invoice_dis = calculateCurrencyString(invoice);

            //Add for value maker display format calculation, added by qucw@lenovo.com  2015/7/20
            payment_dis = calculateCurrencyString(payment);
            warranty_dis = calculateCurrencyString(warranty);
            inbox_dis = calculateCurrencyString(inbox);
            freeunitsCost_dis = calculateCurrencyString(freeunitsCost);
            forecast_dis = calculateCurrencyString(forecast);
            other_dis = calculateCurrencyString(other);
            vmUnitTotal_dis = calculateCurrencyString(vmUnitTotal);
            pocketMargin_dis = calculateCurrencyString(pocketMargin);
            vmGMCMImpact_dis = calculateCurrencyString(vmGMCMImpact);
            unitPayment_dis = calculateCurrencyString(unitPayment);
            unitWarranty_dis = calculateCurrencyString(unitWarranty);
            unitInbox_dis = calculateCurrencyString(unitInbox);
            unitFreeunitsCost_dis = calculateCurrencyString(unitFreeunitsCost);
            unitForecast_dis = calculateCurrencyString(unitForecast);
            unitOther_dis = calculateCurrencyString(unitOther);
            unitVmUnitTotal_dis = calculateCurrencyString(unitVmUnitTotal);

        }
        
        public totalColItem(){
            nsbd = 0;
            discount = 0;
            visibleSDF = 0;
            coop = 0;
            mdf = 0;
            imdf = 0;
            svm = 0;
            ipp = 0;
            nationalRetail = 0;
            csat = 0;
            qp = 0;
            tc = 0;
            tdf = 0;
            fees = 0;
            negotiationBuffer = 0;
            nsad = 0;
            aspnsad = 0;
            mcpu = 0;
            grossMargin = 0;
            gm = 0;
            aAndP = 0;
            motoagents = 0;
            contributionMargin = 0;
            cm = 0;
            ilw = 0;
            units = 0;
            minCommit = 0;
            sdf = 0;
            cog = 0;
            invoice = 0;
            index = 0;
            totalGMPercentage = 0;
            totalCMPercentage = 0;
            
            //value maker totals for summary tab
            payment =0;
            warranty = 0;
            inbox = 0;
            freeunitsCost = 0;
            forecast = 0;
            other = 0;
            vmUnitTotal = 0;
            pocketMargin=0;
            vmGMCMImpact=0;
            unitPayment =0;
            unitWarranty = 0;
            unitInbox = 0;
            unitFreeunitsCost = 0;
            unitForecast = 0;
            unitOther = 0;
            unitVmUnitTotal = 0;

            nsbd_dis = '0';
            discount_dis = '0';
            visibleSDF_dis = '0';
            coop_dis = '0';
            mdf_dis = '0';
            imdf_dis = '0';
            svm_dis = '0';
            ipp_dis = '0';
            nationalRetail_dis = '0';
            csat_dis = '0';
            qp_dis = '0';
            tc_dis = '0';
            tdf_dis = '0';
            fees_dis = '0';
            negotiationBuffer_dis = '0';
            nsad_dis = '0';
            aspnsad_dis = '0';
            mcpu_dis = '0';
            grossMargin_dis = '0';
            aAndP_dis = '0';
            motoagents_dis = '0';
            contributionMargin_dis = '0';
            ilw_dis = '0';
            units_dis = '0';
            minCommit_dis = '0';
            sdf_dis = '0';
            cog_dis = '0';
            invoice_dis = '0';
        }
    }