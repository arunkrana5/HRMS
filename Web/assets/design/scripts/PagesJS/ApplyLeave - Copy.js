$(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();
});

function OnLeaveSuccess(obj) {
    if (obj.Status) {
        window.location.reload();
    }
    else {
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

$(".btnApplyLeave").click(function (e) {
    e.preventDefault();
    e.stopPropagation();
    return Validate();
});


$('.txtDate').bind("change", function () {
    if ($(this).val()) {
        HighlightDateCalender();
    }

});


$('.ddleaveType').bind("change", function () {
    ShowLoadingDialog();
    ShowLeaveAttachment();
});


function AddLeaveApplyTable() {
    debugger
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
            url: "/CommonAjax/LeaveRowAdd",
            type: "Get",
            async: true,
            data: { _LeaveTypeID: ddLeaveType, _StartDate: StartDate, _EndDate: EndDate },
            success: function (data) {
                if (data.Status) {
                    $("#tblApplyLeave").empty();
                    $("#tblApplyLeave").html(data.ViewAsString);
                    var form = $("#LeaveRequestForm").closest("form");
                    form.removeData('validator');
                    form.removeData('unobtrusiveValidation');
                    $.validator.unobtrusive.parse(form);

                    $('[data-toggle="tooltip"]').tooltip();
                    $(".applyselect").select2();
                    CloseLoadingDialog();

                    calculatehours();
                    ShowLeaveAttachment();
                    $('.ddleaveType').bind("change", function () {
                        ShowLoadingDialog();
                        ShowLeaveAttachment();
                    });
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
                    swal(data.SuccessMessage, '')
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
    $("#spnTotalHour").html(Total.toFixed(1));
}



function Validate() {
    var result = false;
    var show = 0, AttachCount = 0;
    var LeaveTypeID = $("#LeaveTypeID option:selected").val();
    $('.ddleaveType').each(function (index) {
        if ($(this).find("option:selected").val() == 1) {
            show += 1;
        }
    });
    $('.uploadCertificate').each(function (index) {
        if ($(this).val() != "") {
            AttachCount++;
        }
    });

    if (LeaveTypeID == "1") {
        show = show - 1;
    }
    if (show > 3 && AttachCount == 0) {

        ConfirmMsgBox("Your Current selection is CL/SL Leave", 'Note: To avail it is mandatory to submit Medical and Fitness certificates', function () {
            $("#btnSubmit").click();
        })
    }
    else {
        $("#btnSubmit").click();
    }
    return result;

}

function ShowLeaveAttachment() {
    CloseLoadingDialog();
    var show = 0;
    $('.ddleaveType').each(function (index) {
        if ($(this).find("option:selected").val() == 1) {
            show = 1;
        }
    });

    if (show == 1) {
        $(".divCLSL").show();
    }
    else {
        $(".divCLSL").hide();
    }
}


function AddNewRow() {
   
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
    var form = $("#LeaveRequestForm").closest("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();
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
    ConfirmMsgBox("Are you sure want to delete", '', function () {
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

//function FillLeaveBalance(StartDate) {
//    var src = EncryptQueryStringJSON(MenuID + "*" + "/Leave/_LeaveBalance" + "*" + StartDate);

//    ShowLoadingDialog();
//    $.ajax({
//        url: "/Leave/_LeaveBalance",
//        type: "Get",
//        data: { src: src },
//        success: function (data) {
//            $("#DivLeaveBalance").empty();
//            $("#DivLeaveBalance").html(data);
//            CloseLoadingDialog();
//        },
//        error: function (er) {
//            alert(er);
//        }
//    });
//    CloseLoadingDialog();
//}


//$(window).load(function () {
//    var date = new Date();
//    var d = date.getDate();
//    var m = date.getMonth();
//    var y = date.getFullYear();
//    var started;
//    var categoryClass;

//    var calendar = $('#calendar').fullCalendar({
//        header: {
//            left: 'title',
//            center: false,
//            right: 'prev,next today'
//        },

//        firstDay: 1,
//        events: function (start, end, timezone, callback) {
//            $.ajax({
//                url: '/CommonAjax/GetAllHolidayForCalenedarJson',
//                type: "GET",
//                dataType: "JSON",
//                success: function (result) {

//                    var events = [];
//                    $.each(result, function (i, data) {
//                        events.push(
//                            {
//                                title: data.Name,
//                                start: data.Date,
//                                end: data.Date,
//                                backgroundColor: data.Color,
//                                description: data.Description,
//                                class: data.ClassName,
//                                allDay: true
//                            });
//                    });

//                    callback(events);

//                }
//            });
//        },

//        views: {
//            month: {
//                eventLimit: 1
//            }
//        },
//        eventRender: function (event, element) {
//            element[0].title = event.description;
//            element[0].className = event.class;


//        },
//        viewRender: function (view, element) {
//            var b = $('#calendar').fullCalendar('getDate');

//            FillLeaveBalance(b.toISOString());
//        }
//        //,eventMouseover: function (calEvent, jsEvent) {
//        //    var tooltip = '<div class="tooltipevent" style="width:100px;height:100px;background:#ccc;position:absolute;z-index:10001;">' + calEvent.title + '</div>';
//        //    var $tooltip = $(tooltip).appendTo('body');

//        //    $(this).mouseover(function (e) {
//        //        $(this).css('z-index', 10000);
//        //        $tooltip.fadeIn('500');
//        //        $tooltip.fadeTo('10', 1.9);
//        //    }).mousemove(function (e) {
//        //        $tooltip.css('top', e.pageY + 10);
//        //        $tooltip.css('left', e.pageX + 20);
//        //    });
//        //},

//        //    eventMouseout: function (calEvent, jsEvent) {
//        //        $(this).css('z-index', 8);
//        //        $('.tooltipevent').remove();
//        //    },


//    });



//});