using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMaster;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web.CommonClass;

namespace Web.Controllers
{
    [CheckLoginFilter]
    public class HelpDeskController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IHelpDeskHelper help;

        public HelpDeskController()
        {

            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            help = new HelpDeskModal();

        }
        public string RenderRazorViewToString(string viewName, object model)
        {
            ViewData.Model = model;
            using (var sw = new StringWriter())
            {
                var viewResult = ViewEngines.Engines.FindPartialView(ControllerContext,
                                                                         viewName);
                var viewContext = new ViewContext(ControllerContext, viewResult.View,
                                             ViewData, TempData, sw);
                viewResult.View.Render(viewContext, sw);
                viewResult.ViewEngine.ReleaseView(ControllerContext, viewResult.View);
                return sw.GetStringBuilder().ToString();
            }
        }
        public ActionResult CategoryList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Helpdesk.Category.List> result = new List<Helpdesk.Category.List>();
            result = help.GetHelpdesk_CategoryList(getResponse);
            return View(result);
        }
        public ActionResult _CategoryAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CategoryID = GetQueryString[2];
            long CategoryID = 0;
            long.TryParse(ViewBag.CategoryID, out CategoryID);
            getResponse.ID = CategoryID;
            Helpdesk.Category.Add result = new Helpdesk.Category.Add();
            if (CategoryID > 0)
            {
                result = help.GetHelpdesk_Category(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _CategoryAdd(string src, Helpdesk.Category.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CategoryID = GetQueryString[2];
            long CategoryID = 0;
            long.TryParse(ViewBag.CategoryID, out CategoryID);
            Result.SuccessMessage = "Category Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.CategoryID = CategoryID;
                Result = help.fnSetHelpdesk_Category(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/HelpDesk/CategoryList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/HelpDesk/CategoryList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult SubCategoryList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Helpdesk.SubCategory.List> result = new List<Helpdesk.SubCategory.List>();
            result = help.GetHelpdesk_SubCategoryList(getResponse);
            return View(result);
        }
        public ActionResult _SubCategoryAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.SubCategoryID = GetQueryString[2];
            long SubCategoryID = 0;
            long.TryParse(ViewBag.SubCategoryID, out SubCategoryID);
            getResponse.ID = SubCategoryID;
            Helpdesk.SubCategory.Add result = new Helpdesk.SubCategory.Add();
            result = help.GetHelpdesk_SubCategory(getResponse);

            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _SubCategoryAdd(string src, Helpdesk.SubCategory.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.SubCategoryID = GetQueryString[2];
            long SubCategoryID = 0;
            long.TryParse(ViewBag.SubCategoryID, out SubCategoryID);
            Result.SuccessMessage = "Sub Category Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.SubCategoryID = SubCategoryID;
                Result = help.fnSetHelpdesk_SubCategory(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/HelpDesk/SubCategoryList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/HelpDesk/SubCategoryList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }



        public ActionResult StatusList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Helpdesk.Status.List> result = new List<Helpdesk.Status.List>();
            result = help.GetHelpdesk_StatusList(getResponse);
            return View(result);
        }
        public ActionResult _StatusAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.StatusID = GetQueryString[2];
            long StatusID = 0;
            long.TryParse(ViewBag.StatusID, out StatusID);
            getResponse.ID = StatusID;
            Helpdesk.Status.Add result = new Helpdesk.Status.Add();
            if (StatusID > 0)
            {
                result = help.GetHelpdesk_Status(getResponse);
            }

            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _StatusAdd(string src, Helpdesk.Status.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.StatusID = GetQueryString[2];
            long StatusID = 0;
            long.TryParse(ViewBag.StatusID, out StatusID);
            Result.SuccessMessage = "Status Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.StatusID = StatusID;
                Result = help.fnSetHelpdesk_Status(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/HelpDesk/StatusList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/HelpDesk/StatusList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult MyTicketsList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            MyTab.Approval Modal = new MyTab.Approval();
            Modal.Approved = 1;
            return View(Modal);
        }
        public ActionResult _MyTicketsList(string src, MyTab.Approval Modal)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            List<Helpdesk.Ticket.List> Result = new List<Helpdesk.Ticket.List>();
            Result = help.GetHelpdesk_Tickets_List(Modal);
            return PartialView(Result);

        }

        //public ActionResult HelpdeskImageUpload(IEnumerable<HttpPostedFileBase> files)
        //{
        //    List<PostResponse> listFiles = new List<PostResponse>();
        //    PostResponse _path;

        //    string PhysicalPath = ClsApplicationSetting.GetPhysicalPath("HelpdeskTemp");
        //    foreach (var file in files)
        //    {
        //        if (file.ContentLength > 0)
        //        {
        //            var FileName = ClsApplicationSetting.GetSessionValue("LoginID")+"_"+ DateTime.Now.ToString("ddMMMyyyy");
        //            var path= Path.Combine(PhysicalPath, FileName);
        //            if (System.IO.File.Exists(path))
        //            {
        //                System.IO.File.Delete(path);
        //            }
        //            file.SaveAs(path);
        //        }
        //    }
        //    return Json(listFiles, JsonRequestBehavior.AllowGet);
        //}
        public ActionResult CreateTicket(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Helpdesk.Ticket.Add Modal = new Helpdesk.Ticket.Add();

            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "Helpdesk_CategoryList";
            Modal.CategoryList = Common_SPU.GetDropDownList(ddRes);

            ddRes.Doctype = "UserList";
            Modal.UserList = Common_SPU.GetDropDownList(ddRes);

            Modal.SubCategoryList = new List<DropDownlist>();


            Modal.Upload = new List<HttpPostedFileBase>();
            return View(Modal);
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult CreateTicket(string src, Helpdesk.Ticket.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Result.SuccessMessage = "Action Can't Update";
            string PhysicalPath = ClsApplicationSetting.GetPhysicalPath("helpdesk");
            string guid= Guid.NewGuid().ToString();
            if (string.IsNullOrEmpty(Modal.Message))
            {
                Result.SuccessMessage = "Message can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            if (ModelState.IsValid)
            {
                if (Modal.Upload != null)
                {
                    foreach (var item in Modal.Upload)
                    {
                        Helpdesk.Attachment attachModal = new Helpdesk.Attachment();
                        attachModal.FileName= Guid.NewGuid().ToString();
                        attachModal.TempID = guid;
                        attachModal.contenttype= System.IO.Path.GetExtension(item.FileName).ToLower();
                        string path = Path.Combine(PhysicalPath, attachModal.FileName + "" + attachModal.contenttype);
                        attachModal.IPAddress = IPAddress;
                        attachModal.LoginID = LoginID;
                        item.SaveAs(path);
                        var Attach = Common_SPU.fnSetHelpdesk_Attachments(attachModal);
                        if (!Attach.Status)
                        {
                            Result.SuccessMessage = Attach.SuccessMessage;
                            return Json(Result, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.TempID = guid;
                Result = help.fnSetHelpdesk_Ticket(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/HelpDesk/MyTicketsList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/HelpDesk/MyTicketsList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }
        public ActionResult TicketDetails(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.TicketID = GetQueryString[2];
            long TicketID = 0;
            long.TryParse(ViewBag.TicketID, out TicketID);

            getResponse.ID = TicketID;
            Helpdesk.Ticket.Details result = new Helpdesk.Ticket.Details();
            result = help.GetHelpdesk_Ticket_Details(getResponse);
            return View(result);
        }

        public ActionResult _NotesAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.TicketID = GetQueryString[2];
            long TicketID = 0;
            long.TryParse(ViewBag.TicketID, out TicketID);
            getResponse.ID = TicketID;
            Helpdesk.Notes.Add result = new Helpdesk.Notes.Add();
            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "Helpdesk_NotesStatus_List";
            result.StatusList = Common_SPU.GetDropDownList(ddRes);

            ddRes.Values = TicketID.ToString();
            ddRes.Doctype = "Helpdesk_UserList";
            result.UserList = Common_SPU.GetDropDownList(ddRes);
            result.Upload = new List<HttpPostedFileBase>();
            return PartialView(result);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult _NotesAdd(string src, Helpdesk.Notes.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.TicketID = GetQueryString[2];
            long TicketID = 0;
            long.TryParse(ViewBag.TicketID, out TicketID);
            Result.SuccessMessage = "Action Can't Update";
            string PhysicalPath = ClsApplicationSetting.GetPhysicalPath("helpdesk");
            string guid = Guid.NewGuid().ToString();

            if (string.IsNullOrEmpty(Modal.Notes))
            {
                Result.SuccessMessage = "Notes can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            if (ModelState.IsValid)
            {
                if (Modal.Upload != null)
                {
                    foreach (var item in Modal.Upload)
                    {
                        Helpdesk.Attachment attachModal = new Helpdesk.Attachment();
                        attachModal.FileName = Guid.NewGuid().ToString();
                        attachModal.TempID = guid;
                        attachModal.TicketID = TicketID;
                        attachModal.contenttype = System.IO.Path.GetExtension(item.FileName).ToLower();
                        attachModal.IPAddress = IPAddress;
                        attachModal.LoginID = LoginID;
                        string path = Path.Combine(PhysicalPath, attachModal.FileName + "" + attachModal.contenttype);
                        item.SaveAs(path);
                        var Attach = Common_SPU.fnSetHelpdesk_Attachments(attachModal);
                        if (!Attach.Status)
                        {
                            Result.SuccessMessage = Attach.SuccessMessage;
                            return Json(Result, JsonRequestBehavior.AllowGet);
                        }
                    }
                }

                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.TicketID = TicketID;
                Modal.TempID = guid;
                if (Modal.StatusID !=3)
                {
                    Modal.UserID = 0;
                }
                Result = help.fnSetHelpdesk_Ticket_Notes(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/HelpDesk/TicketDetails?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/HelpDesk/TicketDetails*"+ TicketID);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

    }
}