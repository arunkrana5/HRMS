$(document).ready(function () {
	ShowLoadingDialog();
	$("#btnSearch").click();

});

$('#Month').bind("change", function () {
	ShowLoadingDialog();
	$("#btnSearch").click();

});


function GetLeaveSummary() {
	ShowLoadingDialog();
	var Month = $("#Month").val();
	$.ajax({
		url: "/Activity/_LeaveSummary",
		type: "Get",
		data: {
			src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_LeaveSummary" + "*" + Month)
		},
		success: function (data) {
			$("#LeaveSumDiv").empty();
			$("#LeaveSumDiv").html(data);
			$("#ModalLeaveSum").modal('show');
			CloseLoadingDialog();
		},
		error: function (er) {
			CloseLoadingDialog();
		}
	});
}



function BindTarget(args) {

	$("#TargetDiv").html(args);
	$('[data-toggle="tooltip"]').tooltip();
	$(".applyselect").select2();
	var form = $("#_SaveDailyLogForm").closest("form");
	form.removeData('validator');
	form.removeData('unobtrusiveValidation');
	$.validator.unobtrusive.parse(form);

	var IsSubmitted = $("#IsSubmitted").val();

	$("#btnAddproject").click(function () {
		GetAddProjectList();
	});
	ClicableNextPrevious();
	$("#btnAddTask").click(function () {
		CreateStandardTask();
	});
	GetLatestTask();
	$(".btnrequestforCO").click(function (e) {
		ShowRequestForComOFf();
	});

	CalculateTotalHours();
	$("#btnVerifyAndSave").click(function () {

		if (ValidateDays()) {
			ValidateVerfiyAndSave();
		}
	});

	if (IsSubmitted == "False") {
		GetHoursSummary();
		$('.hideaftersub').show();
	} else {
		$('.hideaftersub').hide();
	}

	$(".Anchrrecall").click(function (e) {
		e.preventDefault();
		fnRecall();
	});

	$(".ALSummary").click(function (e) {
		e.preventDefault();
		GetLeaveSummary();
	});

	$("#AStandardtask").click(function () {

		GetStandardTaskList();
		$("#poptask").modal('show');
	});

	CloseLoadingDialog();
}

function ValidateVerfiyAndSave() {
	var a = Number($("#LeaveWithAttachmentPending").val());
	var IsHaveComOff = $('#IsHaveComOff').val();
	
	if (a > 0) {

		var content = 'To avail CL/SL leave type it is mandatory to submit Fitness certificate, kindly attach the certificate?';
		SyncConfirmBox('Warning', content, funOk, funCan)
		function funOk() {
			ShowLoadingDialog();
			var src = EncryptQueryStringJSON(MenuID + "*" + "/Leave/LeaveDashboard*" + Month);
			window.location = "/Leave/LeaveDashboard?src=" + src;

			//var src = EncryptQueryStringJSON(MenuID + "*" + "/Leave/LeaveDashboard*" + Month);
			//src = "/Leave/LeaveDashboard?src=" + src;
			//SyncCloseDialog();
			//let a = document.createElement('a');
			//a.target = '_blank';
			//a.href = src;
			//a.click();
		}

		function funCan() {
			var ms1 = "CL/SL leave will be converted to Annual Leave and LWP as per available balance. Do you want to proceed?";
			SyncCloseDialog();
			SyncConfirmBox("Warning", ms1, OkSuccess, CanFail)
		}

		function OkSuccess() {

			SyncCloseDialog();
			$("#btnSubmit").click();


		}
		function CanFail() {
			SyncCloseDialog();
			SyncAlert("Action", "Please attach fitness certificate or cancel your CL/SL request and apply other leave type", SyncCloseDialog)
		}
	}

	else if (IsHaveComOff > 0)
	{
		SyncConfirmBox('Warning', "You are eligible for comp-off. Do you want to apply?", funCoOk, funCoCan)
		function funCoOk() {
			SyncCloseDialog();
			$(".btnrequestforCO").click();
		}

		function funCoCan() {
			
			SyncCloseDialog();
			$("#btnSubmit").click();
		}
	}
	else {
		$("#btnSubmit").click();
	}
}

function ValidateDays() {

	var Ret = false;
	var Msg = "";
	var FixGrandTotal = 0;
	$(".validatehours").each(function (index) {
		var a = parseInt(Number($(this).html()));
		if (a < 8 || a > 24) {
			Msg += this.id.split('_')[1] + ", ";
		}
	});
	if (Msg == "") {
		Ret = true;
	}
	else {
		swal("Hey! Please verify entries on", Msg.replace(/,\s*$/, ""));
	}
	return Ret;
}



