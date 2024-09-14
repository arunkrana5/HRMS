$(document).ready(function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});

$('#Month').bind("change", function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});
$(".btnbackToDailLog").click(function () {
    ShowLoadingDialog();
    var Month = $("#Month").val();
    var src = EncryptQueryStringJSON(MenuID+"*" + "/Activity/DailyLog*" + Month);
window.location = "/Activity/DailyLog?src=" + src;
         });


function BindTargetAfterSubmit(ogb) {
    if (ogb.Status) {
		window.location = ogb.RedirectURL;
    }
    else {
        FailToaster(ogb.SuccessMessage);
        CloseLoadingDialog();
    }
}

function BindTarget(args) {
   
    $("#TargetDiv").html(args);
    $('[data-toggle="tooltip"]').tooltip();
	var IsSubmitted = $("#IsSubmitted").val();
	if (IsSubmitted == "False") {
		GetHoursSummary();
		$('.hideaftersub').show();
	} else {
		$('.hideaftersub').hide();
	}

	CloseLoadingDialog();


	$(".btnbackToDailLog").click(function () {
		ShowLoadingDialog();
		var Month = $("#Month").val();
		var src = EncryptQueryStringJSON(MenuID + "*" + "/Activity/DailyLog*" + Month);
		window.location = "/Activity/DailyLog?src=" + src;
	});
    //FinallTotal();
   // FinalLeaveTotal();
    //GrandTotal();
}
function FinallTotal() {
    for (i = 1; i <= 31; i++) {
        var FinalDaysHour = 0;
        $(".dayshours_" + i).each(function (index) {
            if ($(this).val() != "" && $(this).val() != undefined) {
                FinalDaysHour += parseInt($(this).val());
            }
        });
        $("#spnFinalHour_" + i).html(FinalDaysHour);
    }
}

function FinalLeaveTotal() {
    for (i = 1; i <= 31; i++) {
        var FinalDaysHour = 0;
        $(".DailyLeaveshours_" + i).each(function (index) {
            if ($(this).val() != "" && $(this).val() != undefined) {
                FinalDaysHour += parseInt($(this).val());
            }
        });
        //FinalDaysHour +=  parseInt($("#spnFinalHour_"+i).html());
        $("#spnLeaveFinalHour_" + i).html(FinalDaysHour);
    }
}


//function GrandTotal() {

//    for (i = 1; i <= 31; i++) {
//        var FinalDaysHour = 0;

//        FinalDaysHour += parseInt($("#spnFinalHour_" + i).html());
//        FinalDaysHour += parseInt($("#spnLeaveFinalHour_" + i).html());

//        $("#spnLGrandTotal_" + i).html(FinalDaysHour);
//        $("#hdnGrandTotal_" + i).val(FinalDaysHour);
//    }

//    var FixGrandTotal = 0;
//    $(".FixGrandTotal").each(function (index) {
//        if ($(this).html() != "" && $(this).html() != undefined) {
//            FixGrandTotal += parseInt($(this).html());
//        }
//    });
//    $("#CompensatoryHours").val(FixGrandTotal);
//}

function Validate() {
    var Ret = false;
    var Msg = "";
    var FixGrandTotal = 0;
    $(".validatehours").each(function (index) {
        if ($(this).html() != "" && $(this).html() != undefined) {
            if (parseInt($(this).html()) < 8 || parseInt($(this).html()) > 24) {
                Msg += this.id.split('_')[1] + ", ";
            }
        }
    });
    if (Msg == "") {
        Ret = true;
    }
    else {
        swal("Working hours can not be less then 8 hours", "Please Verify " + Msg)
    }
    return Ret;
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
        }
    });
}