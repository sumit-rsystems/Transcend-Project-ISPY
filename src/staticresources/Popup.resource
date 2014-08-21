//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//loading popup with jQuery magic!
function loadPopup(){
	//loads popup only if it is disabled
	if(popupStatus == 0){
		$("#backgroundPopup").css({
			"opacity": "0.7"
		});
		$("#backgroundPopup").fadeIn("slow");
		$("#popup_editProcedure").fadeIn("slow");
		popupStatus = 1;
	}
}

function loadPopup_Lymph(){
	//loads popup only if it is disabled
	if(popupStatus == 0){
		$("#backgroundPopup").css({
			"opacity": "0.7"
		});
		$("#backgroundPopup").fadeIn("slow");
		$("#popup_editLymphProcedure").fadeIn("slow");
		popupStatus = 1;
	}
}

function centerPopup(){
	//request data for centering
	var windowWidth =1000;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $("#popup_editProcedure").height();
	var popupWidth = $("#popup_editProcedure").width();
	//centering
	$("#popup_editProcedure").css({
		"position": "absolute",
		"top": windowHeight/2-(popupHeight/1),
		"left": windowWidth/2-(popupWidth/2)
		
	});
	
	//only need force for IE6
	
	$("#backgroundPopup").css({
		"height": windowHeight
	});
	loadPopup();
}

function centerPopup_Lymph() {
	//request data for centering
	var windowWidth =1000;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $("#popup_editLymphProcedure").height();
	var popupWidth = $("#popup_editLymphProcedure").width();
	//centering
	$("#popup_editLymphProcedure").css({
		"position": "absolute",
		"top": windowHeight/2-(popupHeight/1),
		"left": windowWidth/2-(popupWidth/2)
		
	});
	
	//only need force for IE6
	
	$("#backgroundPopup").css({
		"height": windowHeight
	});
	loadPopup_Lymph();
}

function disablePopup(){
	//disables popup only if it is enabled
	if(popupStatus == 1){
		$("#backgroundPopup").fadeOut("slow");
		$("#popup_editProcedure").fadeOut("slow");
		
		popupStatus = 0;
	}
}

function disablePopup_Lymph(){
	//disables popup only if it is enabled
	if(popupStatus == 1){
		$("#backgroundPopup").fadeOut("slow");
		$("#popup_editLymphProcedure").fadeOut("slow");
		
		popupStatus = 0;
	}
}


/*
$(document).ready(function(){
	
	//LOADING POPUP
	//Click the button event!
	$("#pageId:pageBlockId:pageSectionId:pageCompId:ProcedureComponent:showProcedureForm:theTable:0:editBtn").click(function(){
		//centering with css
		centerPopup_signup();
		//load popup
		loadPopup_signup();
	});
});*/