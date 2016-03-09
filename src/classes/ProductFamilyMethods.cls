public with sharing class ProductFamilyMethods {
	public static void relateDeviceToProductFamily(List<Device__c> newList, List<Device__c> oldList){
		Map<String, Product_Family__c> productFamilyNameMap = new Map<String, Product_Family__c>();
		Map<String, Product_Family_Device__c> existingProductFamilyDevices = new Map<String, Product_Family_Device__c>();
		List<Product_Family_Device__c> pfdToInsert = new List<Product_Family_Device__c>();
		
		Map<String, Product_Family__c> pfToInsert = new Map<String, Product_Family__c>();
		List<Device__c> devicesWhoNeedNewProductFamiliesToBeInserted = new List<Device__c>();
		
		List<Product_Family_Device__c> pfdToDelete = new List<Product_Family_Device__c>();
		
		Boolean searched = false;
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Product_Family__c != oldList[i].Product_Family__c){
				if(productFamilyNameMap.isEmpty()){
					for(Product_Family__c pf : [SELECT Id, Name FROM Product_Family__c]){
						productFamilyNameMap.put(pf.Name, pf);
					}
				}
			
				if(existingProductFamilyDevices.isEmpty() && searched == false){
					searched = true;
					for(Product_Family_Device__c pfd : [SELECT Id, Device__c, Product_Family__c, Product_Family__r.Name FROM Product_Family_Device__c WHERE Device__c IN : newList]){
						existingProductFamilyDevices.put(pfd.Device__c + '' + pfd.Product_Family__r.Name, pfd);
					}
				}

				
				if((oldList[i].Product_Family__c == null || oldList[i].Product_Family__c == '') && (newList[i].Product_Family__c != null || newList[i].Product_Family__c != '')){
					//add new productfamilydevice
					if(!existingProductFamilyDevices.containsKey(newList[i].Id + '' + newList[i].Product_Family__c)){
						if(productFamilyNameMap.containsKey(newList[i].Product_Family__c)){
							system.debug('1');
							pfdToInsert.add(new Product_Family_Device__c(Device__c = newList[i].Id, Product_Family__c = productFamilyNameMap.get(newList[i].Product_Family__c).Id));
						} else {
							system.debug('2');
							devicesWhoNeedNewProductFamiliesToBeInserted.add(newList[i]);
							if(!pfToInsert.containsKey(newList[i].Product_Family__c)) { pfToInsert.put(newList[i].Product_Family__c, new Product_Family__c(Name=newList[i].Product_Family__c)); }
						}
					}
				} else if((oldList[i].Product_Family__c != null || oldList[i].Product_Family__c != '') && (newList[i].Product_Family__c == null || newList[i].Product_Family__c == '')){
					//remove existing productfamilydevice
					if(existingProductFamilyDevices.containsKey(newList[i].Id + '' + oldList[i].Product_Family__c)){
						pfdToDelete.add(existingProductFamilyDevices.get(newList[i].Id + '' + oldList[i].Product_Family__c));
					}					
				} else if((oldList[i].Product_Family__c != null || oldList[i].Product_Family__c != '') && (newList[i].Product_Family__c != null || newList[i].Product_Family__c != '')){
					//remove existing productfamilydevice
					//add new productfamilydevice
					if(existingProductFamilyDevices.containsKey(newList[i].Id + '' + oldList[i].Product_Family__c)){
						pfdToDelete.add(existingProductFamilyDevices.get(newList[i].Id + '' + oldList[i].Product_Family__c));
					}
					
					if(!existingProductFamilyDevices.containsKey(newList[i].Id + '' + newList[i].Product_Family__c)){
						if(productFamilyNameMap.containsKey(newList[i].Product_Family__c) && !existingProductFamilyDevices.containsKey(newList[i].Id + '' + newList[i].Product_Family__c)){
							pfdToInsert.add(new Product_Family_Device__c(Device__c = newList[i].Id, Product_Family__c = productFamilyNameMap.get(newList[i].Product_Family__c).Id));
						} else {
							devicesWhoNeedNewProductFamiliesToBeInserted.add(newList[i]);
							if(!pfToInsert.containsKey(newList[i].Product_Family__c)) { pfToInsert.put(newList[i].Product_Family__c, new Product_Family__c(Name=newList[i].Product_Family__c)); }
						}
					}
				}
			}
		}
		
		if(!devicesWhoNeedNewProductFamiliesToBeInserted.isEmpty()){
			system.debug('3');
			insert pfToInsert.values();
			Map<String, Product_Family__c> newProductFamilyNameMap = new Map<String, Product_Family__c>();
			for(Product_Family__c pf : pfToInsert.values()){
				newProductFamilyNameMap.put(pf.Name, pf);
			}
			for(Device__c d : devicesWhoNeedNewProductFamiliesToBeInserted){
				pfdToInsert.add(new Product_Family_Device__c(Device__c = d.Id, Product_Family__c = newProductFamilyNameMap.get(d.Product_Family__c).Id));
			}
		}	
		
		if(!pfdToDelete.isEmpty()){	delete pfdToDelete;	}
		
		if(!pfdToInsert.isEmpty()){	insert pfdToInsert;	}

	}
	
	private static testmethod void relateDeviceToProductFamilyTest(){
		Device__c d = new Device__c(Name = 'd');
		insert d;
		Device__c d2 = new Device__c(Name = 'd2');
		insert d2;
		
		Product_Family__c existingpf = new Product_Family__c(Name='existingpf');
		insert existingpf;
		
		Test.startTest();
			d.Product_Family__c = 'existingpf';
			d2.Product_Family__c = 'notexistingpf';
			update new List<Device__c>{d, d2};
			
			d.Product_Family__c = null;
			update d;
			
			
			d2.Product_Family__c = 'existingpf';
			update d2;
			
			d2.Product_Family__c = 'notexistingpf2';
			update d2;
		Test.stopTest();			
	}
}