$(".btncheckStatus").click(function () {
    GetConsolidateActivityStatus();
});
function GetConsolidateActivityStatus() {
    var Date = $("#Date").val();
    $.ajax({
        url: "/Activity/_ConsolidateActivityCheckStatus",
        type: "Post",
        data: { src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_ConsolidateActivityCheckStatus"), Date: Date },
        success: function (data) {
            $("#DivChkStatusModal").html(data);
            $("#ChkStatusModal").modal('show');
            $("#spnStatusHeader").html("Status of Monthly Activity Log for the Month of " + Date);
            DatatableScriptsWithColumnSearch("tableApprove");
           
        }
    });
}


function GetEmployeeTimeSheet(E, N) {
    var Date = $("#Date").val();
    $.ajax({
        url: "/Activity/_EmployeeTimeSheet",
        type: "Post",
        data: { src: EncryptQueryStringJSON(MenuID + "*" + "/Activity/_EmployeeTimeSheet"), Date: Date, EMPID: E, Type:'C' },
        success: function (data) {
            $("#spnEmployeetimesheet").html(N);
            $("#DivEmployeeTimeSheet").html(data);
            $("#ModalEmployeetimesheet").modal('show');
        }
    });
}

function chkAll() {
    var checkAll = $(".checkAll").is(":checked");
    if (checkAll) {
        $("input[name=Chksingle]").each(function () {
            $(this).prop('checked', true);
        });
    }
    else {
        $("input[name=Chksingle]").each(function () {
            $(this).prop('checked', false);
        });
    }
}
