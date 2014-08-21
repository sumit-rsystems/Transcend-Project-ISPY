<script type="text/javascript">
	function addYearInDateField(relatedYearShow) {
		//alert(document.getElementById('datePicker').innerHTML);
		 var currentYear = new Date().getFullYear();
		 var startYear;
		 var endYear;
		 
		 if(relatedYearShow == 'past'){
		 	 startYear= 1900;
		 	 endYear=currentYear;
		 }else if(relatedYearShow == 'future'){
		 	startYear= currentYear;
		 	endYear= currentYear + 30;
		 }else{
		 	 startYear= 1950;
			 endYear=currentYear + 20;
		 }
		 
		 var htmlStr='';
		 if(startYear<endYear){
		 	for(i=startYear;i<endYear+1;i++){
		 		if(i == currentYear) {
		 			htmlStr += "<option value=\""+i+"\" selected=\"selected\">"+i+"</option>";
		 		} else {
			 		htmlStr += "<option value=\""+i+"\">"+i+"</option>";
		 		}
		 	}
		}
		//alert(htmlStr);
		document.getElementById('calYearPicker').innerHTML = htmlStr; 
	}
</script>