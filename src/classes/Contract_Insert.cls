public with sharing class Contract_Insert {
	public static void beforeInsert(List<Contract> newContracts){
		ContractMethods.setDefaultFields(newContracts);
	}
	
	public static void afterInsert(List<Contract> newContracts){
		AccountMethods.collectContractInformationIntoTextFieldForLRBSlides(newContracts);
		
		ContractMethods.fillMicrogenContractNumber(newContracts);
	}
}