$('.anchorApproved').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var L = $(this).closest("div").find("input:hidden[name=L]").val();
    var Doc = $(this).closest("div").find("input:hidden[name=Doc]").val();
    ApprovedLeave(L, Doc, this);
});

function ApprovedLeave(leaveLogID, Doc,obj) {
    ConfirmMsgBox('Are you sure, you want to Approved Leave (' + Doc + ') ?', '', function () {
        $.ajax({
            url: "/CommonAjax/ApprovedLeaveRequestJSON",
            type: "Post",
            async: true,
            data: { leaveLogID: leaveLogID },
            success: function (data) {
                if (data.Status) {
                    SuccessToaster(data.SuccessMessage);
                    removeLi(data.ID);
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



$('.aLeaveAttachment').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var LApproved = $(this).closest("div").find("input:hidden[name=AR]").val();
    var LID = $(this).closest("div").find("input:hidden[name=L]").val();
    var DocNo = $(this).closest("div").find("input:hidden[name=DocNo]").val();
    var LE = $(this).closest("div").find("input:hidden[name=LE]").val();
    ViewleaveAttachment(LID, LApproved, DocNo, LE);
});

function ViewleaveAttachment(LeaveID, Approved, Doc, LE) {
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