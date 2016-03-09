/*
*************************************************************************************************
Description:
This  Class is controller for page Cd Master Data Maintenance

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
Public with sharing class CD_Master{


public ID id{get;set;}
// This is the original code
Public pagereference deletes(){
id= Apexpages.currentPage().getParameters().get('one');



if(typea=='Category'){
List<CD_category__c> temp = new list<cd_category__c>();
cd_category__c a = new cd_category__c();
a.id=id;
temp.add(a);
delete temp;}

if(typea=='Sub Category1'){

List<CD_Subcategory1__c> temp = new list<CD_Subcategory1__c>();
CD_Subcategory1__c a = new CD_Subcategory1__c();
a.id=id;
temp.add(a);
delete temp;


}


if(typea=='Sub Category2'){

List<CD_Subcategory2__c> temp = new list<CD_Subcategory2__c>();
CD_Subcategory2__c a = new CD_Subcategory2__c();
a.id=id;
temp.add(a);
delete temp;


}



if(typea=='Sub Category3'){

List<CD_Subcategory3__c> temp = new list<CD_Subcategory3__c>();
CD_Subcategory3__c a = new CD_Subcategory3__c();
a.id=id;
temp.add(a);
delete temp;


}



if(typea=='GCL'){

List<cd_gcl__c> temp = new list<cd_gcl__c>();
cd_gcl__c a = new cd_gcl__c();
a.id=id;
temp.add(a);
delete temp;


}


if(typea=='Category Manager'){

List<CD_Category_Managers__c> temp = new list<CD_Category_Managers__c>();
CD_Category_Managers__c a = new CD_Category_Managers__c();
a.id=id;
temp.add(a);
delete temp;


}
if(typea=='GMT category'){

List<CD_GMT_Category__c> temp = new list<CD_GMT_Category__c>();
CD_GMT_Category__c a = new CD_GMT_Category__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='GMT Subcategory1'){

List<CD_GMT_Subcategory_1__c> temp = new list<CD_GMT_Subcategory_1__c>();
CD_GMT_Subcategory_1__c a = new CD_GMT_Subcategory_1__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='GMT Subcategory2'){

List<CD_GMT_Subcategory_2__c> temp = new list<CD_GMT_Subcategory_2__c>();
CD_GMT_Subcategory_2__c a = new CD_GMT_Subcategory_2__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='GMT Subcategory3'){

List<CD_GMT_Subcategory_3__c> temp = new list<CD_GMT_Subcategory_3__c>();
CD_GMT_Subcategory_3__c a = new CD_GMT_Subcategory_3__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='Organization'){

List<CD_Organizations__c> temp = new list<CD_Organizations__c>();
CD_Organizations__c a = new CD_Organizations__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='Cost Category'){

List<CD_Cost_Category__c> temp = new list<CD_Cost_Category__c>();
CD_Cost_Category__c a = new CD_Cost_Category__c();
a.id=id;
temp.add(a);
delete temp;
}
if(typea=='Market'){

List<CD_Market_Name__c>  temp = new List<CD_Market_Name__c>();
CD_Market_Name__c a = new CD_Market_Name__c();
a.id=id;
temp.add(a);
delete temp;
}

if(typea=='Segment'){

List<CD_Segment__c>  temp = new List<CD_Segment__c>();
CD_Segment__c a = new CD_Segment__c();
a.id=id;
temp.add(a);
delete temp;
}

data();
return null;

//pagereference pdf = new pagereference('https://mobility--mduat--c.cs7.visual.force.com/apex/CD_MasterData');
//return pdf;
}
Public boolean Errormsg{get;set;}
public list<string> tempstringlist= new list<string>();
public  list<string> gettempstringlist(){return  tempstringlist;}
public string typea {get;set;}
Public string newvalue{get;set;}
Public string types{get;set;}

public  list<CD_Category__c>  categories{get;set;}
public  list<CD_Category__c> getcategories(){return categories;}
/*public  list<CD_Category__c>  categories{set;}
public  list<CD_Category__c>  categories{ 
get{if(categories == null) {
categories = new list<CD_Category__c>();}
return categories;  }

}*/



public  list<CD_Subcategory1__c>  subcateogries= new list<CD_Subcategory1__c>();
public  list<CD_Subcategory1__c> getsubcateogries(){return subcateogries;}

