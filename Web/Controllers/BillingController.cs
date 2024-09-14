using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMaster;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web.CommonClass;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.IO;
using System.Net;
using System.IO.Compression;
using System.Runtime.Remoting.Contexts;
using Microsoft.Ajax.Utilities;
using System.Web.UI;
using Syncfusion.Pdf.Graphics;
using Syncfusion.Pdf.Parsing;
using Syncfusion.Pdf;
using Syncfusion.Mvc.Pdf;

namespace Web.Controllers
{
    [CheckLoginFilter]
    public class BillingController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IBillingHelper bill;
        ReportDocument rd;
        public BillingController()
        {

            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            bill = new BillingModal();

        }

        public ActionResult ClientBillingList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            MyTab.Billing result = new MyTab.Billing();
            result.Date = DateTime.Now.ToString("yyyy-MM");

            GetDropDownResponse ddRes = new GetDropDownResponse();
            ddRes.LoginID = LoginID;
            ddRes.IPAddress = IPAddress;
            ddRes.Doctype = "FinancialYear";
            result.FinyearList = Common_SPU.GetDropDownList(ddRes);

            ddRes.Doctype = "ClientList";
            result.ClientList = Common_SPU.GetDropDownList(ddRes);
            result.SubClientList = new List<DropDownlist>();
            return View(result);

        }

        [HttpPost]
        public ActionResult _ClientBillingList(string src, MyTab.Billing Modal)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            ViewBag.Date = Modal.Date;
            return PartialView(bill.GetBillingList(Modal));
        }

        public ActionResult _ClientBillingTranList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.BillID = GetQueryString[2];
            long BillID = 0;
            long.TryParse(ViewBag.BillID, out BillID);
            getResponse.ID = BillID;
            return PartialView(bill.GetBillingTranList(getResponse));
        }

        public ActionResult CreateStaffBill(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.BillID = GetQueryString[2];
            long BillID = 0;
            long.TryParse(ViewBag.BillID, out BillID);
            getResponse.ID = BillID;
            Billing.Create Modal = bill.GetBilling(getResponse);
            return View(Modal);
        }

        [HttpPost]
        public ActionResult _BillingStaff(string src, Billing.Create Modal)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            getResponse.Date = Modal.Date;
            getResponse.Param1 = Modal.ClientCode;
            getResponse.Param2 = Modal.SC_Code;
            getResponse.Param3 = Modal.HSNCode;
            getResponse.Param4 = Modal.Department;
            getResponse.Param5 = Modal.Designation;
            getResponse.Param6 = Modal.StateName;
            getResponse.Param7 = Modal.DealerType;

            Modal = bill.GetBilling_StaffList(getResponse);
            return PartialView(Modal);
        }


        [HttpPost]
        public ActionResult CreateStaffBill(string src, Billing.Create Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.BillID = GetQueryString[2];
            long BillID = 0;
            long.TryParse(ViewBag.BillID, out BillID);
            Modal.BillID = BillID;
            if (((Modal.DocNo_Series ?? 0) == 0) && BillID==0)
            {
                Result.SuccessMessage = "Doc No can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            else if ((Modal.StaffList == null || Modal.StaffList.Count == 0))
            {
                Result.SuccessMessage = "Staff List can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            else if (!Modal.StaffList.Any(x => x.IsChecked != null))
            {
                Result.SuccessMessage = "Please select atleast one checkbox";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            Result.SuccessMessage = "Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Result = bill.fnSetBilling_Staff(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Billing/ClientBillingList?src=" + ClsCommon.Encrypt(ViewBag.MenuID.ToString() + "*/Billing/ClientBillingList");
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        //public ActionResult PrintStaffBilling(string src)
        //{
        //    try
        //    {
        //        ViewBag.src = src;
        //        string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
        //        ViewBag.GetQueryString = GetQueryString;
        //        ViewBag.MenuID = GetQueryString[0];
        //        ViewBag.BillID = GetQueryString[2];
        //        long BillID = 0;
        //        long.TryParse(ViewBag.BillID, out BillID);
        //        System.Data.DataSet _dataSet = new System.Data.DataSet();
        //        getResponse.ID = BillID;
        //        _dataSet = Common_SPU.GetBilling_RPT(getResponse);

        //        if (_dataSet != null)
        //        {
        //            string DocNo = _dataSet.Tables[0].Rows[0]["DocNo"].ToString();
        //            string PhysicalPath = ClsApplicationSetting.GetPhysicalPath("billing");
        //            string FileName = DocNo + "_Invoice.pdf";
        //            rd = new ReportDocument();

        //            List<FileInfo> listFiles = new List<FileInfo>();
        //            ////Billing Print

        //            string _reportPath = Server.MapPath(@"\CrystalReport\StaffBilling.rpt");
        //            rd.Load(_reportPath);
        //            rd.SetDataSource(_dataSet.Tables[0]);
        //            if (System.IO.File.Exists(Path.Combine(PhysicalPath, FileName)))
        //            {
        //                System.IO.File.Delete(Path.Combine(PhysicalPath, FileName));
        //            }
        //            string FilePath = Path.Combine(PhysicalPath, FileName);
        //            rd.ExportToDisk(ExportFormatType.PortableDocFormat, FilePath);
        //            rd.Close();
        //            rd.Dispose();
        //            if (System.IO.File.Exists(FilePath))
        //            {
        //                FileInfo fi = new FileInfo(FilePath);
        //                listFiles.Add(fi);
        //                //byte[] bytes = System.IO.File.ReadAllBytes(FilePath);
        //                //File(bytes, "application/octet-stream", FileName);
        //            }

        //            // Billing Details
        //            FileName = DocNo + "_Details.pdf";

        //            rd = new ReportDocument();
        //            _reportPath = Server.MapPath(@"\CrystalReport\StaffBillingDetails.rpt");
        //            rd.Load(_reportPath);
        //            rd.SetDataSource(_dataSet.Tables[1]);

        //            if (System.IO.File.Exists(Path.Combine(PhysicalPath, FileName)))
        //            {
        //                System.IO.File.Delete(Path.Combine(PhysicalPath, FileName));
        //            }
        //            FilePath = Path.Combine(PhysicalPath, FileName);
        //            rd.ExportToDisk(ExportFormatType.PortableDocFormat, FilePath);
        //            rd.Close();
        //            rd.Dispose();

        //            if (System.IO.File.Exists(FilePath))
        //            {

        //                FileInfo fi = new FileInfo(FilePath);
        //                listFiles.Add(fi);
        //                //byte[] bytes = System.IO.File.ReadAllBytes(FilePath);
        //                //return File(bytes, "application/octet-stream", FileName);
        //            }


        //            using (var ms = new MemoryStream())
        //            {
        //                using (var zip = new ZipArchive(ms, ZipArchiveMode.Create, true))
        //                {
        //                    foreach (var file in listFiles)
        //                    {
        //                        // write zip archive entries
        //                        zip.CreateEntryFromFile(file.FullName, file.Name, CompressionLevel.Optimal);
        //                    }

        //                }
        //                return File(ms.ToArray(), "application/zip", DocNo + "_StaffInvoice.zip");
        //            }
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.NotFound);
        //    }
        //    return new HttpStatusCodeResult(HttpStatusCode.NotFound);

        //}

        public ActionResult EInvoice(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            MyTab.Approval result = new MyTab.Approval();
            result.Month = DateTime.Now.ToString("yyyy-MM");
            return View(result);
        }
        [HttpPost]
        public ActionResult _EInvoice(string src, MyTab.Approval Modal)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            return PartialView(bill.GetEInvoiceReport(Modal));
        }

        public JsonResult PrintStaffBilling(string src)
        {
            List<PostResponse> listFiles = new List<PostResponse>();
            PostResponse _path;
            try
            {
                ViewBag.src = src;
                string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
                ViewBag.GetQueryString = GetQueryString;
                ViewBag.MenuID = GetQueryString[0];
                ViewBag.BillID = GetQueryString[2];
                long BillID = 0;
                long.TryParse(ViewBag.BillID, out BillID);
                PrintBill result = new PrintBill();
                getResponse.ID = BillID;
                result = bill.GetBilling_RPT(getResponse);
                List<PrintBill.BillDetails> MainModal = new List<PrintBill.BillDetails>();
                MainModal.Add(result.Details);


                string PhysicalPath = ClsApplicationSetting.GetPhysicalPath("billing");
                string InnerPath = "/Attachments/Billing/" + DateTime.Now.ToString("MMMyyyy");
                string FileName = "";
                if (result != null)
                {
                    FileName = result.Details.DocNo + "_Invoice.pdf";
                    rd = new ReportDocument();
                    string _reportPath = Server.MapPath(@"\CrystalReport\StaffBilling.rpt");
                    rd.Load(_reportPath);
                    rd.SetDataSource(MainModal);
                    if (System.IO.File.Exists(Path.Combine(PhysicalPath, FileName)))
                    {
                        System.IO.File.Delete(Path.Combine(PhysicalPath, FileName));
                    }
                    string FilePath = Path.Combine(PhysicalPath, FileName);
                    rd.ExportToDisk(ExportFormatType.PortableDocFormat, FilePath);
                    rd.Close();
                    rd.Dispose();
                    if (System.IO.File.Exists(FilePath))
                    {
                        _path = new PostResponse();
                        _path.Path = InnerPath + "/" + FileName;
                        listFiles.Add(_path);
                    }

                    // Billing Details All
                    FileName = result.Details.DocNo + "_All_Staff.pdf";
                    rd = new ReportDocument();
                    _reportPath = Server.MapPath(@"\CrystalReport\StaffBillingDetails.rpt");
                    rd.Load(_reportPath);
                    rd.SetDataSource(result.Details.StaffList);
                    if (System.IO.File.Exists(Path.Combine(PhysicalPath, FileName)))
                    {
                        System.IO.File.Delete(Path.Combine(PhysicalPath, FileName));
                    }
                    FilePath = Path.Combine(PhysicalPath, FileName);
                    rd.ExportToDisk(ExportFormatType.PortableDocFormat, FilePath);
                    rd.Close();
                    rd.Dispose();
                    if (System.IO.File.Exists(FilePath))
                    {
                        _path = new PostResponse();
                        _path.Path = InnerPath + "/" + FileName;
                        listFiles.Add(_path);
                    }
                    if (result.Details.StaffList.Select(x => x.DealerType).Distinct().ToList().Count() > 1)
                    {
                        foreach (string item in result.Details.StaffList.Select(x => x.DealerType).Distinct().ToList())
                        {
                            FileName = result.Details.DocNo + "_" + item.Replace(" ","_") + "_Staff.pdf";
                            rd = new ReportDocument();
                            _reportPath = Server.MapPath(@"\CrystalReport\StaffBillingDetails.rpt");
                            rd.Load(_reportPath);
                            rd.SetDataSource(result.Details.StaffList.Where(x => x.DealerType == item).ToList());
                            if (System.IO.File.Exists(Path.Combine(PhysicalPath, FileName)))
                            {
                                System.IO.File.Delete(Path.Combine(PhysicalPath, FileName));
                            }
                            FilePath = Path.Combine(PhysicalPath, FileName);
                            rd.ExportToDisk(ExportFormatType.PortableDocFormat, FilePath);
                            rd.Close();
                            rd.Dispose();
                            if (System.IO.File.Exists(FilePath))
                            {
                                _path = new PostResponse();
                                _path.Path = InnerPath + "/" + FileName;
                                listFiles.Add(_path);
                            }
                        }
                    }


                    //using (var ms = new MemoryStream())
                    //{
                    //    using (var zip = new ZipArchive(ms, ZipArchiveMode.Create, true))
                    //    {
                    //        foreach (var file in listFiles)
                    //        {
                    //            zip.CreateEntryFromFile(file.FullName, file.Name, CompressionLevel.Optimal);
                    //        }

                    //    }
                    //    return File(ms.ToArray(), "application/zip", result.Details.DocNo + "_StaffInvoice.zip");
                    //}
                }

            }
            catch (Exception ex)
            {

            }
            return Json(listFiles, JsonRequestBehavior.AllowGet);

        }

        protected string ResolveApplicationDataPath(string fileName)
        {
            //Data folder path is resolved from requested page physical path.
            
            
            string InnerPath = Server.MapPath(@"/Attachments/Billing/" + DateTime.Now.ToString("MMMyyyy"));

            string dataPath = new System.IO.DirectoryInfo(InnerPath).FullName;
            return string.Format("{0}\\{1}", dataPath, fileName);
        }
       

        public ActionResult MergeDocuments(string src)
        {

            string InsideBrowser= "", OptimizeResources= "OptimizeResources", DocNo;
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            DocNo = GetQueryString[2];
            Stream stream1 = new FileStream(ResolveApplicationDataPath(DocNo + "_GT_Staff.pdf"), FileMode.Open, FileAccess.Read);
            Stream stream2 = new FileStream(ResolveApplicationDataPath(DocNo + "_MT_Staff.pdf"), FileMode.Open, FileAccess.Read);
            Stream stream3 = new FileStream(ResolveApplicationDataPath(DocNo + "_All_Staff.pdf"), FileMode.Open, FileAccess.Read);


            //Load the documents as streams
            PdfLoadedDocument doc1 = new PdfLoadedDocument(stream1);
            PdfLoadedDocument doc2 = new PdfLoadedDocument(stream2);
            PdfLoadedDocument doc3 = new PdfLoadedDocument(stream3);

            object[] dobj = { doc1, doc2, doc3 };
            PdfDocument doc = new PdfDocument();

            if (OptimizeResources == "OptimizeResources")
            {
                PdfMergeOptions mergeOption = new PdfMergeOptions();
                mergeOption.OptimizeResources = true;
                PdfDocument.Merge(doc, mergeOption, dobj);
            }
            else
            {
                PdfDocument.Merge(doc, dobj);
            }

            if (InsideBrowser == "Browser")
                return doc.ExportAsActionResult(DocNo+"_Summary.pdf", HttpContext.ApplicationInstance.Response, HttpReadType.Open);
            else
                return doc.ExportAsActionResult(DocNo+ "_Summary.pdf", HttpContext.ApplicationInstance.Response, HttpReadType.Save);
        }



    }
}
