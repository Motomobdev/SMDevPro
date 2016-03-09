@isTest
public class Z_TestDataSetup {

        public static final Date DEFAULT_EFFECTIVE_START_DATE = Date.today(); 
        public static final Date DEFAULT_EFFECTIVE_END_DATE = Date.today().addYears(1);
        public static final String DEFAULT_CURRENCY = 'USD';

        public static final String MODEL_F = 'Flat Fee Pricing';
        public static final String MODEL_P = 'Per Unit Pricing';
        public static final String MODEL_V = 'Volume Pricing';
        public static final String MODEL_T = 'Tiered Pricing';
        public static final String MODEL_O = 'Overage Pricing';
        public static final String MODEL_TO = 'Tiered with Overage Pricing';
        public static final String MODEL_FA = 'Discount-Fixed Amount';
        public static final String MODEL_FP = 'Discount-Percentage';

        private static ID preparedProductID {
                get;
                set;
        }

        private static List < String > rateplannames = new List < String > {
                'Plan for Flat Fee charges',
                'Plan for Per Unit charges',
                'Plan for Volume charges',
                'Plan for Overage charges',
                'Plan for Tiered charges',
                'Plan for Discount-Fixed Amount charges'
        };

        private static Map<String, List<List<String>>> PLAN_CHARGE_MAPPING
                        = new  Map<String, List<List<String>>> {
                'Plan for Flat Fee charges' => new List < List < String >> {
                        new List < String > {
                                'Flat Fee Pricing', 'One-Time'
                        }, new List < String > {
                                'Flat Fee Pricing', 'Recurring'
                        }, new List < String > {
                                'Flat Fee Pricing', 'Usage'
                        }
                }, 'Plan for Per Unit charges' => new List < List < String >> {
                        new List < String > {
                                'Per Unit Pricing', 'One-Time'
                        }, new List < String > {
                                'Per Unit Pricing', 'Recurring'
                        }, new List < String > {
                                'Per Unit Pricing', 'Usage'
                        }
                }, 'Plan for Volume charges' => new List < List < String >> {
                        new List < String > {
                                'Volume Pricing', 'One-Time'
                        }, new List < String > {
                                'Volume Pricing', 'Recurring'
                        }, new List < String > {
                                'Volume Pricing', 'Usage'
                        }
                }, 'Plan for Overage charges' => new List < List < String >> {
                        new List < String > {
                                'Overage Pricing', 'Usage'
                        }, new List < String > {
                                'Tiered with Overage Pricing', 'Usage'
                        }
                }, 'Plan for Tiered charges' => new List < List < String >> {
                        new List < String > {
                                'Tiered Pricing', 'One-Time'
                        }, new List < String > {
                                'Tiered Pricing', 'Recurring'
                        }, new List < String > {
                                'Tiered Pricing', 'Usage'
                        }
                }, 'Plan for Discount-Fixed Amount charges' => new List < List < String >> {
                        new List < String > {
                                'Discount-Fixed Amount', 'Recurring'
                        }, new List < String > {
                                'Per Unit Pricing', 'One-Time'
                        }, new List < String > {
                                'Per Unit Pricing', 'Recurring'
                        }
                }, 'Plan for Discount-Percentage charges' => new List < List < String >> {
                        new List < String > {
                                'Discount-Percentage', 'Recurring'
                        }, new List < String > {
                                'Per Unit Pricing', 'One-Time'
                        }, new List < String > {
                                'Per Unit Pricing', 'Recurring'
                        }
                }
        };

