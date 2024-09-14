
function OnLeaveSuccess(obj)
{
    if (obj.Status) {
        SuccessToaster(obj.SuccessMessage);
        window.location.href = obj.RedirectURL;
    }
    else {
        CloseLoadingDialog();
        FailToaster(obj.SuccessMessage);
    }
}

$(".btnOk").on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    AddLeaveApplyTable();
});

$('.btnAddRow').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    AddNewRow();
});
$('.deleterow').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    DeleteRow(this);
});


$('.txtDate').bind("change", function () {
    if ($(this).val()) {
        HighlightDateCalender();
    }
});


function AddLeaveApplyTable() {
    $('.notifyjs-wrapper').trigger('notify-hide');
    var ddLeaveType = $("#LeaveTypeID :selected").val();
    var StartDate = $("#StartDate").val();
    var EndDate = $("#EndDate").val();

    if (ddLeaveType == "") {
        $.notify($("#LeaveTypeID"), "Kindly Select Leave Type", "error");
        $("#LeaveTypeID").focus();
    }
    else if (StartDate == "") {
        $.notify($("#StartDate"), "Start Date Can't Be Blank", "error");
        $("#StartDate").focus();
    }
    else if (EndDate == "") {
        $.notify($("#EndDate"), "End Date Can't Be Blank", "error");
        $("#EndDate").focus();
    }
    else {
        ShowLoadingDialog();
        $.ajax({
            url: "/Leave/_ApplyLeaveTran",
            type: "Get",
            data: { src: EncryptJSON("-2*/Leave/_ApplyLeaveTran*" + ddLeaveType + "*" + StartDate + "*" + EndDate)},
            success: function (data) {
                if (data) {
                    $("#TableTran").empty();
                    $("#TableTran").html(data);
                    
                    var form = $("#LeaveRequestForm").closest("form");
                    form.removeData('validator');
                    form.removeData('unobtrusiveValidation');
                    $.validator.unobtrusive.parse(form);

                    $('[data-toggle="tooltip"]').tooltip();
                    $(".applyselect").select2();
                    CloseLoadingDialog();
                    calculatehours();
                    $('.deleterow').on('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        DeleteRow(this);
                    });
                    $('.txthours').bind("change", function () {
                        calculatehours();
                    });
                    HighlightDateCalender();
                    $('.txtDate').bind("change", function () {
                        if ($(this).val()) {
                            HighlightDateCalender();
                        }

                    });

                }
                else {
                    CloseLoadingDialog();
					swal(data.SuccessMessage, '');
                    $("#TableTran").empty();
                }

            },
            error: function (er) {
                CloseLoadingDialog();
                swal('', 'Something went wrong')

            }
        });

    }
}

function HighlightDateCalender() {
    $('[class*="fc-daygrid-day"]').removeClass('highlighteddate')
    $("#tblApplyLeave TBODY TR").each(function (i) {
        var textvalue = $(this).find("td:eq(1) input").val();
        if (textvalue) {
            var mydate = new Date(textvalue)
            var dateString = moment(mydate).format('YYYY-MM-DD');
            $('[class*="fc-daygrid-day"]').filter(function () {
                return $(this).attr('data-date') === dateString;
            }).addClass('highlighteddate');
        }
    });
}

function calculatehours() {
    var Total = 0
    $(".txthours").each(function () {
        var current = Number($(this).val());
        Total += parseFloat(current);
        if (current > 8) {
            $.notify($(this), "Leave Hours Can't Be Greater than 8 Hours", "error");
            $(this).focus();
            $(this).val('');
        }
    });
    $("#spnTotalHour").html(Total.toFixed(0));
}


function AddNewRow() {
    debugger
    var LastTRCount = parseInt($('#tblApplyLeave').find("tbody tr").length) - 1;
    $('.applyselect').select2("destroy");
    var $tableBody = $('#tblApplyLeave').find("tbody"),
        $trLast = $tableBody.find("tr:last"),
        $trNew = $trLast.clone();
    $trNew.find("td:last").html('<a class="deleterow"><span class="close">X</span></a>');

    $trNew.find("label").each(function () {
        $(this).attr({
            'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); },
        });
        $(this).html(parseInt($('#tblApplyLeave').find("tbody tr").length) + 1);
    });
    $trNew.find("input").each(function (i) {
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
    $(".applyselect").select2();
    var form = $("#LeaveRequestForm").closest("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);
    $('[data-toggle="tooltip"]').tooltip();

    $('.deleterow').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        DeleteRow(this);
    });
    calculatehours();
    $('.txthours').bind("change", function () {
        calculatehours();
    });
    $('.txtDate').bind("change", function () {
        if ($(this).val()) {
            HighlightDateCalender();
        }

    });
}


function DeleteRow(obj) {
    var count = 0;
    var TotalRowCount = $('#tblApplyLeave').find("tbody tr").length;
    ConfirmMsgBox("Are you sure want to delete this row", '', function () {
        $(obj).closest('tr').remove();
        $("#tblApplyLeave TBODY TR").each(function (i) {
            $(this).closest("tr").find("label").each(function () {
                $(this).attr({
                    'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], i); },
                });
                $(this).html(i + 1)
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
        var form = $("#LeaveRequestForm").closest("form");
        form.removeData('validator');
        form.removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse(form);
        calculatehours();
    })
}

$('#EndDate').change(function () {
	AutomateProcess();
})  


$('#StartDate').change(function () {
	AutomateProcess();
})  


$('#LeaveTypeID').change(function () {
	AutomateProcess();
})  

function AutomateProcess() {
	var E = $('#EndDate').val();
	var S = $('#StartDate').val();
	var DD = $('#LeaveTypeID').find("option:selected").val();
	if (E != "" && S != "" && DD != "") {
		$(".btnOk").click();
	}
}
