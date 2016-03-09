	var CTFZipFiles = [];
	var recentFileNames = [];
	var testpackages = [];
	var createErrorItr = 0;

	// Check for the various File API support.
    if (window.File && window.FileReader && window.FileList && window.Blob) {
      // Great success! All the File APIs are supported.
        console.log('supported');
        
    } else {
      pageErrors.push('The File APIs are not fully supported in this browser.');
      printErrors();
    }
    
    function handleFileSelect(evt) 
    {
        loadWaitingScreen();
        var files = evt.target.files; // FileList object
        //console.log('evt.target.files',files);
        try{
        	readInitFile(files[0]); 
        }
        catch(e){
         	pageErrors.push(e.message);
            printErrors();
        }
    }
    
    function readInitFile(file){      
        console.log('file',file);
       var reader = new FileReader();

        // Closure to capture the file information.
        reader.onload = (function(theFile) {
          return function(e) {
              var splitFile = e.target.result.split(",");
              console.log(file);
              console.log(splitFile);
              if(file.name != undefined && splitFile[0] == 'data:application/zip;base64'){	
                  Start(file.name, splitFile[1]);
              }
              else if(file.name == undefined){
                  Start(recentFileNames.pop(), splitFile[1]);
              }
              else{
                pageErrors.push('Incorrect File Format - File must be a compressed zip file');
            	printErrors();  
			  }
          };
        })(file);
      // Read in the image file as a data URL.
      reader.readAsDataURL(file);
    }
    
    // Function to be called to start unzipping the process
	function Start(filename, data)
	{
		$('#LoadingStatus').text('Unzipping Files ...');
        // Unzip and push zip entries onto list for processing
		CTFZipFiles.push({"Name":filename,"ParentId":submissionID,"Body":data});
        zip = new JSZip(data, {base64:true});
        for(var zipFileName in zip.files){
            if(zipFileName.search('.zip') > -1 ){
                
                if(zipFileName.search('CTS failures') == -1){
                	filesLeftToBeUnZipped.push(zip.files[zipFileName]);
            	}
            }
            else nonZipFiles.push(zip.files[zipFileName]);
        }
        
        //console.log('length: ',filesLeftToBeUnZipped.length);
         if(filesLeftToBeUnZipped.length > 0){
        	var nextFile = filesLeftToBeUnZipped.pop();
            var nextFileblob = new Blob([new Uint8Array(nextFile._data.getContent())]); 
            if(nextFile.name.search('/') > -1) recentFileNames.push(nextFile.name.substring(nextFile.name.lastIndexOf('/')+1,nextFile.name.length));
            else recentFileNames.push(nextFile.name);
            readInitFile(nextFileblob);
		}
        else{
            console.log(CTFZipFiles);
        	collectXMLFiles();
        }
        //console.log(nonZipFiles);
        
	}
    
    function collectXMLFiles(){
        console.log('nonZipFiles length: ',nonZipFiles.length);
        for( var itr = 0; itr < nonZipFiles.length; itr++){
        	if(nonZipFiles[itr].name == undefined || nonZipFiles[itr].name == null) continue;
            if(nonZipFiles[itr].name.search('.xml') > -1){ 
                xmlfiles.push(nonZipFiles[itr]);
                //xmlfiles.push(nonZipFiles[itr].asText());
            }
        }
        console.log('xmlfiles: ',xmlfiles);
        
        for( var itr = 0; itr < xmlfiles.length; itr++){
        	var newAttachment = {};
            newAttachment['ParentId'] = submissionID;
            newAttachment['Body'] = xmlfiles[itr].asText();
            newAttachment['Name'] = xmlfiles[itr].name.replace(/\//g,'_');
            attachmentlist.push(newAttachment);
        	
        }
        
        $('#LoadingStatus').text('Gathering and inserting Files ... ( 1 of '+attachmentlist.length+')' );
        
        //console.log('Attachment list: ',attachmentlist);
        //console.log('CTFZipFiles: ',CTFZipFiles);
        CTSFile['ParentId'] = submissionID; 
        //attachmentlist.push(CTSFile);
        attachmentlist = attachmentlist.concat(CTFZipFiles);
        //console.log('Attachment list: ',attachmentlist);
        //console.log('Body length: ',attachmentlist[GoogleTACounter]['Body'].length);
        if(attachmentlist[GoogleTACounter]['Name'].search('GTS') > -1 && attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1) insertGTS();
        else if(attachmentlist[GoogleTACounter]['Body'].length < 800000)	insertAdjustedAttachment();
        else InsertPartOfAttachment();
    }
    
    function insertAdjustedAttachment(){
        console.log('Entered insertAdjustedAttachment');
        var zip = false;
        if(attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1) zip = true;
        if(!zip){
            var attachmentBody = attachmentlist[GoogleTACounter]['Body'];
            delete attachmentlist[GoogleTACounter]['Body'];
        }
        else{
        	var attachmentBody = attachmentlist[GoogleTACounter]['Body'];
            delete attachmentlist[GoogleTACounter]['Body'];
        }
        //console.log('insertAdjustedAttachment');
        //console.log('file name: ',attachmentlist[GoogleTACounter]['Name']);
        //console.log('Zip in name?: ',attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1);
        //console.log(attachmentBody.length);
        try{
        	GoogleTAController.InsertAttachments(JSON.stringify(attachmentlist[GoogleTACounter]),attachmentBody,zip,InsertAttachmentsCB);
        }
        catch(e){
            console.log(e);
            pageErrors.push(e.message);
            printErrors();
        }
    }
    
    function InsertPartOfAttachment(AttachmentID){
        //console.log('AttachmentID: ',AttachmentID);
        //console.log('index: ',positionIndex,'length: ',attachmentlist[GoogleTACounter]['Body'].length);
        var partOfAttacment = {};
        partOfAttacment['ParentId'] = attachmentlist[GoogleTACounter]['ParentId'];
        partOfAttacment['Name'] = attachmentlist[GoogleTACounter]['Name'];
        partOfAttacment['Body'] = attachmentlist[GoogleTACounter]['Body'].substring(positionIndex,positionIndex + 800000);
        if(AttachmentID != undefined || AttachmentID != '') partOfAttacment['Id'] = AttachmentID;
        positionIndex += 800000;
        
        var zip = attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1;
        //if(zip){
            var attachmentBody = partOfAttacment['Body'];
            delete partOfAttacment['Body'];
        /*}
        else{
            var attachmentBody = atob(partOfAttacment['Body']);
            delete partOfAttacment['Body'];
		}*/
        //console.log('InsertPartOfAttachment');
        //console.log('file name: ',attachmentlist[GoogleTACounter]['Name']);
        //console.log('Zip in name?: ',attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1);
        //console.log(attachmentBody.length);
        try{
        	GoogleTAController.InsertAttachments(JSON.stringify(partOfAttacment),attachmentBody,zip,InsertPartOfAttachmentCB);
        }
        catch(e){
        	console.log(e);
            pageErrors.push(e.message);
            printErrors();
        }
    }
    
    function InsertPartOfAttachmentCB(result,event){
        
            if(event.status){
                var bodyLength = attachmentlist[GoogleTACounter]['Body'].length;
                if(positionIndex + 800000 <= bodyLength){
                    console.log('index: ',positionIndex,'length: ',bodyLength);
                    console.log('Result:',result.replace(/&quot\;/g,"\""));
                    attachmentIds.push(JSON.parse(result.replace(/&quot\;/g,"\"")).Id);
                    InsertPartOfAttachment(JSON.parse(result.replace(/&quot\;/g,"\"")).Id);
                }
                else if(!doneWithFile && positionIndex != bodyLength){
                    // upload last part of file
                    doneWithFile = true;
                    var partOfAttacment = {};
                    partOfAttacment['ParentId'] = attachmentlist[GoogleTACounter]['ParentId'];
                    partOfAttacment['Name'] = attachmentlist[GoogleTACounter]['Name'];
                    partOfAttacment['Id'] = JSON.parse(result.replace(/&quot\;/g,"\"")).Id;
                    var attachmentBody = attachmentlist[GoogleTACounter]['Body'].substring(positionIndex,bodyLength);
                    var zip = attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1;
                    GoogleTAController.InsertAttachments(JSON.stringify(partOfAttacment),attachmentBody,zip,InsertPartOfAttachmentCB);
                    
                }
                else{
                    console.log('Done With File: ',attachmentlist[GoogleTACounter]);
                    positionIndex = 0;
                    doneWithFile = false;
                    loadNextFile();
                }
            }
            else{
                if(event.message.search('String length exceeds maximum: 6000000') > -1){ //pageErrors.push('File size cannot exceed 4.8 MB. Please try another submission.');
                	positionIndex = 0;
            		doneWithFile = false;
                    insertGTS();
                }
                else pageErrors.push(event.message);
                printErrors();
            }
    	
    }
    
    function InsertAttachmentsCB(result,event){
        
        if(event.status){
            console.log('Result:',result.replace(/&quot\;/g,"\""));
            attachmentIds.push(JSON.parse(result.replace(/&quot\;/g,"\"")).Id);
            loadNextFile();
        }
        else{
            $('#loading').addClass('hidden');
        	pageErrors.push(event.message);    
            printErrors();
            //console.log(pageErrors);
        }
    }
    
    function loadNextFile(){
    	if(GoogleTACounter < attachmentlist.length-1){
                console.log('File Number ('+GoogleTACounter+'): ',attachmentlist[GoogleTACounter]);
                GoogleTACounter++;
            	$('#LoadingStatus').text('Gathering and inserting Files ... ( '+(GoogleTACounter+1)+' of '+attachmentlist.length+')' );
            	if(attachmentlist[GoogleTACounter]['Name'].search('GTS') > -1 && attachmentlist[GoogleTACounter]['Name'].search('.zip') > -1) insertGTS();
        		else if(attachmentlist[GoogleTACounter]['Body'].length < 800000)	insertAdjustedAttachment();
        		else InsertPartOfAttachment();
            }
            else{
                
                console.log('Checked: ',$('input[id$="EnteredCTSZipCheckBox"]').attr('checked'),$('input[id$="EnteredCTSVZipCheckBox"]').attr('checked'),$('input[id$="EnteredGTSZipCheckBox"]').attr('checked'));
                if(!$('input[id$="EnteredCTSZipCheckBox"]').attr('checked'))	$('input[id$="EnteredCTSZipCheckBox"]').attr('checked',true);
                else if(!$('input[id$="EnteredCTSVZipCheckBox"]').attr('checked'))	$('input[id$="EnteredCTSVZipCheckBox"]').attr('checked',true);
                else if(!$('input[id$="EnteredGTSZipCheckBox"]').attr('checked'))	$('input[id$="EnteredGTSZipCheckBox"]').attr('checked',true);
                createErrors(0); 
            }
    }
    
	function getTestPackages(attachmentID){
        $('#LoadingStatus').text('Creating Errors from XML Files ... ( '+(createErrorItr+1)+' of '+attachmentIds.length+' )');
        
            GoogleTAController.getTestPackages(attachmentID,function(result,event){
                if(event.status){
                    
                    testpackages = JSON.parse(result.replace(/&quot\;/g,"\""));
                    console.log(testpackages);
                    $('#loadingProgress').attr('value',0);
                    $('#loadingProgress').attr('max',testpackages.length);
                    $('#loadingProgress').removeClass('hidden');
                    //$('#fileNameLoading').text(' ... '+attachmentlist[GoogleTACounter]['Name']);
                    //$('#fileNameLoading').removeClass('hidden');
                    if(testpackages.length > 0) insertErrors(0,'["'+attachmentID+'"]');
                    else createErrors(createErrorItr+1);
                }
                else{
                    console.log(result.replace(/&quot\;/g,"\""));
                    pageErrors.push(event.message);    
            		printErrors();
                }
            });
        
    }

	function insertErrors(itr,attachmentIdString){
        $('#loadingProgress').attr('value',itr);
        console.log('Insert Errors for:',testpackages[itr]);
        
        	GoogleTAController.insertErrors(attachmentIdString,submissionID,testpackages[itr].startIndex,testpackages[itr].endIndex,function(result,event){
                if(event.status){
                    console.log(result.replace(/&quot\;/g,"\"").replace(/&lt\;/g,"\<").replace(/&gt\;/g,"\>"));
                    //console.log(JSON.parse(result.replace(/&quot\;/g,"\"").replace(/&lt\;/g,"\<").replace(/&gt\;/g,"\>")));  
                    if(itr < testpackages.length -1) insertErrors(itr+1,attachmentIdString);
                    else createErrors(createErrorItr+1);
                }
                else{
                    console.log(JSON.parse(result.replace(/&quot\;/g,"\"").replace(/&lt\;/g,"\<").replace(/&gt\;/g,"\>")));    
                	pageErrors.push(event.message);    
            		printErrors();
                }
            });
       
    }       

	

    function createErrors(itr){
        createErrorItr = itr;
        console.log(attachmentIds);
        console.log(attachmentIds.length);
        if(attachmentIds.length > itr ){
        
        	var attachmentString = '["'+attachmentIds[itr]+'"]';
            console.log(attachmentString);
            getTestPackages(attachmentIds[itr]);
        }
        else PageRefresh();
    }
	

	function insertGTS(){
        var attachmentBody = attachmentlist[GoogleTACounter]['Body'];
        console.log(positionIndex,attachmentBody.length);
        if(positionIndex + 500000 < attachmentBody.length){
            attachmentBody = attachmentBody.substring(positionIndex,positionIndex + 500000);
            console.log(attachmentBody.length);
            positionIndex += 500000;
            GoogleTAController.InsertGTS(submissionID.substring(0,15),attachmentlist[GoogleTACounter]['Name'],attachmentBody,false,insertGTSCB,{buffer: true, escape: true, timeout: 120000});
        }
        else if(!doneWithFile){
        	doneWithFile = true;
            console.log(attachmentBody.length);
            GoogleTAController.InsertGTS(submissionID.substring(0,15),attachmentlist[GoogleTACounter]['Name'],attachmentBody.substring(positionIndex),true,insertGTSCB,{buffer: true, escape: true, timeout: 120000});
        }
        else{
        	console.log('Done With GTS File: ',attachmentlist[GoogleTACounter]);
            positionIndex = 0;
            doneWithFile = false;
            loadNextFile();
        }
        
    }

	function insertGTSCB(result,event){
        if(event.status){
        	console.log(result);
			//positionIndex += 500000;
            insertGTS();
        }
        else if(event.message.search('Read timed out') == -1){
            pageErrors.push(event.message);
            console.log(pageErrors);
            printErrors();
        }
        else window.setTimeout(insertGTS,1000);
    }

    function PageRefresh(){
        $('input[type=button]').hide();
    	$('input[id$="PageRefresh"]').click();
    }
    
    function EnterDevice(){
        $('input[type=button]').hide();
        $('input[id$="EnterDevice"]').click();
    }
    
    function printErrors(){
        var errors = '';
        for(var count = 0; count < pageErrors.length; count++) errors += '~;' + pageErrors[count]; 
        $('input[id$="PageErrorMessages"]').val(errors);
        $('input[id$="addErrors"]').click();
    }
    
    function updateFileName(filename){
    	if(enteredCTSZip) $('span[id$="CTSFileName"]').text(filename);
        if(enteredCTSVZip) $('span[id$="CTSVFileName"]').text(filename);
        if(enteredGTSZip) $('span[id$="GTSFileName"]').text(filename);
    }
    
	function getListofFile(body){
    	var fullbody = atob(body);
        var index = 0;
        var segments = [];
        for(var counter = 0; counter < (fullbody.length / 800000) + 1; counter++){
        	if( index > fullbody.length ) break;
        	nextIndex = index + 800000;
            if(nextIndex > fullbody.length) segments.push(fullbody.substring(index));
            else segments.push(fullbody.substring(index,nextIndex));
            index = nextIndex;
        }
        console.log("file segments",segments);
        return segments;
	}

	// deprecated 
    function newSubmission(){
        window.location = '/apex/GoogleTA';
    }
    
    function loadWaitingScreen(){
    	$('#loading').removeClass('hidden');
        $('#loading').addClass('loading');
        $('#loading').css({
            				'height':$(window).height() * .7,
                        	'width':$(window).width() * .7,
                            'top':$(window).height() * .15,
            				'left':$(window).width() * .15
                          });
    }
   