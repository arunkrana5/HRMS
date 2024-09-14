




$(".ConfirmAmendBtn").on('click', function (e) {
	e.preventDefault();
	e.stopPropagation();
	ConfirmMsgBox("Warning", 'Are you sure want to amend this ?', function () {
		$("#btnAmend").click();
	})
});

function OnCreateMPRSuccess(objsss) {
    if (objsss.Status) {

        SuccessToaster(objsss.SuccessMessage);
        window.location.href = objsss.RedirectURL;
       
    }
    else {
        CloseLoadingDialog();
        FailToaster(objsss.SuccessMessage);
    }

}




$('.bindSectionApprover').bind("change", function () {
    SetSectionApproved(this);
});


function SetSectionApproved(obj) {
    var Valname = "";
    var ValID = $(obj).find("option:selected").val();
    if (ValID != "")
    {
      Valname = $(obj).find("option:selected").text();
    }
    
    var SID = $(obj).attr("sid");
    var secname = $(obj).closest("tr").find(".secname").html();
    $("." + SID).val(ValID);
    $(".span" + SID).html(Valname);
    
}



$(".MainSection").on('click', function (e) {
	var chk = $(this).is(":checked");
	var SecID = $(this).attr('sec');
	if (chk) {
		$(".parent_" + SecID).each(function () {
			$(this).prop('checked', true);
			BindChild(this);
		});
	}
	else {
		$(".parent_" + SecID).each(function () {
			$(this).prop('checked', false);
			BindChild(this);
		});
	}

	$(".ParentSection").on('click', function (e) {
		var SecID = $(this).attr('Sec');
		BindChild(this);
	});

});

$(".ParentSection").on('click', function (e) {
	var SecID = $(this).attr('Sec');
	BindChild(this);
});

function BindChild(obj) {
	var subchk = $(obj).is(":checked");
	var subsec = $(obj).attr('subsec');
	if (subchk) {
		$(".child_" + subsec).each(function () {
			$(this).prop('checked', true)
		});
	} else {
		$(".child_" + subsec).each(function () {
			$(this).prop('checked', false)
		});
	}
}


$(".ApplyQuickSelection").on('click', function (e) {
	e.preventDefault();
	e.stopPropagation();
	ApplyQuickSelection();
});

function ApplyQuickSelection()
{
	
	var E1 = Number($("#ddE1 option:selected").val());
	var E2 = Number($("#ddE2 option:selected").val());
	var SA = Number($("#ddSA option:selected").val());
	

	if (E1>0) {
		$(".Executor1").each(function () {
			$(this).val(E1);
			$(this).trigger("change");
		});
	}
	if (E2>0) {
		$(".Executor2").each(function () {
			$(this).val(E2);
			$(this).trigger("change");
			//$(this).select2("val", E2);
		});
	}
	
	if (SA>0)
	{
		$(".bindSectionApprover").each(function () {
			//$(this).select2("val", SA);
			$(this).val(SA);
			$(this).trigger("change");
		});
		var Secname = $("#ddSA option:selected").text();
		$(".spanApproverName").each(function () {
			$(this).html(Secname);
		});
	}
	$("#QuickSelection").modal('hide');

}

$("#chkAll").on('click', function (e) {
    var chk = $(this).is(":checked");
	if (chk) {
		$("#myIndicatorTable").find("input[type=checkbox]").prop('checked', true);
    }
	else {
		$("#myIndicatorTable").find("input[type=checkbox]").prop('checked', false);
	}
});

//$(".MainSection").on('click', function (e) {
//    var chk = $(this).is(":checked");
//	var SecID = $(this).attr('sec');
//	if (chk) {
//		$(".parent_" + SecID).each(function () {
//			$(this).prop('checked', true);
//			BindChild(SecID);
//		});
//    }
//	else {
//		$(".parent_" + SecID).each(function () {
//			$(this).prop('checked', false);
//			BindChild(SecID);
//		});
//	}
	
//	$(".ParentSection").on('click', function (e) {
//		var SecID = $(this).attr('Sec');
//		BindChild(SecID);
//	});
	
//});

//$(".ParentSection").on('click', function (e) {
//	var SecID = $(this).attr('Sec');
//	BindChild(SecID);
//});

//function BindChild(SecID) {
//    var subchk = $(".parent_" + SecID).is(":checked");
//	var subsec = $(".parent_" + SecID).attr('subsec');
//    if (subchk) {
//        $(".child_" + subsec).each(function () {
//            $(this).prop('checked', true)
//        });
//    } else {
//        $(".child_" + subsec).each(function () {
//            $(this).prop('checked', false)
//        });
//    }
//}
