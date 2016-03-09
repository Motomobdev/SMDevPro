public with sharing class CustomLookupController 
{
	public Product2 product {get; set;} // new account to create
	public List<Product2> results {get; set;} // search results
	public string searchString {get; set;} // search keyword
	public String quoteId {get; set;}
	
	public CustomLookupController() 
	{
		try
		{
		    product = new Product2();
		    // get the current search string
		    if(!Test.isRunningTest()){
			    quoteId = System.currentPageReference().getParameters().get('quoteId');
			    searchString = System.currentPageReference().getParameters().get('lksrch');
		    }
		    runSearch();  
		}
		catch(Exception ex)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'An error has ocurred. Please contact ypur administrator.'));
			system.debug(ex.getMessage());
		}
	}
	
	// performs the keyword search
	public PageReference search() 
	{
		results = searchProduct();
	    return null;
	}
	
	public PageReference clearSearch() 
	{
		searchString = '';
		results = searchProduct();
	    return null;
	}
	public List<Product2> searchProduct()
	{
		List<Product2> associatedProducts = new List<Product2>();
		String errorStr = '';
		try
		{
			/*soql = 'select id, name from Product2';
		    if(searchString != '' && searchString != null)
		      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
		    soql = soql + ' limit 25';*/
		    
		    Quote quote = [SELECT Pricebook2Id, id 
			               FROM Quote
			               WHERE id =: quoteId limit 1];
			List<Pricebook2> pb = new List<Pricebook2>();
			if(quote != null)
			{
				pb = [SELECT IsActive, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description, IsStandard, LastModifiedById, LastModifiedDate, Id, Name, SystemModstamp 
				      FROM Pricebook2 
				      WHERE isStandard=true and id=: quote.Pricebook2Id and isActive = true];
			}
			
			List<PricebookEntry> pbe = new List<PricebookEntry>(); 
			if(pb != null && pb.size() > 0)
			{
				pbe = [SELECT PriceBookEntry.Product2.Name, IsActive, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastModifiedById, LastModifiedDate, UnitPrice, Id, Pricebook2Id, ProductCode, Product2Id, Name, SystemModstamp, UseStandardPrice 
				       FROM PricebookEntry 
				       WHERE Pricebook2Id =: pb.get(0).id and isActive = true 
				       AND PriceBookEntry.Product2.Name LIKE :searchString + '%'
				       ORDER BY PriceBookEntry.Product2.Name];
			}
			
			for(PricebookEntry pe: pbe)
			{
				if(pe.CurrencyIsoCode == null)
				{
					errorStr += pe.Product2.Name + '<BR/>';
				}
				else
				{
					associatedProducts.add(pe.Product2);
				}
			}
		}
		catch(Exception ex)
		{
			system.debug(ex.getMessage());
		}
		return associatedProducts; 
	}
	
	// prepare the query and issue the search command
	private void runSearch() 
	{
	    // TODO prepare query string for complex serarches & prevent injections
	    results = performSearch(searchString);               
	} 
	
	// run the search and return the records found. 
	private List<Product2> performSearch(string searchString) 
	{
		String errorStr = '';
		List<Product2> associatedProducts = new List<Product2>();
		try
		{
			Quote quote = [SELECT Pricebook2Id, id 
			               FROM Quote
			               WHERE id =: quoteId limit 1];
			List<Pricebook2> pb = new List<Pricebook2>();
			if(quote != null)
			{
				pb = [SELECT IsActive, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description, IsStandard, LastModifiedById, LastModifiedDate, Id, Name, SystemModstamp 
				      FROM Pricebook2 
				      WHERE isStandard=true and id=: quote.Pricebook2Id and isActive = true];
			}
			
			List<PricebookEntry> pbe = new List<PricebookEntry>(); 
			if(pb != null && pb.size() > 0)
			{
				pbe = [SELECT PriceBookEntry.Product2.Name, IsActive, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastModifiedById, LastModifiedDate, UnitPrice, Id, Pricebook2Id, ProductCode, Product2Id, Name, SystemModstamp, UseStandardPrice 
				       FROM PricebookEntry 
				       WHERE Pricebook2Id =: pb.get(0).id and isActive = true 
				       AND PriceBookEntry.Product2.Name LIKE :searchString + '%'
				       ORDER BY PriceBookEntry.Product2.Name];
			}
			
			for(PricebookEntry pe: pbe)
			{
				if(pe.CurrencyIsoCode == null)
				{
					errorStr += pe.Product2.Name + '<BR/>';
				}
				else
				{
					associatedProducts.add(pe.Product2);
				}
			}
		}
		catch(Exception ex)
		{
			system.debug(ex.getMessage());
		}
		if(errorStr.length() > 1)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No CurrencyISO Code found for th following products: ' + errorStr));
		}		
	    return associatedProducts;
	}
	
	// used by the visualforce page to send the link to the right dom element
	public string getFormTag()
	{
	    return System.currentPageReference().getParameters().get('frm');
	}
	
	// used by the visualforce page to send the link to the right dom element for the text box
	public string getTextBox() 
	{
	    return System.currentPageReference().getParameters().get('txt');
	}
}