<sys:write name="daiList" property="kaisoukajisiDate" format="yyyy/MM/dd"/>
<sys:write name="rireki" property="kaisoukajisi" format="G.yy.MM.dd" />
  var url = getRealPath("/daiKk0200.do");
----------------------------------------------------------------------
<logic:iterate id="daiList" name="checkableList" indexId="index">
 <a href="javaScript:doKaisoukaOne(${index});">再処理</a>


  document.forms[1].action="daiKk0100.do?dokaisoukaOne=true"
                   + "&id=" + getElementByName("id", index).value
                   + "&nendo=" + getElementByName("nendo", index).value
                   + "&kanyuNo=" + getElementByName("kanyuNo", index+1).value
                   + "&fuyouNo=" + getElementByName("fuyouNo", index+1).value
                   + "&syutokuNo=" + getElementByName("syutokuNo", index).valu
                   + "&sidouKbn=" + getElementByName("asidouKbn", index).value
                   + "&knsnSeqno=" + getElementByName("knsnSeqno", index).valu
                   + "&yearmonth=" + getElementByName("yearmonth",index).value;
       
        
         document.forms[1].submit();

-----------------------------------------------------------------------

function setresult(){
	
	var tab = $id("table_DHP");

	var i;
	var result =new Array();
	for(i=0;i<tab.rows.length;i++){
			
		var chebox= tab.rows[i].cells[0].childNodes[0];
		var cd    = tab.rows[i].cells[1].innerHTML;		
		var nm    = tab.rows[i].cells[2].innerHTML;
	     
		if(chebox.checked){
			
			result.push({"cd":cd,"nm":nm});
		}
		
	}

//	for(var j=0;j<result.length;j++){
		
	//	alert(result[j].cd+'   '+result[j].nm);
//	}
	
	    doCallBack(result);
	    window.close();
}





function doSearchDHP(){

	
  var path ="<html:rewrite page='/daiSearchDHP.do'/>" ;
    showDialogWindow(path, 730, 560,
        function(result){
            if(!result) {
                return;
            }
                   
            doSetDHP_(result);
        });
	
}