function GetAddProjectList() {
	var Month = "";
	$.ajax({
		url: "/Activity/_AddProject",
		type: "Get",
		data: {
			src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_AddProject" + "*" + Month)
		},
		success: function (data) {
			$("#AddProjectDiv").html(data)
			$("#adproject").modal('show');
			$('[data-toggle="tooltip"]').tooltip();
			Tiktok();
			$("#btnAddSaveProject").click(function () {
				SaveEMPProject();
			});



		}
	});
}


function Tiktok() {
	//Retrieve two groups of elements, items and bins
	var items = document.getElementsByClassName('item');
	var bins = document.getElementsByClassName('bin');


	//Register event listeners for click event on the items
	for (var i = 0; i < items.length; i++) {
		items[i].addEventListener("click", sortItem);
	}

	// Prevent image dragging, so as to not suggest that items are draggable
	for (var i = 0; i < items.length; i++) {
		items[i].ondragstart = function () { return false; };
	}

	function sortItem(e) {

		//Stores referrence to clicked element
		var clickedEl = document.getElementById(this.id);

		// Crummy way of sorting
		if (clickedEl.parentNode == bins[0]) {
			moveItemToBin(clickedEl, 1);
		} else {
			moveItemToBin(clickedEl, 0);
		}
	}


	function moveItemToBin(item, binref) {

		// Get the first position.
		var first = item.getBoundingClientRect();

		// Now set the element to the last position.

		bins[binref].appendChild(item);

		// Read again.
		var last = item.getBoundingClientRect();

		// Invert.
		var inverty = first.top - last.top;
		var invertx = first.left - last.left;


		// Go from the inverted position to last.
		// Note that .animate doesn't work on Safari! Use alternative!
		var player = item.animate([
			{ transform: 'translateY(' + inverty + 'px) translateX(' + invertx + 'px)' },
			{ transform: 'translateY(0) translateX(0)' }
		], {
			// Move 1px per millisecond
			duration: Math.sqrt(inverty ** 2 + invertx ** 2) * 2,
			easing: 'cubic-bezier(0.72, 0, 0.12, 1)',
		});

		// Cleanup
		item.classList.remove("moving");

	}
}

function createProjectListSearch() {
	var input, filter, ul, li, a, i, txtValue;
	input = document.getElementById('txtSearchProject');
	filter = input.value.toUpperCase();
	ul = document.getElementById("ULProjectList");
	li = ul.getElementsByTagName('li');

	// Loop through all list items, and hide those who don't match the search query
	for (i = 0; i < li.length; i++) {
		a = li[i].getElementsByTagName("a")[0];

		txtValue = a.textContent || a.innerText;
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			li[i].style.display = "";
		} else {
			li[i].style.display = "none";
		}

	}
}


function createProjectRemoveSearch() {
	var input, filter, ul, li, a, i, txtValue;
	input = document.getElementById('txtSearchRemove');
	filter = input.value.toUpperCase();
	ul = document.getElementById("ULProjectRemove");
	li = ul.getElementsByTagName('li');

	// Loop through all list items, and hide those who don't match the search query
	for (i = 0; i < li.length; i++) {
		a = li[i].getElementsByTagName("a")[0];

		txtValue = a.textContent || a.innerText;
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			li[i].style.display = "";
		} else {
			li[i].style.display = "none";
		}

	}
}


function SaveEMPProject() {

	var liIds = $('#ULProjectRemove li').map(function (i, n) {
		return $(n).attr('id').split('_')[1];
	}).get().join(',');

	if (liIds != '') {
		ShowLoadingDialog();
		$.ajax({
			url: "/CommonAjax/SaveEmployeeProjectJson",
			type: "Post",
			async: true,
			data: { ProjectIDs: liIds },
			success: function (data) {
				if (data == 0) {
					CloseLoadingDialog();
					swal('', 'There is some problem occured');

				}
				else {
					window.location.reload();
				}
			},
			error: function (er) {
				CloseLoadingDialog();
			}
		});
	}
}

function CreateStandardTask() {

	var Message = $("#txtStandardTask").val();

	if ($.trim(Message) != "") {
		ShowLoadingDialog();
		$.ajax({
			url: "/CommonAjax/SaveStandardTaskJson",
			type: "Post",
			async: true,
			data: { Message: Message },
			success: function (data) {
				CloseLoadingDialog();
				if (data == 0) {
					swal('', 'There is some problem occured');
					$("#txtStandardTask").val('');
				}
				else {
					$("#txtStandardTask").val('');
					GetLatestTask();
					GetStandardTaskList();

				}
			},
			error: function (er) {
				CloseLoadingDialog();
			}
		});
	}
	else {
		swal('', 'Can not be blank');

	}
}