        private static Map < String, List < Decimal >> TIER_MAPPING = new Map < String, List < Decimal >> {
                'One-Time_Flat Fee Pricing' => new List < Decimal > {
                        1000
                }, 'One-Time_Per Unit Pricing' => new List < Decimal > {
                        1000
                }, 'One-Time_Volume Pricing' => new List < Decimal > {
                        0, 0, 500, 0, 800, 1, 1000, 0
                }, 'One-Time_Tiered Pricing' => new List < Decimal > {
                        500, 0, 400, 1, 200, 0
                }, 'Recurring_Flat Fee Pricing' => new List < Decimal > {
                        1500
                }, 'Recurring_Per Unit Pricing' => new List < Decimal > {
                        1000
                }, 'Recurring_Volume Pricing' => new List < Decimal > {
                        0, 1, 800, 1, 1200, 0, 1500, 1
                }, 'Recurring_Tiered Pricing' => new List < Decimal > {
                        800, 0, 400, 0, 300, 1
                }, 'Usage_Flat Fee Pricing' => new List < Decimal > {
                        0
                }, 'Usage_Per Unit Pricing' => new List < Decimal > {
                        0
                }, 'Usage_Volume Pricing' => new List < Decimal > {
                }, 'Usage_Tiered Pricing' => new List < Decimal > {
                }, 'Usage_Overage Pricing' => new List < Decimal > {
                        0
                }, 'Usage_Tiered with Overage Pricing' => new List < Decimal > {
                        8, 100, 200
                }, 'Recurring_Discount-Fixed Amount' => new List < Decimal > {
                        598, 400, 500
                }, 'Recurring_Discount-Percentage' => new List < Decimal > {
                        7
                }, '_Flat Fee Pricing' => new List < Decimal > {
                        0
                }, '_Per Unit Pricing' => new List < Decimal > {
                        0
                }, '_Volume Pricing' => new List < Decimal > {
                        0, 0, 0, 0, 10, 0, 0, 1, 0, 1, 10, 1, 0, 0, 0, 0, 10, 0
                }, '_Tiered Pricing' => new List < Decimal > {
                        0, 1, 0, 0, 10, 0, 0, 1, 0, 1, 10, 1, 0, 0, 0, 0, 10, 0
                }
        };


