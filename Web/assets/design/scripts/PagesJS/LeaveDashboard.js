var MyAttachment = $("#MyAttachment").val();
var TeamAttachment = $("#TeamAttachment").val();

if (MyAttachment)
{
	AutoClickMyAttachmentTab();
}
if (TeamAttachment) {
	AutoClickMyTeamAttachmentTab();
}
function AutoClickMyTeamAttachmentTab() {
	$('.ulmyteam').each(function () {
		var $this = $(this);
		if ($this.find('li.item').length > 0) {
			var tabindex = $(this).closest("ul").attr("tabclick");
			if (tabindex)
			{
				$(".TeamUlTabs #tab" + tabindex).click();
				return false;
			}
		}
		
	});
}

function AutoClickMyAttachmentTab() {
	$('.ulmyattach').each(function () {
		var $this = $(this);
		if ($this.find('li.item').length > 0) {
			var tabindex = $(this).closest("ul").attr("tabclick");
			if (tabindex) {
				$(".myUltabs #tab" + tabindex).click();
				return false;
			}
		}

	});
}

$('.anchorApproved').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var L = $(this).closest("div").find("input:hidden[name=L]").val();
    var Doc = $(this).closest("div").find("input:hidden[name=DocNo]").val();
    ApprovedLeave(L, Doc, this);
});

function ApprovedLeave(leaveLogID, Doc,obj) {
    ConfirmMsgBox('Are you sure?', '', function () {
        $.ajax({
            url: "/CommonAjax/ApprovedLeaveRequestJSON",
            type: "Post",
            async: true,
            data: { leaveLogID: leaveLogID },
            success: function (data) {
                if (data.Status) {
                    window.location.reload();
                    SuccessToaster(data.SuccessMessage);
                }
                else if (!data.Status && data.StatusCode === 1)
                {
                    $(obj).closest('div').find('a.anchorpopup').click();
                    FailToaster(data.SuccessMessage);
                }
                else {
                    FailToaster(data.SuccessMessage);
                }
            },
            error: function (er) {
                alert(er);
            }
        });
    });
}


$('.RFCRequest').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
	var L = $(this).closest("div").find("input:hidden[name=L]").val();
	$("#hdnLeaveID").val(L);
	$("#RFCPopupModal").modal('show');
    //AskForRemarks(L)
});


$('#btnRR').on('click', function (e) {
	e.preventDefault();
	e.stopPropagation();
	var L = $("#hdnLeaveID").val();
	var R = $("#txtRFCReason").val();
	if (R.trim() != "") {
		RFCLeaveRequest(L, R);
	} else {
		swal("", "Reason can't be blank");
	}
});
//function AskForRemarks(L) {
//    swal("Why do you want to cancel", {
//		content: "input",
//		confirmButtonText: "V redu",
//		allowOutsideClick: "true" 
//    })
//        .then((value) => {
//            if (value.trim() != "") {
//                SyncConfirmBox('Warning', "Are you sure you want to process?", funOk, funCan)
//                function funOk() {
//                    RFCLeaveRequest(L, value);
//                }
//                function funCan() {
//                    SyncCloseDialog();
//                }
//            }
//            else {
//                swal("", "Can't be Blank");
//            }
           

//        });
//}

function RFCLeaveRequest(leaveLogID, Remarks) {
	ShowLoadingDialog();
        $.ajax({
            url: "/CommonAjax/RFCLeaveRequestJSON",
            type: "Get",
            async: true,
            data: { leaveLogID: leaveLogID, RFCRemarks: Remarks },
            success: function (data) {
                if (data) {
                    window.location.reload();
                }
                else {
					FailToaster('Can not give this request');
					CloseLoadingDialog();
                }
            },
            error: function (er) {
                alert(er);
            }
    });
}


$('.deleteRequest').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var L = $(this).closest("div").find("input:hidden[name=L]").val();
    DeleteLeaveLog(L);
});

function DeleteLeaveLog(leaveLogID) {
    ConfirmMsgBox('This will permanently delete your request', '', function () {
        $.ajax({
            url: "/CommonAjax/DeleteLeaveLogJSON",
            type: "Get",
            async: true,
            data: { leaveLogID: leaveLogID },
            success: function (data) {
                if (data) {
                    window.location.reload();
                }
                else {
                    FailToaster('Can not delete this request');
                }
            },
            error: function (er) {
                alert(er);
            }
        });
    });
}

