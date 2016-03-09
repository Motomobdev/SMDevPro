jq(document).ready(function() {

//contain these four and the functions and the call functions
	trackGridView();
	trackGridSave();
	trackGridExport();
	trackReorderHideColumns();
	
	// tracks the grid view for this session
	function trackGridView() {
		var trackingURL = getAjaxResponderURL() + '?reqType=trackGridView&gname='+getParamValue('gname');
		makeTrackingRequest(trackingURL);
	}
	
	// submits a tracking request when the user clicks the Save button and the form successfully submits
	function trackGridSave() {
		if (readOnlyGrid==false) {
			var gbForm = document.forms[jq('form.gbForm').attr('name')];
			
			jq(gbForm).submit(function() {
				if (btnClick == 'save') {
					
					if (jq.browser.mozilla) {
						// the delay fixes a FF issue where the ajax call doesn't get submitted during the form submit 
						setTimeout(makeGridSaveTrackingRequest, 25);
					} else {
						makeGridSaveTrackingRequest();
					}
				}
			});
		}
	}
	
	// submits a tracking request when the user clicks the Export action
	function trackGridExport() {
		jq('div.gbPage').on('click', 'li.exportLink', function() {
			var trackingURL = getAjaxResponderURL() + '?reqType=trackGridExport&gname='+getParamValue('gname');
			makeTrackingRequest(trackingURL);
		});
	}

	// submits a tracking request when the user clicks the Reorder/Hide Columns action
	function trackReorderHideColumns() {
		jq('div.gbPage').on('click', 'li.reorderColsLink', function() {
			var trackingURL = getAjaxResponderURL() + '?reqType=trackReorderColumns&gname='+getParamValue('gname');
			makeTrackingRequest(trackingURL);
		});
	}
	
	function makeTrackingRequest(trackingURL) {
		jq.ajax({
			url: trackingURL,
			dataType: 'jsonp',
			jsonp: 'callback',
			jsonpCallback: 'handleJsonpCallback'
		});
	}
	
	function makeGridSaveTrackingRequest() {
		var trackingURL = getAjaxResponderURL() + '?reqType=trackGridSave&gname='+getParamValue('gname')+'&fieldNames='+JSON.stringify(getModifiedFields());
		makeTrackingRequest(trackingURL);
	}
	
	// returns an object mapping of Object API Name to an array of Field API Names, only for modified fields
	function getModifiedFields() {
		var modifiedFields = {},
			tempObjectToFields = {};
		
		for (var rowId in modData) {
			var rowData = modData[rowId],
				fullyQualifiedObjectName = rowData['nm'],
				gridInfo = (getParentObjectName() == fullyQualifiedObjectName ? getParentGridInfo() : getChildGridInfo(fullyQualifiedObjectName));
		
			for (var key in modData[rowId]) {
				if (isFieldCell(key)) {
					
					var metaCol = gridInfo.getMetaColByFieldId(key),
						fieldName = metaCol.fieldName;
					
					if (!tempObjectToFields[fullyQualifiedObjectName]) {
						tempObjectToFields[fullyQualifiedObjectName] = {};
						modifiedFields[fullyQualifiedObjectName] = [];
					}
					
					if (!tempObjectToFields[fullyQualifiedObjectName][fieldName]) {
						tempObjectToFields[fullyQualifiedObjectName][fieldName] = true;
						modifiedFields[fullyQualifiedObjectName].push(fieldName);
						
					} else {
						// this field has already been added, skip it to avoid dupes
					}
				}
			}
		}
		return modifiedFields;
	}
		        
	function getAjaxResponderURL() {
		var currentLocation = window.location.href,
			// replace the namespace with 'c', the namespace of custom vf pages
			ajaxURL = currentLocation.replace('gblite.','c.').replace('gblitesandbox.', 'c.');
		
		// changed from ajaxURL.indexOf('Grid?') so that tracking still works on embedded grids that don't have the right case in the URL for "grid"
		ajaxURL = ajaxURL.substring(0, ajaxURL.toLowerCase().indexOf('grid?'))
					+ 'GridAjaxResponder';
		
		return ajaxURL;
	}
	
	function getParamValue(paramName) {
		var urlParams = window.location.search,
			paramValue = '';
		
		if (urlParams) {
			var paramArray = urlParams.split('&');
			
			jq.each(paramArray, function(i, item) {
				if (item.match(paramName + '=')) {
					paramValue = item.substring(item.indexOf('=') + 1);		
					return false;
				}
			})
		};
		return paramValue;
	}
});

// public function called by the GridAjaxResponder VF
function handleJsonpCallback(data) {
	// no op
}