public  list<CD_Subcategory2__c>  subcateogries2= new list<CD_Subcategory2__c>();
public  list<CD_Subcategory2__c> getsubcateogries2(){return subcateogries2;}

public  list<CD_Subcategory3__c>  subcateogries3= new list<CD_Subcategory3__c>();
public  list<CD_Subcategory3__c> getsubcateogries3(){return subcateogries3;}

public  list<CD_GCL__c>  GCLvalues= new list<CD_GCL__c>();
public  list<CD_GCL__c> getGCLvalues(){return GCLvalues;}

public  list<CD_Category_Managers__c>  CMValues= new list<CD_Category_Managers__c>();
public  list<CD_Category_Managers__c> getCMValues(){return CMValues;}

public List<CD_GMT_Category__c> gmtCateg =  new List<CD_GMT_Category__c>();
public  list<CD_GMT_Category__c> getgmtCateg(){return gmtCateg;}

public List<CD_GMT_Subcategory_1__c> gmtSubCat1 =  new List<CD_GMT_Subcategory_1__c>();
public  list<CD_GMT_Subcategory_1__c> getgmtSubCat1(){return gmtSubCat1;}
public List<CD_GMT_Subcategory_2__c> gmtSubCat2 =  new List<CD_GMT_Subcategory_2__c>();
public  list<CD_GMT_Subcategory_2__c> getgmtSubCat2(){return gmtSubCat2;}
public List<CD_GMT_Subcategory_3__c> gmtSubCat3 =  new List<CD_GMT_Subcategory_3__c>();
public  list<CD_GMT_Subcategory_3__c> getgmtSubCat3(){return gmtSubCat3;}
public List<CD_Organizations__c> organiz =  new List<CD_Organizations__c>();
public List<CD_Organizations__c> getorganiz(){return organiz;}
public List<CD_Cost_Category__c> costCat = new List<CD_Cost_Category__c>();
public List<CD_Cost_Category__c> getcostCat(){return costCat;}
public List<CD_Market_Name__c> market = new List<CD_Market_Name__c>();
public List<CD_Market_Name__c> getmarket(){return market;}
public List<CD_Segment__c> segment = new List<CD_Segment__c>();
public List<CD_Segment__c> getsegment(){return segment;}
public boolean visible {get;set;}


public CD_Master(){
//id='01pM0000000B6jC';
visible=false;
Errormsg=false;
/*typea ='Category';
Errormsg=false;
if(typea=='Category')
categories=[select id,name from CD_category__c]; */
}



public void data(){
if(typea=='Select'){
tempstringlist.clear();
categories.clear();
subcateogries.clear();
subcateogries2.clear();
subcateogries3.clear();
GCLvalues.clear();
CMValues.clear();
gmtCateg.clear();
gmtSubCat1.clear();
gmtSubCat2.clear();
gmtSubCat3.clear();
organiz.clear();
costCat.clear();
market.clear();
segment.clear();
}

if(typea=='Category'){
categories=[select id,name from CD_category__c];

}
if(typea=='Sub Category1')
subcategory1names();
if(typea=='Sub Category2')
subcategory2names();
if(typea=='Sub Category3')
subcategory3names();
if(typea=='GCL')
GCL();
if(typea=='Category Manager')
CM();
if(typea=='GMT category')
gmtCategory();
if(typea=='GMT Subcategory1')
gmtSubCat1();
if(typea=='GMT Subcategory2')
gmtSubCat2();
if(typea=='GMT Subcategory3')
gmtSubCat3();
if(typea=='Organization')
orgs();
if(typea=='Cost Category')
costCats();
if(typea=='Market')
market();
if(typea=='Segment')
segment();

visible=true;
}


public list<string> subcategory1names(){
tempstringlist.clear();
subcateogries=[select id,name from CD_Subcategory1__c];
/*categories.clear();
subcateogries2.clear();
subcateogries3.clear(); */
for(CD_Subcategory1__c a : subcateogries)
tempstringlist.add(a.name);
return tempstringlist;
}


public list<string> subcategory2names(){
tempstringlist.clear();
subcateogries2=[select id,name from CD_Subcategory2__c];
/*categories.clear();
subcateogries.clear();
subcateogries3.clear(); */
for(CD_Subcategory2__c a : subcateogries2)
tempstringlist.add(a.name);
return tempstringlist;
}