function doSetDHP_(result){
	

	var spanNm = $id("DHP_Nm");
	var hidenCd =$id("dhpCd");


	spanNm.innerHTML = "";
	hidenCd.value = "";
	
	var j;
	var nm_array="";
	var cd_array = "";
	for( j=0;j<result.length;j++){
		
		 nm_array +=  trim(result[j].nm)  +",";
		 cd_array +=  trim(result[j].cd) +",";
		 //cd_array.push(trim(result[j].cd)); 
	}

--------------------------------------------------------------------------
 <html:select name="daiKk0100Form" property="newKaisouLevel">
            <sys:blankOption/>
       <html:options collection="CTD02" property="key" labelProperty="value"/>
            </html:select>


 <html:checkbox property="chooseinput"  onclick="openOrClose(this,'conditiondiv')" />



----------------------------------------------------------------------

function trim(str){
	    return str.replace(/(^\s*)|(\s*$)/g, "");
	}

	
function submit1(){
		
	 var kigous = trim(getElementByName("kigous",0).value);
		if(kigous ==""){
			return;
		}
	  
				 
		var re = /[^A-Za-z0-9\,]+/g;  
		if(!re.test(kigous)){
			
		  document.forms[0].submit();
		}else{
			alert("記号を半角英数字（区切り「,」）で入力してください。")
		}
		  
		
	}


---------------------------------------------------------------------
<html:select name="daiKk0400Form" property="newDhpKbn">
							<logic:iterate id="keyvalue" name="keyValueList">
								<html:option value="${keyvalue.dhpKbn }">${keyvalue.dhpKbn }:${keyvalue.note }</html:option>
							</logic:iterate>

						</html:select>


---------------------------------------------------------------------------
	for (i = 0; i < selects.options.length; i++) {

			if (selects.options[i].selected) {
				if (selects.options[i].value == dhpKbn) {

					alert("変更前と異なる値を選択してください。");
					return;
				}
			}

		}

-------------------------------------------------------------------------
function openOrClose(obj, id) {

		if (obj.checked) {

			getElementById(id).style.display = "block";
		} else {

			getElementById(id).style.display = "none";
		}

	}
--------------------------------------------------------------------------
	function setContent(obj) {

		obj.setAttribute("title", obj.innerHTML);
	}


-----------------------------------------------------------------------------

		var reseCheckBox = getElementByName("reseCheckBox", 0);

		//選択入力
		if (reseCheckBox.checked) {
			var hanni = document.forms[0].elements("hanni");

			if (hanni[0].checked) {
				//範囲指定

			} else if (hanni[1].checked) {


------------------------------------------------------------------------

document.forms[0].action = "daiKk0400.do?doSearch=true";
		document.forms[0].submit();


----------------------------------------------------------------------
	function checkNumAndLetter(obj) {

		var re = /[^0-9A-Za-z]+/g

		if (!re.test(obj)) {
			return true;
		}
		return false;
	}

	//
	function checkNum(num) {

		var re = /[^0-9]+/g

		if (!re.test(num)) {
			return true;
		}
		return false;
	}


-----------------------------------------------------------------------------
//現行DHP区分
	function setKHenkoDHP(index) {

		var paramter = "&kanyuNo2="
				+ getElementByName("kanyuNo", index + 1).value + "&fuyouNo2="
				+ getElementByName("fuyouNo", index + 1).value
				+ "&setKHenkoDHP=true";

		var url = getRealPath("/daiKk0400.do");
		showDialogWindow(url + paramter, 300, 230, function(result) {
			if (result) {
				document.forms[0].submit();
			}
		});
	}

--------------------------------------------------------------------------------
<SCRIPT language=JavaScript src="dai/common/DaiConKojinJs.jsp">
									
								</SCRIPT>



-----------------------------------------------------------------------------------
<td class="tblIndex3" width="170px">処理年度</td>
			<td class="tblCel2L" width="200px">
				<sys:year name="daiKk0100Form" property="syoriNendo" onchange="doClearRireki();"/>
			</td>

------------------------------------------------------------------------
<td class="tblIndex3">入力日</td>
	            <td class="tblCel2L" colspan="3"> 
	              <sys:date property="inputStartDate" hasBlank="true"/>
	            	&nbsp;&nbsp;～&nbsp;&nbsp;
	              <sys:date property="inputEndDate" hasBlank="true"/>
	            </td>


-------------------------------------------------------------------------

function getResuputokikan() {
	var url = "<html:rewrite action='/daiKk0500.do'/>&doGetResuputokikan=true"
			  +"&syoriDateStr="+$F("syoriDate") + "01";

	new Ajax.Request(
		    url, {
		        method: 'post',
		        asynchronous : false,
		        encoding : 'UTF-8',
		        onComplete: function(result){
		        	var str = getResponseText_(result);  
                                //str = result.responseText;
                                //var contentType = result.getHeader('Content-type');
 
		        	var rs =str.evalJSON();
		        	$("resuputokikan").innerText = rs.from + '～' + rs.to;
		        },
		        onException: function(ajax, exception) {
		            
		        }
		    });
}


public void doGetResuputokikan(){
		 String syoriDateStr = (String) data.get("syoriDateStr");
		 Date resuputokikanFrom = null;
		 Date resuputokikanTo = null;
		 Calendar c = Calendar.getInstance();
		 c.setTime(DateUtil.string2Date(syoriDateStr,Constant.DateFormat.yyyyMMddShort.getFormat()));
		 c.add(c.MONTH, -12);
		 resuputokikanFrom = c.getTime();
		 c.setTime(DateUtil.string2Date(syoriDateStr,Constant.DateFormat.yyyyMMddShort.getFormat()));
		 c.add(c.MONTH, -1);
		 resuputokikanTo = c.getTime();
		 String from = DateUtil.date2String(resuputokikanFrom, Constant.DateFormat.GyyMM.getFormat());
		 String to = DateUtil.date2String(resuputokikanTo, Constant.DateFormat.GyyMM.getFormat());
		 
		 String rsJson = "";
		 rsJson = "{\"from\":\"" + from + "\",";
	     rsJson += "\"to\":\"" + to + "\"}";

        WebUtil.write(response, rsJson);
	}
------------------------------------------------------------------------------------
function compareDate(startNm, endNm){
  
  // 入力日.開始日
  var sjyear = getElementByName(startNm + "Year", 0).value;
  var sjmonth = getElementByName(startNm + "Month", 0).value;
  var sjday = getElementByName(startNm + "Day", 0).value;
  var sjymd = sjyear+sjmonth+sjday;
  // 入力日.終了日
  var ejyear = getElementByName(endNm + "Year", 0).value;
  var ejmonth = getElementByName(endNm + "Month", 0).value;
  var ejday = getElementByName(endNm + "Day", 0).value;
  var ejymd = ejyear+ejmonth+ejday;

  if (sjymd.length != 0 && ejymd.length != 0 && sjymd > ejymd){
    return true;
  }
}


<sys:date name="daiKk0500Form" property="syoriDate" showDay="false" onchange="getResuputokikan();" />
--------------------------------------------------------------------------------------
function getCheckedObjects(tableId){

    var result = new Array();

    var objTable = $(tableId);
    if(objTable == null)
        return result;

    var rows = objTable.tBodies[0].rows;
    for(var i=0; i < rows.length; i++) {
        //一列目だけ見る
        var inpts = rows[i].cells[0].getElementsByTagName("INPUT");
        for(var l=0; l<inpts.length; l++){
            var inpt = inpts[l];
            if(inpt.disabled)
                continue;
            if(inpt.type.toLowerCase() == "checkbox" && inpt.checked)
                result[result.length] = inpt;
        }
    }

    return result;


---------------------------------------------------------------------
function doSet() {

	var date = "";
	var wareki = "";
	
	with(document.forms[0]) {
		<%-- チェックのついている項目をセット --%>
		if(typeof(check.length) != "undefined"){
			for(var i = 0; i < check.length; i++) {
				if(check[i].checked == true) {
					if(date == ""){
						wareki +=kaisoukajisiDate[i].value;
						date +=kajisiDate[i].value;
					}else{
						wareki +="," +kaisoukajisiDate[i].value;
						date +="," +kajisiDate[i].value;
					}
				}
			}
		}else{
			if(check.checked){
				wareki += kaisoukajisiDate.value;
				date += kajisiDate.value;
			}
		}
	}
	result = wareki+"、"+date;
	doCallBack(result);
	window.close();
}


-----------------------------------------------------------------------

	var date = new Date(str[2]);
    						
        					date.setMonth(date.getMonth() + 4);
        					
        					$("syoriDate").value = date;
        					setDateValue("syoriDate",date);


----------------------------------------------------------------------
	function find(obj){
		
		 var temp = [];
		 var result = document.getElementsByTagName("*");
	
		   for(attr in obj)
		  {
			   
			   
			   var i ;
				  for(i=0;i<result.length; i++)
				  {
					  
					  
					  if(typeof(result[i][attr])!='undefined' )
					  {		
						  if((attr=='tagName'? result[i][attr].toLowerCase():result[i][attr]) ==obj[attr]){
							  
						      temp.push(result[i]);
						  }
					  }
						  					  			  
				  }	
		      
			  result = temp;
			  
			  temp =[];
			  
		  } 
			   
		   return result;
	}
	

		     var obj = {tagName:'table',id:'h'};
			
			
			   alert(find(obj).length);


-------------------------------------------------------------------
//alert(find({name:"ageFrom"})[0].parentNode.childNodes[1].toString());
		//alert(find({name:"ageFrom"})[0].nextSibling.nextSibling.name);
		//alert(find({name:"ageTo"})[0].previousSibling.previousSibling.name);
	    //	previousSibling
	    //pare
	    //chil
	   // alert(find({name:"ageTo",prev:2})[0].name);
	   // alert(find({name:'ageTo',pare:1})[0].innerHTML);
	}

	 function relative(result,obj){
		 var temp = []; 
		
		 for(attr in obj){
			 if(attr == 'next')
			 {
					
               for(var i =0;i<result.length;i++)
               {
            		 
            	   for(var j=0;j<obj[attr];j++)
            	   {
            		   result[i] = result[i].nextSibling;
            	   }
            	   
            	   if(typeof(result[i]) !='undefined')
            	   {
            		   temp.push(result[i]);
            	   }
               } 
			
			 }else if(attr=='pare'){
			 
			 for(var i =0;i<result.length;i++)
	           {
				 for(var j=0;j<obj[attr];j++)
          	     {
          		   result[i] = result[i].parentNode;
          	     }
          	   
          	   if(typeof(result[i]) !='undefined')
          	     {
          		   temp.push(result[i]);
          	    }
	           }
		     }else if(attr=='prev'){
				
				  for(var i =0;i<result.length;i++)
	               {
	            		 
	            	   for(var j=0;j<obj[attr];j++)
	            	   {
	            		   result[i] = result[i].previousSibling;
	            	   }
	            	   
	            	   if(typeof(result[i]) !='undefined')
	            	   {
	            		   temp.push(result[i]);
	            	   }
	               } 				 
				 
			 }
			 
			 
		 }
		 
		return temp; 
	 }

	function find(obj){
		
		 var temp = [];
		 var result = document.getElementsByTagName("*");
	
		   for(attr in obj)
		  {
			   
			   if(attr !='next' && attr !='prev'&& attr != 'pare'){
			   var i ;
				  for(i=0;i<result.length; i++)
				  {
					  
					  
					  if(typeof(result[i][attr])!='undefined' )
					  {		
						  if((attr=='tagName'? result[i][attr].toLowerCase():result[i][attr]) ==obj[attr]){
							  
						      temp.push(result[i]);
						  }
					  }
						  					  			  
				  }	
			   
			  result = temp;
			  
			  temp =[];
			  
		  } 
	   }   
		   return relative(result,obj);
	}


--------------------------------------------------------------------------
//alert(find({name:"ageFrom"})[0].parentNode.childNodes[1].toString());
		//alert(find({name:"ageFrom"})[0].nextSibling.nextSibling.name);
		//alert(find({name:"ageTo"})[0].previousSibling.previousSibling.name);
	    //	previousSibling
	    //pare
	    //chil
	    alert(find({id:"hhh",relative:"chil3"})[0].name);
	  
	}

		 function relative(result,obj){
		 var temp = []; 	
		 var count = 0;
		 for(attr in obj){
			 if(attr == 'relative')
			 {
				 count ++;
				 var num = obj[attr].substring(4);
				 var relative = obj[attr].substring(0,4);

               for(i=result.length-1;i>=0; i--)
               {
            		 
            	   for(var j=0;j<num;j++)            	
            	   {
            		   if(relative =='next'){            			   
            		   result[i] = result[i].nextSibling;
            		   }else if(relative=='prev'){
            			   result[i] = result[i].previousSibling;
            		   }else if(relative =='pare'){
            			   result[i] = result[i].parentNode;
            		   }
            	   }
            	    if(relative =='chil'){
         			  result[i] = result[i].childNodes[num-1];            			   
         		   }
            	   
            	   
            	   if(typeof(result[i]) !='undefined')
            	   {
            		   temp.push(result[i]);
            	   }
               } 
			
			 }
			 			 
		 }
		 
		 if(count ==0){
			return result; 
		 }else{
			return temp; 
		 }
		
	 }

	function find(obj){
		
		 var temp = [];
		 var result = document.getElementsByTagName("*");
	
		   for(attr in obj)
		  {
			   
			   if(attr !='relative'){
			   var i ;
				  for(i=result.length-1;i>=0; i--)
				  {
					  
					  
					  if(typeof(result[i][attr])!='undefined' )
					  {		
						  if((attr=='tagName'? result[i][attr].toLowerCase():result[i][attr]) ==obj[attr]){
							  
						      temp.push(result[i]);
						  }
					  }
						  					  			  
				  }	
			   
			  result = temp;
			  
			  temp =[];
			  
		  } 
	   }   
		   return relative(result,obj);
	}


--------------------------------------------------------------------------------

	public void doAjax(){
		
		ksyokaiRirekiList = dhpService.getKsyokaiRireki(data);
		JSONArray jsonArray = JSONArray.fromObject(ksyokaiRirekiList);
		
		WebUtil.write(response, jsonArray.toString());
		
	}	  
var paramter = "&doAjax=true" 
			 + "&kanyuNo2=" +"4000008"
			 + "&fuyouNo2=" + "0";

var url = getRealPath("/daiDt0000.do") +paramter;
             
	  new Ajax.Request( url, {
	        method: 'post',
	        asynchronous : false,
	        encoding : 'UTF-8',
	        onComplete: function(result){
	        	var str = getResponseText_(result);  
                            //str = result.responseText;
                            //var contentType = result.getHeader('Content-type');

	        	var rs =str.evalJSON();
	        	
	        
	        	
	        	var tab = document.createElement("table");
	        	var tbody = document.createElement("tbody");
	        	// class="tblBase" border="0"
	        	tab.border ="1";
	        	//tab.class ='red';
	        	tab.id ="class";
	        	tab.setAttribute("class","hello");
	        	for(var i = 0;i<rs.length;i++)
	        	{
	        		var tr = document.createElement("tr");
	        		
	        		for(e in rs[i])
	        		{
	        				        	   
	                 var td = document.createElement("td");
	        
	                 td.innerHTML =e+":"+rs[i][e];
	                 tr.appendChild(td);
	        		}
	        		tbody.appendChild(tr)
	        		tab.appendChild(tbody);
	        		
	        	}
	              document.body.appendChild(tab);
	         
	               alert(document.getElementById('class').getAttribute("class"));
	        	
	      
	        },
	        onException: function(ajax, exception) {
	            
	        }
	    });

    <script type="text/javascript">
            var board = document.getElementById("board");
            var e =document.createElement("input");
           e.type = "button";
            e.value = "?是??加?的小例子";
            var object = board.appendChild(e);
        </script>


<script type="text/javascript">
  var oTest = document.getElementById("test");
  var newNode = document.createElement("p");
  newNode.innerHTML = "This is a test";
  oTest.insertBefore(newNode,oTest.childNodes[0]);
</script>
	
	
class 是js的???，不能?象.class, 可以
?象.getAttribute("class")  setAttribute("class","hellow");  

createElement table 一定要添加tbody 
	var tab = document.createElement("table");
	var tbody = document.createElement("tbody");

var h=document.createElement("H1")
var t=document.createTextNode("Hello World");
h.appendChild(t); 


  document.body.insertBefore(document.createTextNode(name),document.body.childNodes[0]);
------------------------------------------------------------------
	<tr>
					<td class="tblIndex3D" width="100">変更後</td>
					<td class="tblCel2L" width="100">
						<html:select name="daiDt0000Form" property="newDhpKbn">
							<html:options collection="dhpkbnList" property="key" labelProperty="value"/>
						</html:select>
					</td>
				</tr>


--------------------------------------------------------------------------------------------
Js?取当前日期??及其它操作

var myDate = new Date();
myDate.getYear();        //?取当前年?(2位)
myDate.getFullYear();    //?取完整的年?(4位,1970-????)
myDate.getMonth();       //?取当前月?(0-11,0代表1月)
myDate.getDate();        //?取当前日(1-31)
myDate.getDay();         //?取当前星期X(0-6,0代表星期天)
myDate.getTime();        //?取当前??(从1970.1.1?始的毫秒数)
myDate.getHours();       //?取当前小?数(0-23)
myDate.getMinutes();     //?取当前分?数(0-59)
myDate.getSeconds();     //?取当前秒数(0-59)
myDate.getMilliseconds();    //?取当前毫秒数(0-999)
myDate.toLocaleDateString();     //?取当前日期
var mytime=myDate.toLocaleTimeString();     //?取当前??
myDate.toLocaleString( );  

 -----------------------------------------------------------------

Date.prototype.Format = function(fmt)   
{ //author: meizz   
  var o = {   
    "M+" : this.getMonth()+1,                 //月?   
    "d+" : this.getDate(),                    //日   
    "h+" : this.getHours(),                   //小?   
    "m+" : this.getMinutes(),                 //分   
    "s+" : this.getSeconds(),                 //秒   
    "q+" : Math.floor((this.getMonth()+3)/3), //季度   
    "S"  : this.getMilliseconds()             //毫秒   
  };   
  if(/(y+)/.test(fmt))   
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  for(var k in o)   
    if(new RegExp("("+ k +")").test(fmt))   
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
  return fmt;   
}  

function submit1() {
	
	with(document.forms[0]){
		//alert(nenreiFrom.value);
		//alert(nenreiTo.value);
	   
		
	    var birthFrom1 = new Date();
	     birthFrom1.setYear(new Date().getYear() -nenreiTo.value);
	     
	     var birthTo1 = new Date();
	     birthTo1.setYear(new Date().getYear() -nenreiFrom.value);
	     birthTo.value = birthTo1.Format("yyyyMMdd"); 
	     birthFrom.value = birthFrom1.Format("yyyyMMdd");
	    
	}
	
	document.forms[0].submit();
}