        @isTest
        public static zqu__ZProduct__c prepareProductCatalog() {
                List < zqu__ZProduct__c > listOFzprod = new List < zqu__ZProduct__c > ();
                zqu__ZProduct__c zprod = null;
                try {
                        // Following cases will return list size as 0 and thus new product catalog will be created.
                        // 1. null == preparedProductID 
                        // 2. preparedProductID is expired 
                        listOFzprod = [
                                SELECT
                                        name,
                                        zqu__effectivestartdate__c,
                                        zqu__effectiveenddate__c,
                                        zqu__sku__c,
                                        zqu__zuoraid__c,
                                        zqu__deleted__c
                                FROM
                                        zqu__ZProduct__c
                                WHERE
                                        id = : preparedProductID
                        ];
                } catch (Exception e) {
                        System.assert(false, 'Exception occured while querying ZProduct__c. '
                                        +'Exception Details: ' + e.getMessage());
                }
                if (listOFzprod.size() == 0) {
                        //generate ProductCatalog in Salesforce
                        zprod = new zqu__ZProduct__c();
                        zprod.Name = 'CC Testing';
                        zprod.zqu__EffectiveStartDate__c = DEFAULT_EFFECTIVE_START_DATE;
                        zprod.zqu__EffectiveEndDate__c = DEFAULT_EFFECTIVE_END_DATE;
                        zprod.zqu__SKU__c = 'testingsku0001';
                        zprod.zqu__ZuoraId__c = 'zuoraid0000000001';
                        zprod.zqu__Deleted__c = false;
                        try {
                                insert zprod;
                        } catch (Exception e) {
                                System.assert(false, 'ZQTestDataSetup.prepareProductCatalog: '
                                                +'Exception occured while inserting ZProduct__c. Exception Details: '
                                                + e.getMessage());
                        }
                        System.assert(null != zprod.Id, 'Product record preparation failed '
                                        +'when prepare for testing product catalog.');

                        preparedProductID = zprod.Id;

                        List < zqu__ProductRatePlan__c > p_rateplans = new List < zqu__ProductRatePlan__c > ();
                        Integer rpzuoraid = 1;
                        for (String rpname: rateplannames) {
                                zqu__ProductRatePlan__c p_rateplan = new zqu__ProductRatePlan__c();
                                p_rateplan.Name = rpname;
                                p_rateplan.zqu__EffectiveStartDate__c = DEFAULT_EFFECTIVE_START_DATE;
                                p_rateplan.zqu__EffectiveEndDate__c = DEFAULT_EFFECTIVE_END_DATE;
                                p_rateplan.zqu__ZProduct__r = zprod;
                                p_rateplan.zqu__ZProduct__c = zprod.Id;
                                p_rateplan.zqu__ZuoraId__c = String.valueOf(rpzuoraid);
                                p_rateplan.zqu__Deleted__c = false;
                                p_rateplans.add(p_rateplan);
                                rpzuoraid++;
                        }
                        
                        try {
                                insert p_rateplans;
                        } catch (Exception e) {
                                System.assert(false, 'ZQTestDataSetup.prepareProductCatalog: '
                                                +'Exception occured while inserting ProductRatePlan__c '
                                                + 'records. Exception Details: ' + e.getMessage());
                        }
                        
                        System.assert(p_rateplans.size() > 0, 'Product Rateplan records '
                                        +'prepare failed when prepare for testing product catalog.');
                                        
                        List < zqu__ProductRatePlanCharge__c > p_all_charges =
                                        new List < zqu__ProductRatePlanCharge__c > ();
                        for (zqu__ProductRatePlan__c p_rateplan: p_rateplans) {
                                List < zqu__ProductRatePlanCharge__c > rp_charges = getProductRatePlanCharges(p_rateplan);
                                p_all_charges.addAll(rp_charges);
                        }
                        try {
                                insert p_all_charges;
                        } catch (Exception e) {
                                System.assert(false, 'ZQTestDataSetup.prepareProductCatalog: '
                                                + 'Exception occured while inserting ProductRatePlanCharge__c '
                                                + 'records. Exception Details: ' + e.getMessage());
                        }
                        System.assert(p_all_charges.size() > 0, 'Product Rateplan charge '
                                        +'records prepare failed when prepare for testing product catalog.');
                                        
                        List < zqu__ProductRatePlanChargeTier__c > p_all_tiers =
                                        new List < zqu__ProductRatePlanChargeTier__c > ();
                        for (zqu__ProductRatePlanCharge__c charge: p_all_charges) {
                                List < zqu__ProductRatePlanChargeTier__c > p_chargetiers =
                                                getProductRatePlanChargeTiers(charge);
                                p_all_tiers.addAll(p_chargetiers);
                        }
                        try {
                                insert p_all_tiers;
                        } catch (Exception e) {
                                System.assert(false, 'ZQTestDataSetup.prepareProductCatalog: '
                                                + 'Exception occured while inserting ProductRatePlanChargeTier__c '
                                                + 'records. Exception Details: ' + e.getMessage());
                        }
                        System.assert(p_all_tiers.size() > 0, 'Product Rateplan charge tier '
                                        +'records prepare failed when prepare for testing product catalog.');
                }
                return zprod;
        }