public list<string> subcategory3names(){
tempstringlist.clear();
subcateogries3=[select id,name from CD_Subcategory3__c];
/*categories.clear();
subcateogries2.clear();
subcateogries.clear(); */

for(CD_Subcategory3__c a : subcateogries3)
tempstringlist.add(a.name);
return tempstringlist;
}



public list<string> GCL(){
tempstringlist.clear();
GCLvalues=[select id,name from CD_gcl__c];
//categories.clear();
//subcateogries2.clear();
//subcateogries.clear();
//subcateogries3.clear();
return tempstringlist;
}



public list<string> CM(){
tempstringlist.clear();
CMValues=[select id,name from CD_Category_Managers__c];
//categories.clear();
//subcateogries2.clear();
//subcateogries.clear();
//subcateogries3.clear();
//gclvalues.clear();


return tempstringlist;
}
public void gmtCategory(){
tempstringlist.clear();
//categories.clear();
gmtCateg=[select id,name from CD_GMT_Category__c];
/*categories.clear();
subcateogries2.clear();
subcateogries.clear();
subcateogries3.clear();
gclvalues.clear();


return tempstringlist;*/
}
public void gmtSubCat1(){
//categories.clear();
gmtSubCat1=[select Id,Name from CD_GMT_Subcategory_1__c];

}
public void gmtSubCat2(){
//categories.clear();
gmtSubCat2=[select Id,Name from CD_GMT_Subcategory_2__c];

}
public void gmtSubCat3(){
//categories.clear();
gmtSubCat3=[select Id,Name from CD_GMT_Subcategory_3__c];

}
public void orgs(){
//categories.clear();
organiz=[select Id,Name from CD_Organizations__c];

}
public void costCats(){
//categories.clear();
costCat=[select Id,Name from CD_Cost_Category__c];

}
public void market(){
//categories.clear();
market=[select Id,Name from CD_Market_Name__c];

}

public void segment(){
//categories.clear();
segment=[select Id,Name from CD_Segment__c];

}


