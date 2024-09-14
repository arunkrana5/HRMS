$(document).ready(function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});

$('#Month').bind("change", function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});

function BindTarget(args) {
    CloseLoadingDialog();
    $("#TargetDiv").html(args);
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();
    var form = $("#_SaveDailyLogForm").closest("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);


    $("#btnAddproject").click(function () {
        GetAddProjectList();
    });
    ClicableNextPrevious();
    $("#btnAddTask").click(function () {
        CreateStandardTask();
    });
    GetLatestTask();

    $("#btnsubmit").click(function (e) {
        e.preventDefault();
        if (Validate()) {
            ShowLoadingDialog();
            var Month = $("#Month").val();
            var src = EncryptQueryStringJSON(MenuID + "*" + "/Activity/MonthlyActiveLog*" + Month);

            window.location = "/Activity/MonthlyActiveLog?src=" + src;
        }
    });

    $(".btnrequestforCO").click(function (e) {
        ShowRequestForComOFf();
    });

    CalculateTotalHours();
    $("#btnsave").click(function (e) {
        e.preventDefault();
        var a = $("#hdnLeaveWithAttachmentPending").val();
        if (a > 0) {
            var msg1 = 'Medical certificates and fitness certificate is pending for ' + a+' leave requests';
            var msg2 = 'If you want to proceed, CL/SL leave type will be changed to annual leave/LWP as per available balance';
            ConfirmMsgBox(msg1, msg2, function () {
                $("#BtnFinalSave").click();
            });
        }
        else {
            $("#BtnFinalSave").click();
        }
        
    });
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

                }
                else {
                    $("#poptask").modal('hide');
                    swal('Saved Successfully', '');
                    GetLatestTask()

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
    $trNew.find("td:last").html('<a onclick="DeleteRow(this)" class="remove"><i class="fas fa-window-close red-clr" aria-hidden="true"></i></a>');


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
        swal('', 'Total Hours can not be greater than 24 Hours');
        $(".dayshours_" + count).val("0");
        $(".spnFinalHour_" + count).html("0");
    }
    else {
        $(".spnFinalHour_" + count).html(FinalDaysHour);
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

            $(".workclass").hide();
            for (i = parseInt(start); i <= parseInt(end); i++) {
                $(".workclass_" + i).show();
            }
        })
    });

}


function AfterOnSuccess(obj) {
    if (obj.StatusCode == 1) {
        window.location.reload();
    }
    else {
        swal('', obj.SuccessMessage);
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


function Validate() {
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
        swal("Working hours can not be less then 8 hours", "Please Verify Below Dates " + Msg);
    }
    return Ret;
}