        private static List < zqu__ProductRatePlanCharge__c > getProductRatePlanCharges(zqu__ProductRatePlan__c rp) {
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c', 'Prepaid__c'};
                
                List < List < String >> chargedefines = PLAN_CHARGE_MAPPING.get(rp.Name);
                List < zqu__ProductRatePlanCharge__c > charges = new List < zqu__ProductRatePlanCharge__c > ();
                Integer zuoraid = Integer.valueOf(rp.zqu__ZuoraId__c) * 1000;
                for (List < String > chargedefine: chargedefines) {
                        zqu__ProductRatePlanCharge__c p_charge = new zqu__ProductRatePlanCharge__c();
                        p_charge.Name = chargedefine.get(1) + ' ' + chargedefine.get(0);
                        p_charge.zqu__Model__c = chargedefine.get(0);
                        p_charge.zqu__Type__c = chargedefine.get(1);
                        p_charge.zqu__UOM__c = 'UOM tesing';
                        p_charge.zqu__DefaultQuantity__c = 1;
                        p_charge.zqu__MinQuantity__c = 0;
                        p_charge.zqu__MaxQuantity__c = 500;
                        p_charge.zqu__RecurringPeriod__c = 'Monthly';
                        p_charge.zqu__ZuoraId__c = String.valueOf(zuoraid);
                        p_charge.zqu__ProductRatePlan__c = rp.Id;
                        p_charge.zqu__ProductRatePlan__r = rp;
                        p_charge.zqu__Deleted__c = false;
                        if (p_charge.zqu__Model__c == 'Discount-Fixed Amount' || p_charge.zqu__Model__c == 'Discount-Percentage') {
                                p_charge.zqu__Discount_Apply_Type__c = 3;
                                p_charge.zqu__Upto_How_Many_Periods__c = 5;
                                p_charge.zqu__Discount_Level__c = 'RatePlan';
                        }
                        zuoraid++;
                        charges.add(p_charge);
                }
                return charges;
        }

        private static List < zqu__ProductRatePlanChargeTier__c > getProductRatePlanChargeTiers(zqu__ProductRatePlanCharge__c charge) {
                List < Decimal > tierprices = TIER_MAPPING.get(charge.zqu__Type__c + '_' + charge.zqu__Model__c);
                List < zqu__ProductRatePlanChargeTier__c > p_tiers = new List < zqu__ProductRatePlanChargeTier__c > ();
                Integer tiernumber = 0;
                if (MODEL_V.equals(charge.zqu__Model__c) || MODEL_T.equals(charge.zqu__Model__c)) {
                        for (Integer i = 0; i < tierprices.size(); i++) {
                                zqu__ProductRatePlanChargeTier__c p_tier = new zqu__ProductRatePlanChargeTier__c();
                                p_tier.zqu__Price__c = tierprices[i];
                                if (0 == tierprices[i + 1]) {
                                        p_tier.zqu__PriceFormat__c = 'Flat Fee';
                                } else {
                                        p_tier.zqu__PriceFormat__c = 'Per Unit';
                                }
                                p_tier.zqu__Tier__c = tiernumber + 1;
                                p_tier.zqu__Currency__c = DEFAULT_CURRENCY;
                                if (0 == tiernumber) {
                                        p_tier.zqu__StartingUnit__c = 0;
                                } else {
                                        p_tier.zqu__StartingUnit__c = 100 * tiernumber + 1;
                                }
                                if (tiernumber <= tierprices.size() - 1) {
                                        p_tier.zqu__EndingUnit__c = 100 * (tiernumber + 1);
                                }
                                p_tier.zqu__ProductRatePlanCharge__r = charge;
                                p_tier.zqu__ProductRatePlanCharge__c = charge.Id;
                                p_tier.zqu__Deleted__c = false;
                                p_tiers.add(p_tier);
                                i++;
                                tiernumber++;
                        }
                } else {
                        for (Decimal tierprice: tierprices) {
                                zqu__ProductRatePlanChargeTier__c p_tier = new zqu__ProductRatePlanChargeTier__c();
                                p_tier.zqu__Price__c = tierprice;
                                p_tier.zqu__Tier__c = tiernumber + 1;
                                p_tier.zqu__Currency__c = DEFAULT_CURRENCY;
                                p_tier.zqu__StartingUnit__c = 100 * tiernumber + 1;
                                if (tiernumber <= tierprices.size() - 1) {
                                        p_tier.zqu__EndingUnit__c = 100 * (tiernumber + 1);
                                }
                                p_tier.zqu__ProductRatePlanCharge__r = charge;
                                p_tier.zqu__ProductRatePlanCharge__c = charge.Id;
                                p_tier.zqu__Deleted__c = false;
                                p_tiers.add(p_tier);
                        }
                }
                return p_tiers;
        }
}