PUBLIC void save(){
system.debug(typea + 'typea+++++++++++' + newvalue + 'newvalue++++++++');
if(typea=='Category'){
CD_Category__c temp = new  CD_Category__c();
temp.name=newvalue;
List<CD_Category__c> templist= new list<CD_Category__c>();
templist=[select id from CD_Category__c where name =:newvalue];
if(templist.size()==0){

insert temp;
}
else
Errormsg=true;


}

if(typea=='Sub Category1'){
CD_Subcategory1__c temp = new  CD_Subcategory1__c();
temp.name=newvalue;
List<CD_Subcategory1__c> templist= new list<CD_Subcategory1__c>();
templist=[select id from CD_Subcategory1__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;

}


if(typea=='Sub Category2'){
CD_Subcategory2__c temp = new  CD_Subcategory2__c();
temp.name=newvalue;
List<CD_Subcategory2__c> templist= new list<CD_Subcategory2__c>();
templist=[select id from CD_Subcategory2__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}

if(typea=='Sub Category3'){
CD_Subcategory3__c temp = new  CD_Subcategory3__c();
temp.name=newvalue;
List<CD_Subcategory3__c> templist= new list<CD_Subcategory3__c>();
templist=[select id from CD_Subcategory3__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;

}

if(typea=='GCL'){
CD_GCL__c temp = new  CD_GCL__c();
temp.name=newvalue;
List<CD_GCL__c> templist= new list<CD_GCL__c>();
templist=[select id from CD_GCL__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;

}

if(typea=='Category Manager'){
CD_Category_Managers__c temp = new  CD_Category_Managers__c();
temp.name=newvalue;
List<CD_Category_Managers__c> templist= new list<CD_Category_Managers__c>();
templist=[select id from CD_Category_Managers__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;

}
if(typea=='GMT category'){
CD_GMT_Category__c temp = new  CD_GMT_Category__c();
temp.name=newvalue;
List<CD_GMT_Category__c> templist= new list<CD_GMT_Category__c>();
templist=[select id from CD_GMT_Category__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='GMT Subcategory1'){
CD_GMT_Subcategory_1__c temp = new  CD_GMT_Subcategory_1__c();
temp.name=newvalue;
List<CD_GMT_Subcategory_1__c> templist= new list<CD_GMT_Subcategory_1__c>();
templist=[select id from CD_GMT_Subcategory_1__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='GMT Subcategory2'){
CD_GMT_Subcategory_2__c temp = new  CD_GMT_Subcategory_2__c();
temp.name=newvalue;
List<CD_GMT_Subcategory_2__c> templist= new list<CD_GMT_Subcategory_2__c>();
templist=[select id from CD_GMT_Subcategory_2__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='GMT Subcategory3'){
CD_GMT_Subcategory_3__c temp = new  CD_GMT_Subcategory_3__c();
temp.name=newvalue;
List<CD_GMT_Subcategory_3__c> templist= new list<CD_GMT_Subcategory_3__c>();
templist=[select id from CD_GMT_Subcategory_3__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='Cost Category'){
CD_Cost_Category__c temp = new  CD_Cost_Category__c();
temp.name=newvalue;
List<CD_Cost_Category__c> templist= new list<CD_Cost_Category__c>();
templist=[select id from CD_Cost_Category__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;

}
if(typea=='Organization'){
CD_Organizations__c temp = new  CD_Organizations__c();
temp.name=newvalue;
List<CD_Organizations__c> templist= new list<CD_Organizations__c>();
templist=[select id from CD_Organizations__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='Market'){
CD_Market_Name__c temp = new  CD_Market_Name__c();
temp.name=newvalue;
List<CD_Market_Name__c> templist= new list<CD_Market_Name__c>();
templist=[select id from CD_Market_Name__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
if(typea=='Segment'){
CD_Segment__c temp = new  CD_Segment__c();
temp.name=newvalue;
List<CD_Segment__c> templist= new list<CD_Segment__c>();
templist=[select id from CD_Segment__c where name =:newvalue];
if(templist.size()==0){
insert temp;
}
else
Errormsg=true;
}
data();
}

public void typeSet(){
types=typea;
}
public  void  setcategories(list<CD_Category__c>  cat)
{

this.categories = cat; 

}
   public void saveScore() {    
   
   /*-------------------------  Scoring Guide---------------------------------------------- */
   
     system.debug('in savescore');
     system.debug(types + 'in savescore types');
     //string type= Apexpages.currentPage().getParameters().get('two');
     //system.debug(types + 'in savescore types '+categories.size() );
     if(types=='category' && categories!=null && categories.size()>0)
     {
      //system.debug('in category');
     upsert categories;
     }
     if(typea=='Sub category1' && subcateogries!=null && subcateogries.size()>0)
     {
      upsert subcateogries; 
     }
     if(typea=='Sub category2' && subcateogries2!=null && subcateogries2.size()>0)
     {
      upsert subcateogries2; 
     }
      if(typea=='Sub category3' && subcateogries3!=null && subcateogries3.size()>0)
     {
      upsert subcateogries3; 
     }
      if(typea=='GCL' && GCLvalues!=null && GCLvalues.size()>0)
     {
      upsert GCLvalues; 
     }
      if(typea=='Category Manager' && CMValues!=null && CMValues.size()>0)
     {
      upsert CMValues; 
     }
     if(typea=='GMT category' && gmtCateg!=null && gmtCateg.size()>0)
     {
      upsert gmtCateg; 
     }
      if(typea=='GMT Subcategory1' && gmtSubCat1!=null && gmtSubCat1.size()>0)
     {
      upsert gmtSubCat1; 
     }
      if(typea=='GMT Subcategory2' && gmtSubCat2!=null && gmtSubCat2.size()>0)
     {
      upsert gmtSubCat2; 
     }
      if(typea=='GMT Subcategory3' && gmtSubCat3!=null && gmtSubCat3.size()>0)
     {
      system.debug(gmtSubCat3 + 'in subcat3');
      upsert gmtSubCat3; 
     }
      if(typea=='Cost Category' && costCat!=null && costCat.size()>0)
     {
      upsert costCat; 
     }
       if(typea=='Organization' && organiz!=null && organiz.size()>0)
     {
      upsert organiz; 
     }
     
   //return null;
     data();  
   }
   
   
/* Public pagereference saveMaster(){  
 id ids= Apexpages.currentPage().getParameters().get('ids');
  string name= Apexpages.currentPage().getParameters().get('name');
if(typea=='Category'){
List<CD_category__c> temp = new list<cd_category__c>();
cd_category__c a = new cd_category__c();
a.id=id;
a.name=name;
temp.add(a);
update temp;
}
 return null;
 
 } */

  Public PageReference Reset(){
   string   Url  = 'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        Url  = Url +'/apex/CD_MasterData';

        PageReference RedirectingPage = new PageReference(Url );
        return RedirectingPage;
    }
   

}