// add new Row
function AddNewRow() {
	var LastTRCount = parseInt($('#tblActivity').find("tbody tr").length) - 1;
	$('.applyselect').select2("destroy");
	var $tableBody = $('#tblActivity').find("tbody"),
		$trLast = $tableBody.find("tr:last"),
		$trNew = $trLast.clone();
	$trNew.find("td:last").html('<a onclick="DeleteRow(this)" class="remove" data-toggle="tooltip" data-original-title="Remove"><i class="fas fa-window-close red-clr" aria-hidden="true"></i></a>');


	$trNew.find("div").each(function () {
		$(this).attr({
			'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); }
		});

	});

	$trNew.find("label").each(function () {
		$(this).attr({
			'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); },
		});
		$(this).html(parseInt($('#tblActivity').find("tbody tr").length) + 1);
	});

	$trNew.find("input").each(function (i) {
		$(this).attr({
			'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
			'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
		});
		$(this).val('0');
	});
	$trNew.find("textarea").each(function (i) {
		$(this).attr({
			'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
			'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
		});
		$(this).val('');
	});
	$trNew.find("select").each(function (i) {
		$(this).attr({
			'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
			'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
		});
		$(this).val('');
	});

	$trNew.find("span").each(function (i) {
		if ($(this).attr("data-valmsg-for")) {
			$(this).attr({
				'data-valmsg-for': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); }
			});
		}
		if ($(this).attr("for")) {
			$(this).attr({
				'for': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); }
			});
		}
	});

	$trLast.after($trNew);
	var form = $("#_SaveDailyLogForm").closest("form");
	form.removeData('validator');
	form.removeData('unobtrusiveValidation');
	$.validator.unobtrusive.parse(form);
	$('[data-toggle="tooltip"]').tooltip();
	$(".applyselect").select2();
}


function DeleteRow(obj) {
	var count = 0;
	var TotalRowCount = $('#tblActivity').find("tbody tr").length;
	ConfirmMsgBox("Are you sure want to delete", '', function () {

		$(obj).closest('tr').remove();
		$("#tblActivity TBODY TR").each(function (i) {
			$(this).closest("tr").find("label").each(function () {
				$(this).attr({
					'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], i); },
				});
				$(this).html(i + 1)
			});

			$(this).closest("tr").find("div").each(function () {
				$(this).attr({
					'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], i); },
				});
			});


			$(this).closest("tr").find("input").each(function () {
				$(this).attr({
					'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
					'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
				});

			});

			$(this).closest("tr").find("select").each(function () {
				$(this).attr({
					'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
					'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
				});

			});

			$(this).closest("tr").find("textarea").each(function () {
				$(this).attr({
					'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
					'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
				});

			});


			$(this).closest("tr").find("span").each(function () {
				if ($(this).attr("data-valmsg-for")) {
					$(this).attr({
						'data-valmsg-for': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
					});
				}
				if ($(this).attr("for")) {
					$(this).attr({
						'for': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
					});
				}
			});
		});
		var form = $("#_SaveDailyLogForm").closest("form");
		form.removeData('validator');
		form.removeData('unobtrusiveValidation');
		$.validator.unobtrusive.parse(form);

	})
}


function CalculateHours(count) {
	var FinalDaysHour = 0;
	$(".dayshours_" + count).each(function (index) {
		FinalDaysHour += parseInt(Number($(this).val()));
	});

	if (FinalDaysHour > 24) {
		swal('Hey! Looks like you are working more than 24 hours in day!', '');
		$(".dayshours_" + count).val("0");
		$(".spnFinalHour_" + count).html("0");
	}
	else {
		$(".spnFinalHour_" + count).html(FinalDaysHour);
	}
}

function ExtraTDwork(MLDay) {
	$(".extratd1").show();
	if (MLDay === 29) {
		$(".extratd1").show();
		$(".extratd2").show();
		$(".extratd3").show();
		$(".extratd4").show();
		$(".extratd5").show();
		$(".extratd6").show();
	}
	else if (MLDay === 30) {
		$(".extratd1").show();
		$(".extratd2").show();
		$(".extratd3").show();
		$(".extratd4").show();
		$(".extratd5").show();
		$(".extratd6").hide();
	}
	else if (MLDay === 31) {
		$(".extratd1").show();
		$(".extratd2").show();
		$(".extratd3").show();
		$(".extratd4").show();
		$(".extratd5").hide();
		$(".extratd6").hide();
	}
	else {
		$(".extratd1").hide();
		$(".extratd2").hide();
		$(".extratd3").hide();
		$(".extratd4").hide();
		$(".extratd5").hide();
		$(".extratd6").hide();
	}
}

