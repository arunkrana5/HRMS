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
    public class MastersController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IMasterHelper Master;
        IToolHelper Tools;
        public MastersController()
        {
            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            Master = new MasterModal();
            Tools = new ToolsModal();
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

        [HttpPost]
        public ActionResult SaveMasterAll(string src, Masters.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.MasterID = GetQueryString[2];
            long MasterID = 0;
            long.TryParse(ViewBag.MasterID, out MasterID);
            Result.SuccessMessage = "Masters Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.MasterID = MasterID;
                Result = Master.fnSetMasters(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult DepartmentList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Department.List> result = new List<Department.List>();
            result = Master.GetDepartmentList(getResponse);
            return View(result);
        }
        public ActionResult _DepartmentAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DeptID = GetQueryString[2];
            long DeptID = 0;
            long.TryParse(ViewBag.DeptID, out DeptID);
            getResponse.ID = DeptID;
            Department.Add result = new Department.Add();
            if (DeptID > 0)
            {
                result = Master.GetDepartment(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _DepartmentAdd(string src, Department.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DeptID = GetQueryString[2];
            long DeptID = 0;
            long.TryParse(ViewBag.DeptID, out DeptID);
            Result.SuccessMessage = "Department Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.DeptID = DeptID;
                Result = Master.fnSetDepartment(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Masters/DepartmentList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/Masters/DepartmentList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }



        public ActionResult DesignationList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];

            List<Designation.List> result = new List<Designation.List>();
            result = Master.GetDesignationList(getResponse);
            return View(result);
        }
        public ActionResult _DesignationAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DesignID = GetQueryString[2];
            long DesignID = 0;
            long.TryParse(ViewBag.DesignID, out DesignID);
            getResponse.ID = DesignID;
            Designation.Add result = new Designation.Add();
            if (DesignID > 0)
            {
                result = Master.GetDesignation(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _DesignationAdd(string src, Designation.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DesignID = GetQueryString[2];
            long DesignID = 0;
            long.TryParse(ViewBag.DesignID, out DesignID);
            Result.SuccessMessage = "Designation Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.DesignID = DesignID;
                Result = Master.fnSetDesignation(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Masters/DesignationList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/Masters/DesignationList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }


        public ActionResult ClientsList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Clients.List> result = new List<Clients.List>();
            result = Master.GetMaster_ClientsList(getResponse);
            return View(result);
        }
        public ActionResult _ClientsAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.ClientID = GetQueryString[2];
            long ClientID = 0;
            long.TryParse(ViewBag.ClientID, out ClientID);
            getResponse.ID = ClientID;
            Clients.Add result = new Clients.Add();
            if (ClientID > 0)
            {
                result = Master.GetMaster_Clients(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _ClientsAdd(string src, Clients.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            long ClientID = 0;
            long.TryParse(ViewBag.ClientID, out ClientID);
            
            Result.SuccessMessage = "Clients Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.ClientID = ClientID;
                Result = Master.fnSetClients(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Masters/ClientsList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/Masters/ClientsList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }


        public ActionResult ClientsTranList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.ClientID = GetQueryString[2];
            long ClientID = 0;
            long.TryParse(ViewBag.ClientID, out ClientID);
            getResponse.ID = 0;
            getResponse.AdditionalID = ClientID;
            List<ClientsTran.List> result = new List<ClientsTran.List>();
            result = Master.GetMaster_ClientsTranList(getResponse);
            return View(result);
        }
        public ActionResult _ClientsTranAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.ClientID = GetQueryString[2];
            ViewBag.ClientTranID = GetQueryString[3];
            long ClientID = 0, ClientTranID=0;
            long.TryParse(ViewBag.ClientID, out ClientID);
            long.TryParse(ViewBag.ClientTranID, out ClientTranID);
            getResponse.ID = ClientTranID;
            getResponse.AdditionalID = ClientID;
            ClientsTran.Add result = new ClientsTran.Add();
            if (ClientTranID > 0)
            {
                result = Master.GetMaster_ClientsTran(getResponse);
            }

            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "CountryList";
            result.CountryList = Common_SPU.GetDropDownList(ddRes);

            ddRes.Doctype = "StateList";
            result.StateList = Common_SPU.GetDropDownList(ddRes);

            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _ClientsTranAdd(string src, ClientsTran.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.ClientID = GetQueryString[2];
            ViewBag.ClientTranID = GetQueryString[3];
            long ClientID = 0, ClientTranID = 0;
            long.TryParse(ViewBag.ClientID, out ClientID);
            long.TryParse(ViewBag.ClientTranID, out ClientTranID);
            Result.SuccessMessage = "Clients Tran Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.ClientID = ClientID;
                Modal.ClientTranID = ClientTranID;
                Result = Master.fnSetMaster_ClientsTran(Modal);

            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Masters/ClientsTranList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/Masters/ClientsList*"+ ClientID);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }



        public ActionResult CountryList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Country.List> result = new List<Country.List>();
            result = Master.GetCountryList(getResponse);
            return View(result);
        }
        public ActionResult _CountryAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CountryID = GetQueryString[2];
            long CountryID = 0;
            long.TryParse(ViewBag.CountryID, out CountryID);
            getResponse.ID = CountryID;
            Country.Add result = new Country.Add();
            if (CountryID > 0)
            {
                result = Master.GetCountry(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _CountryAdd(string src, Country.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CountryID = GetQueryString[2];
            long CountryID = 0;
            long.TryParse(ViewBag.CountryID, out CountryID);
            Result.SuccessMessage = "Country Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.CountryID = CountryID;
                Result = Master.fnSetCountry(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }


        public ActionResult RegionList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<Region.List> result = new List<Region.List>();
            result = Master.GetRegionList(getResponse);
            return View(result);
        }
        public ActionResult _RegionAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.RegionID = GetQueryString[2];
            long RegionID = 0;
            long.TryParse(ViewBag.RegionID, out RegionID);
            getResponse.ID = RegionID;
            Region.Add result = new Region.Add();
            if (RegionID > 0)
            {
                result = Master.GetRegion(getResponse);
            }
            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "CountryList";
            result.CountryList = Common_SPU.GetDropDownList(ddRes);
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _RegionAdd(string src, Region.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.RegionID = GetQueryString[2];
            long RegionID = 0;
            long.TryParse(ViewBag.RegionID, out RegionID);
            Result.SuccessMessage = "Region Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.RegionID = RegionID;
                Result = Master.fnSetRegion(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult StateList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<State.List> result = new List<State.List>();
            result = Master.GetStateList(getResponse);
            return View(result);
        }
        public ActionResult _StateAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.StateID = GetQueryString[2];
            long StateID = 0;
            long.TryParse(ViewBag.StateID, out StateID);
            getResponse.ID = StateID;
            State.Add result = new State.Add();
            if (StateID > 0)
            {
                result = Master.GetState(getResponse);
            }
            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "RegionList";
            result.RegionList = Common_SPU.GetDropDownList(ddRes);
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _StateAdd(string src, State.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.StateID = GetQueryString[2];
            long StateID = 0;
            long.TryParse(ViewBag.StateID, out StateID);
            Result.SuccessMessage = "Region Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.StateID = StateID;
                Result = Master.fnSetState(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }


        public ActionResult CityList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            List<City.List> result = new List<City.List>();
            result = Master.GetCityList(getResponse);
            return View(result);
        }
        public ActionResult _CityAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CityID = GetQueryString[2];
            long CityID = 0;
            long.TryParse(ViewBag.CityID, out CityID);
            getResponse.ID = CityID;
            City.Add result = new City.Add();
            if (CityID > 0)
            {
                result = Master.GetCity(getResponse);
            }
            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "StateList";
            result.StateList = Common_SPU.GetDropDownList(ddRes);
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _CityAdd(string src, City.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.CityID = GetQueryString[2];
            long CityID = 0;
            long.TryParse(ViewBag.CityID, out CityID);
            Result.SuccessMessage = "City Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.CityID = CityID;
                Result = Master.fnSetCity(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult DealerTypeList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            return View(Master.GetDealerTypeList(getResponse));
        }

        public ActionResult _DealerTypeAdd(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DealerTypeID = GetQueryString[2];
            long DealerTypeID = 0;
            long.TryParse(ViewBag.DealerTypeID, out DealerTypeID);
            DealerType.Add result = new DealerType.Add();
            getResponse.ID = DealerTypeID;
            if (DealerTypeID > 0)
            {
                result = Master.GetDealerType(getResponse);
            }
            return PartialView(result);
        }

        [HttpPost]
        public ActionResult _DealerTypeAdd(string src, DealerType.Add Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.DealerTypeID = GetQueryString[2];
            long DealerTypeID = 0;
            long.TryParse(ViewBag.DealerTypeID, out DealerTypeID);
            Result.SuccessMessage = "Type Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.DealerTypeID = DealerTypeID;
                Result = Master.fnSetDealerType(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }


    }
}