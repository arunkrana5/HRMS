function ShowLoadingDialog() {
    document.getElementById("global-loader").style.display = '';
}
function CloseLoadingDialog() {

    document.getElementById("global-loader").style.display = 'none';
}

$("form").attr('autocomplete', 'off');

function EncryptJSON(value) {

    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/EncryptJSON',
        dataType: "json",
        data: { Value: value },
        async: false
    }).responseText);
    return data;

}
function DecryptQueryStringJSON(value) {

    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/DecryptQueryStringJSON',
        dataType: "json",
        data: { Value: value },
        async: false
    }).responseText);
    return data;

}


function GetDropDownList(ID, Doctype) {
    var dataObject = JSON.stringify({
        'Values': ID,
        'Doctype': Doctype
    });
    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/GetDropDownListJson',
        dataType: "json",
        contentType: 'application/json',
        type: "Post",
        data: dataObject,
        async: false
    }).responseText);
    return data;

}

function GetCheckRecordExist(ID, Doctype, Value) {
    var dataObject = JSON.stringify({
        'ID': ID,
        'Value': Value,
        'Doctype': Doctype
    });
    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/GetCheckRecordExistJson',
        dataType: "json",
        contentType: 'application/json',
        type: "Post",
        data: dataObject,
        async: false
    }).responseText);
    return data;

}

function DelRecordJson(ID, Doctype) {
    var dataObject = JSON.stringify({
        'ID': ID,
        'Doctype': Doctype
    });
    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/DelRecordJson',
        dataType: "json",
        contentType: 'application/json',
        type: "Post",
        data: dataObject,
        async: false
    }).responseText);
    return data;

}


function ConfirmMsgBox(Title, Message, yesCallback) {
    swal({
        title: Title,
        text: Message,
        icon: "warning",
        buttons: true,
        dangerMode: true,
    }).then((willDelete) => {
        if (willDelete) { yesCallback(); }
        else { }
    });
}