function ClicableNextPrevious() {

	$(".workclass").hide();
	$(".weeksection").hide();
	$(".weeksection").first().show();
	for (i = 1; i <= 7; i++) {
		$(".workclass_" + i).show();
	}
	$(".Nextweek").click(function () {
		$('.weeksection').hide();
		$(this).closest('.weeksection').next().show();
		$($(this).closest('.weeksection')).each(function () {
			var start = $(this).find('a.Nextweek').attr("start");
			var end = $(this).find('a.Nextweek').attr("end");
			ExtraTDwork(parseInt(end));
			$(".workclass").hide();
			for (i = parseInt(start); i <= parseInt(end); i++) {
				$(".workclass_" + i).show();
			}
		});

	});

	$(".PrevWeek").click(function () {
		$('.weeksection').hide();
		$(this).closest('.weeksection').prev().show();

		$($(this).closest('.weeksection')).each(function () {
			var start = $(this).find('a.PrevWeek').attr("start");
			var end = $(this).find('a.PrevWeek').attr("end");
			ExtraTDwork(parseInt(end));
			$(".workclass").hide();
			for (i = parseInt(start); i <= parseInt(end); i++) {
				$(".workclass_" + i).show();
			}
		})
	});

}


function AfterOnSuccess(obj) {

	if (obj.Status) {
		if (obj.StatusCode == 0) {
			SuccessToaster(obj.SuccessMessage);
		}
		window.location = obj.RedirectURL;
	}
	else {
		if (obj.StatusCode == 1) {
			swal("Hey! Please verify entries on", obj.SuccessMessage);
		}
		else {

			FailToaster(obj.SuccessMessage);
		}
		CloseLoadingDialog();
	}
}


// Initialize ajax autocomplete:
var countries = new Array();

function GetLatestTask() {
	countries = [];
	$.ajax({
		url: "/CommonAjax/GetSavedTaskJson",
		type: "Get",
		async: true,
		success: function (data) {
			$(data).each(function (i, news) {
				countries.push({

					value: news.Description,
					data: news.Description
				});
			});
		}
	});
}
function GetStandardTask(obj) {
	var ID = $(obj).attr('id');
	$("#" + ID).autocomplete({
		lookup: countries,

		lookupFilter: function (suggestion, originalQuery, queryLowerCase) {
			// use for when check 1st Word is searched world
			//var re = new RegExp('\\b' + $.Autocomplete.utils.escapeRegExChars(queryLowerCase), 'gi');   
			// Search Whole alpabate in string
			var re = new RegExp($.Autocomplete.utils.escapeRegExChars(queryLowerCase), 'gi');
			return re.test(suggestion.value);
		},
		onSelect: function (suggestion) {
			$('#selction-ajax').html('You selected: ' + suggestion.value + ', ' + suggestion.data);
		},
		onHint: function (hint) {
			$('#autocomplete-ajax-x').val(hint);
		},
		onInvalidateSelection: function () {
			$('#selction-ajax').html('You selected: none');
		}
	});
}




function CalculateTotalHours() {
	for (var i = 1; i < 32; i++) {
		var FinalDaysHour = 0;
		$(".dayshours_" + i).each(function (index) {
			FinalDaysHour += parseInt(Number($(this).val()));

		});
		$(".spnFinalHour_" + i).html(FinalDaysHour);
	}
}





function GetHoursSummary() {
	var Month = $("#Month").val();
	$.ajax({
		url: "/Activity/_HoursSummary",
		type: "Get",
		data: {
			src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_HoursSummary" + "*" + Month)
		},
		success: function (data) {
			$(".HoursSummaryTarget").empty();
			$(".HoursSummaryTarget").html(data);

		},
		error: function (er) {
			CloseLoadingDialog();
		}
	});
}


function fnRecall() {
	swal("Write Remarks", {
		text: "Enter Reason For Re-call",
		content: "input",
	}).then(function (result) {
		if (result.trim() != "") {
			$("#RecallRemarks").val(result);
			$("#btnbtnrecall").click();
		}
		else {
			swal("", "Can't be Blank");
		}
	});
}




function GetStandardTaskList() {
	$.ajax({
		url: "/Activity/_StandardTaskList",
		type: "Get",
		data: {
			src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_StandardTaskList")
		},
		success: function (data) {
			$(".StandardTaskList").empty();
			$(".StandardTaskList").html(data);
		},
		error: function (er) {
			CloseLoadingDialog();
		}
	});
}

function DeleteTaskRow(obj) {
	var ID = $(obj).closest("tr").find("input:hidden[name=ST]").val();
	
	ConfirmMsgBox("Are you sure want to delete", '', function () {
		$.ajax({
			url: "/CommonAjax/DeleteProjectEMP_SelfMappingJson",
			type: "Get",
			data: { ID: ID },
			success: function (data) {
				CloseLoadingDialog();
				if (data == 0) {
					swal('', 'There is some problem occured');
				}
				else {
					GetLatestTask();
					GetStandardTaskList();
				}
			},
			error: function (er) {
				CloseLoadingDialog();
			}
		});
	})
}
