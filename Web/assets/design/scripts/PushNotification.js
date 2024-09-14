

//$(document).ready(function () {
//    setInterval(function () {
//        GetRecentPushNotification();
//    }, 30000);
//});  


function GetRecentPushNotification() {
    var Category = "";
        $.ajax({
            url: "/CommonAjax/GetPushNotificationListJSON",
            type: "Get",
            async: true,
			data: { ListType: "Layout" },
            success: function (data) {
                GetRecentPushNotificationCallBack(data);
            },
            error: function (er) {
              
            }
        });
}

function GetRecentPushNotificationCallBack(args)
{
    var ApprovaltabulHTML = "";
    var ConfirmationtabHTML = "";
    var InfotabHTML = "";
    var ApprovalCount = 0;
    var ConfirmationCount = 0;
    var InfoCount = 0;
    var count = 0;
    var TopMessage = "";
    $.each(args, function (k, v) {
        count++;
       
        if (this.Status == "Approved" || this.Status == "Rejected")
        {
            $.notify(this.MessageContent, "success");
            ConfirmationCount++;

            ConfirmationtabHTML += "<li class='list-group-item d-flex justify-content-between align-items-center'>";
            ConfirmationtabHTML += "<a href='#' class='ripplelink'>";
            ConfirmationtabHTML += "<div class='c-media align-items-center'>";
            ConfirmationtabHTML += " <div class='c-media__avatar '><span><i class='fas fa-suitcase'></i></span></div>";
            ConfirmationtabHTML += "<div class='c-media__content sz-sm'>" + this.CreatedDate + "<h5 class='sz-sm'><strong> " + this.Subject + "</strong></h5>";
            ConfirmationtabHTML += "<p> <strong>Status:</strong> <i class='far fa-clock red-clr'></i>" + this.Status + "</p>";
            ConfirmationtabHTML += "<span class='red-clr-bg count-nt'></span></div></div></a></li>";

            
        }
        else if (this.Status == "Pending")
        {
            $.notify(this.MessageContent, "warn");
            ApprovalCount++;

            ApprovaltabulHTML += "<li class='list-group-item d-flex justify-content-between align-items-center'>";
            ApprovaltabulHTML += "<a href='#' class='ripplelink'>";
            ApprovaltabulHTML += "<div class='c-media align-items-center'>";
            ApprovaltabulHTML += " <div class='c-media__avatar '><span><i class='fas fa-suitcase'></i></span></div>";
            ApprovaltabulHTML += "<div class='c-media__content sz-sm'>" + this.CreatedDate + "<h5 class='sz-sm'><strong> " + this.Subject + "</strong></h5>";
            ApprovaltabulHTML += "<p> <strong>Status:</strong> <i class=" + (this.Status == 'Approved' ? 'fas fa-check green-clr' : 'far fa-clock red-clr') + "></i>" + this.Status + "</p>";
            ApprovaltabulHTML += "<span class='red-clr-bg count-nt'></span></div></div></a></li>";
        }
        else
        {
            $.notify(this.MessageContent, "error");
            InfoCount++;

            InfotabHTML += "<li class='list-group-item d-flex justify-content-between align-items-center'>";
            InfotabHTML += "<a href='#' class='ripplelink'>";
            InfotabHTML += "<div class='c-media align-items-center'>";
            InfotabHTML += " <div class='c-media__avatar '><span><i class='fas fa-suitcase'></i></span></div>";
            InfotabHTML += "<div class='c-media__content sz-sm'>" + this.CreatedDate + "<h5 class='sz-sm'><strong> " + this.Subject + "</strong></h5>";
            InfotabHTML += "<p> <strong>Status:</strong> <i class='far fa-clock red-clr'></i>" + this.Status + "</p>";
            InfotabHTML += "<span class='red-clr-bg count-nt'></span></div></div></a></li>";  
           
        }
        ClearRecentNotification(this.NotificationID);
    });
    if (ApprovaltabulHTML != "")
    {
        if ($(".Approvaltab ul li").hasClass('no-data')) {
            $(".Approvaltab ul li").remove();
            $(".Approvaltab ul").append(ApprovaltabulHTML);
        }
        else {
            $(".Approvaltab ul li:first").append(ApprovaltabulHTML);
        }
        $("#spnApprovalCount").html(parseInt($("#spnApprovalCount").html()) + ApprovalCount);
    }
    if (ConfirmationtabHTML != "")
    {
        if ($(".Confirmationtab ul li").hasClass('no-data')) {
            $(".Confirmationtab ul li").remove();
            $(".Confirmationtab ul").append(ConfirmationtabHTML)
        }
        else {
            $(".Confirmationtab ul li:first").append(ConfirmationtabHTML)
        }
        $("#spnConfirmationCount").html(parseInt($("#spnConfirmationCount").html()) + ConfirmationCount);
    }
    if (InfotabHTML != "")
    {
        if ($(".Infotab ul li").hasClass('no-data')) {
            $(".Infotab ul li").remove();
            $(".Infotab ul").append(InfotabHTML)
        }
        else {
            $(".Infotab ul li:first").append(InfotabHTML)
        }

       
        $("#spnInfoCount").html(parseInt($("#spnInfoCount").html()) + InfoCount);
    }

    $("#spnMainTotalCount").html(parseInt($("#spnMainTotalCount").html()) +count);
   
}

function ClearRecentNotification(ID) {
    $.ajax({
        url: "/CommonAjax/ClearRecentNotificationJSON",
        type: "Get",
        async: true,
        data: { ID: ID },
        success: function (data) {
       
        },
        error: function (er) {
         
        }
    });
}