$('.anchorpopup').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var E = $(this).closest("div").find("input:hidden[name=E]").val();
    var L = $(this).closest("div").find("input:hidden[name=L]").val();
    var D = $(this).closest("div").find("input:hidden[name=D]").val();
    GetLeaveDetailsPartial(E, L, D);

});

function GetLeaveDetailsPartial(EMPID, ID, Date) {
    $.ajax({
        url: "/Leave/_ViewLeaveDetails",
        type: "Get",
        data: {
            src: EncryptQueryStringJSON(MenuID + "*" + "/Leave/_ViewLeaveDetails*" + EMPID + "*" + ID + "*" + Date)
        },
        success: function (data) {
            $("#ModalTargetDiv").empty();
            $("#ModalTargetDiv").html(data);
            $("#LeaveModal").modal('show');
           
            var form = $("form #SetLeaveApprovalStatus")
                .removeData("validator")
                .removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(form);
            $('[data-toggle="tooltip"]').tooltip();

        },
        error: function (er) {
            alert(er);

        }
    });
}

function ResponseLeaveAppproval(obj) {

    if (obj.Status) {
        window.location.reload();
    } else {
        swal(obj.SuccessMessage, '');
    }

}


$('#aTeamLeaveRequestAttach').on('click', function (e) {
    ShowLoadingDialog();
    $.ajax({
        url: "/CommonAjax/MyTeamLeaveAttachmentJSON",
        type: "Get",
        success: function (data) {
            window.location.reload();
        },
        error: function (er) {
            
            CloseLoadingDialog();
        }
    });

});
$('#aLeaveRequestAttach').on('click', function (e) {
    ShowLoadingDialog();
    $.ajax({
        url: "/CommonAjax/MyLeaveAttachmentJSON",
        type: "Get",
        success: function (data) {
            window.location.reload();
        },
        error: function (er) {
            alert(er);
            CloseLoadingDialog();

        }
    });

});

$('.aLeaveAttachment').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var LApproved = $(this).closest("div").find("input:hidden[name=AR]").val();
    var LID = $(this).closest("div").find("input:hidden[name=L]").val();
    var DocNo = $(this).closest("div").find("input:hidden[name=DocNo]").val();
    var LE = $(this).closest("div").find("input:hidden[name=LE]").val();
    var EC = $(this).closest("div").find("input:hidden[name=EC]").val();
    var EN = $(this).closest("div").find("input:hidden[name=EN]").val();
    ViewleaveAttachment(LID, LApproved, DocNo, LE, EC, EN);
});

function ViewleaveAttachment(LeaveID, Approved, Doc, LE, ECode, EName) {
    ShowLoadingDialog();
    var AttachmentType = ["Medical", "Fitness"];
    var VisibleDelete = false;
    var VisibleAdd = false;
    if (Approved == 1 && LE == "Y") {
        VisibleAdd = true;
    }
    var pram = {
        src: EncryptQueryStringJSON(MenuID + "*" + "/Master/_MasterAttachmentController*"),
        TableID: LeaveID,
        TableName: 'ApplyLeave',
        FileType: 'Images',
        ViewFileName: ECode+'-'+Doc,
        AttachmentType: AttachmentType,
        VisibleDelete: VisibleDelete,
        VisibleAdd: VisibleAdd
    }

    $.ajax({
        url: "/Master/_MasterAttachmentController",
        traditional: true,
        type: "Get",
        data: pram,
        success: function (data) {
            $("#LeaveAttachmentTarget").empty();
            $("#LeaveAttachmentTarget").html(data);
          
            $("#ModalLeaveAttachment span.spnhead").html(LeaveID);
            $("#ModalLeaveAttachment").modal('show');

            $("#ModalLeaveAttachment").modal({
                backdrop: 'static',
                keyboard: false
            });

            $(".applyselect").select2();
            var form = $("#AddAttachmentFrom")
                .removeData("validator")
                .removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(form);
            CloseLoadingDialog();
        },
        error: function (er) {
            alert(er);
            CloseLoadingDialog();

        }
    });
}

$('#ModalLeaveAttachment').on('hidden.bs.modal', function () {
    ShowLoadingDialog();
    window.location.reload(true);
});

