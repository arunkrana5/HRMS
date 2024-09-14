
using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMaster;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;

public class ClsApplicationSetting
{

    public static string GetWebsiteURL()
    {
        var request = HttpContext.Current.Request;
        var address = string.Format("{0}://{1}", request.Url.Scheme, request.Url.Authority);
        return address;
    }
    public static string GetWebConfigValue(string Key)
    {
        string functionReturnValue = null;
        functionReturnValue = "";
        try
        {
            return ConfigurationManager.AppSettings[Key].ToString();
        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.Write("Key " + Key + "<br>" + ex.Message);
            HttpContext.Current.Response.End();
        }
        return functionReturnValue;

    }


    public static bool SetSessionValue(string SessionName, string SessionValue)
    {
        try
        {
            string CookiesExpireTime = GetWebConfigValue("CookiesExpireTime");
            if (!string.IsNullOrEmpty(CookiesExpireTime))
            {
                HttpContext.Current.Session[SessionName] = SessionValue;
                HttpContext.Current.Session.Timeout = Convert.ToInt32(CookiesExpireTime);

            }
            else
            {
                HttpContext.Current.Session[SessionName] = SessionValue;
            }
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }

    public static string GetSessionValue(string sessionname)
    {
        string SessionValue = null;
        if ((HttpContext.Current.Session[sessionname] != null))
        {
            SessionValue = HttpContext.Current.Session[sessionname].ToString();
        }
        return SessionValue;

    }

    public static bool SetCookiesValue(string CookiesName, string CookiesValue)
    {
        HttpCookie Cook = default(HttpCookie);

        try
        {
            string CookiesExpireTime = GetWebConfigValue("CookiesExpireTime");
            Cook = new HttpCookie(CookiesName, ClsCommon.Encrypt(CookiesValue));
            if (!string.IsNullOrEmpty(CookiesExpireTime))
            {
                Cook.Expires = DateTime.Now.AddMinutes(Convert.ToInt32(CookiesExpireTime));
            }
            else
            {
                Cook.Expires = DateTime.Now.AddDays(1);
            }
            HttpContext.Current.Response.Cookies.Add(Cook);
            HttpContext.Current.Session.Add(CookiesName, CookiesValue);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    public static string GetCookiesValue(string sessionname)
    {
        string SessionValue = null;
        if ((HttpContext.Current.Request.Cookies[sessionname] != null))
        {
            SessionValue = ClsCommon.Decrypt(HttpContext.Current.Request.Cookies[sessionname].Value.ToString());
        }
        return SessionValue;

    }


    public static bool ClearCookiesValue(string SessionName)
    {
        try
        {
            if (HttpContext.Current.Request.Cookies[SessionName] != null)
            {
                HttpContext.Current.Response.Cookies[SessionName].Expires = DateTime.Now.AddDays(-1);
            }

            HttpContext.Current.Session[SessionName] = "";

        }
        catch (Exception ex)
        {
        }
        return true;
    }

    public static bool ClearSessionValues()
    {

        try
        {
            if (HttpContext.Current != null)
            {
                int cookieCount = HttpContext.Current.Request.Cookies.Count;
                for (var i = 0; i < cookieCount; i++)
                {
                    var cookie = HttpContext.Current.Request.Cookies[i];
                    if (cookie != null)
                    {
                        var expiredCookie = new HttpCookie(cookie.Name)
                        {
                            Expires = DateTime.Now.AddDays(-1),
                            Domain = cookie.Domain
                        };
                        HttpContext.Current.Response.Cookies.Add(expiredCookie); // overwrite it
                    }
                }

                // clear cookies server side
                HttpContext.Current.Request.Cookies.Clear();

                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.RemoveAll();
                HttpContext.Current.Session.Abandon();


            }

        }
        catch (Exception ex)
        {
        }
        return true;

    }

    public static bool UpdateCookieValue(string CookieName, string Value)
    {
        CookieName = CookieName.ToUpper();
        HttpCookie cook = new HttpCookie(CookieName, Value);
        HttpContext.Current.Response.Cookies.Add(cook);
        HttpContext.Current.Session[CookieName] = HttpContext.Current.Request.Cookies[CookieName].Value;
        return true;
    }

    public static bool IsSessionExpired(string SessionText)
    {

        bool IsExpired = false;

        //Or HttpContext.Current.Session[SessionText] Is Nothing Then
        if (HttpContext.Current.Session[SessionText] == null || HttpContext.Current.Session[SessionText].ToString() == "")
        {
            IsExpired = true;
        }

        return IsExpired;

    }
    public static bool IsCookiesExpired(string SessionText)
    {

        bool IsExpired = false;

        //Or HttpContext.Current.Session[SessionText] Is Nothing Then
        if (HttpContext.Current.Request.Cookies[SessionText] == null || HttpContext.Current.Request.Cookies[SessionText].ToString() == "")
        {
            IsExpired = true;
        }

        return IsExpired;

    }




    public static string GetPhysicalPath(string pathFor = "")
    {
        string PhysicalPath = GetConfigValue("ApplicationPhysicalPath");
        string InnerPath = "";
        string functionReturnValue = "";
        if (pathFor.ToLower() == "images")
        {
            InnerPath = "/assets/design/images";
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        else if (pathFor.ToLower() == "json")
        {
            InnerPath = "/Attachments/UserDetails/Jsondata";
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;

        }
        else if (pathFor.ToLower() == "import")
        {
            InnerPath = "/Attachments/UserDetails/Importdata";
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;

        }
        else if (pathFor.ToLower() == "billing")
        {
            string DDYear = DateTime.Now.ToString("MMMyyyy");
            InnerPath = "/Attachments/Billing/" + DDYear;
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        else if (pathFor.ToLower() == "helpdesk")
        {
            string DDYear = DateTime.Now.ToString("MMMyyyy");
            InnerPath = "/Attachments/Helpdesk/" + DDYear;
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        else if (pathFor.ToLower() == "onboard")
        {
            string DDYear = DateTime.Now.ToString("MMMyyyy");
            InnerPath = "/Attachments/onboard/" + DDYear;
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        else if (pathFor.ToLower() == "drive")
        {
            InnerPath = "/Attachments/Drive/" + ClsApplicationSetting.GetSessionValue("UserID");
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        else
        {
            InnerPath = "/Attachments";
            if (!Directory.Exists(PhysicalPath + InnerPath))
            {
                Directory.CreateDirectory(PhysicalPath + InnerPath);
            }
            functionReturnValue = PhysicalPath + InnerPath;
        }
        return functionReturnValue;
    }



    public static string AllowedFileSize(string Type)
    {
        double byteCount = 0;
        if (Type == "Image")
        {
            double.TryParse(GetWebConfigValue("AllowedImage_Size"), out byteCount);
        }
        else
        {
            double.TryParse(GetWebConfigValue("AllowedFile_Size"), out byteCount);
        }

        return GetFileSize(byteCount);
    }

    public static string GetFileSize(double byteCount)
    {
        string size = "0 Bytes";
        if (byteCount >= 1073741824.0)
            size = String.Format("{0:##.##}", byteCount / 1073741824.0) + " GB";
        else if (byteCount >= 1048576.0)
            size = String.Format("{0:##.##}", byteCount / 1048576.0) + " MB";
        else if (byteCount >= 1024.0)
            size = String.Format("{0:##.##}", byteCount / 1024.0) + " KB";
        else if (byteCount > 0 && byteCount < 1024.0)
            size = byteCount.ToString() + " Bytes";

        return size;
    }

    public static FileResponse ValidateFile(HttpPostedFileBase File)
    {
        FileResponse obj = new FileResponse();
        try
        {
            obj.FileType = File.ContentType;
            obj.InputStream = File.InputStream;
            obj.FileName = Guid.NewGuid().ToString();
            obj.FileLength = File.ContentLength;
            obj.FileExt = System.IO.Path.GetExtension(File.FileName).ToLower();
            obj.IsValid = true;
            string AIMGExt = GetWebConfigValue("AllowedImage_Ext").ToLower();
            string AFExt = GetWebConfigValue("AllowedFile_Ext").ToLower();
            long AIMGSize, AFSize = 0, AMaxmiumSize = 0;
            long.TryParse(GetWebConfigValue("AllowedImage_Size"), out AIMGSize);
            long.TryParse(GetWebConfigValue("AllowedFile_Size"), out AFSize);
            AMaxmiumSize = (AIMGSize > AFSize ? AIMGSize : AFSize);

            obj.ReadAbleFileSize = GetFileSize(obj.FileLength);
            BinaryReader chkBinary = new BinaryReader(obj.InputStream);
            Byte[] chkbytes = chkBinary.ReadBytes(0x10);
            string data_as_hex = BitConverter.ToString(chkbytes);
            string magicCheck = data_as_hex.Substring(0, 8);
            Dictionary<string, string> MDict = new Dictionary<string, string>();
            MDict = GetMagicNumnberDictionary();
            if (MDict != null && MDict.Count > 0)
            {
                if ((".txt").Contains(obj.FileExt))
                {
                    obj.IsValid = true;
                }
                else if (MDict.ContainsKey(obj.FileExt))
                {
                    if ((".jpg,.jpeg,.png").Contains(obj.FileExt))
                    {
                        obj.IsImage = true;
                        if (MDict[".jpg"].Substring(0, 8).Replace(" ", "-") != magicCheck && MDict[".jpeg"].Substring(0, 8).Replace(" ", "-") != magicCheck && MDict[".png"].Substring(0, 8).Replace(" ", "-") != magicCheck)
                        {
                            obj.IsValid = false;
                            var myKey = MDict.FirstOrDefault(x => x.Value.Contains(magicCheck)).Key;
                            obj.Message = "Please Upload Valid File with Original extension," + (!string.IsNullOrEmpty(myKey) ? "It seems it is " + myKey + " file" : "");
                        }
                    }
                    else if (MDict[obj.FileExt].Substring(0, 8).Replace(" ", "-") != magicCheck)
                    {
                        obj.IsValid = false;
                        var myKey = MDict.FirstOrDefault(x => x.Value.Contains(magicCheck)).Key;
                        obj.Message = "Please Upload Valid File with Original extension," + (!string.IsNullOrEmpty(myKey) ? "It seems it is " + myKey + " file" : "");
                    }
                }
                else if (obj.IsValid)
                {
                    if (!(AIMGExt.Replace("|", ",")).Contains(obj.FileExt))
                    {
                        obj.IsValid = false;
                        obj.Message = "Can't Upload Image Extention Must Be Matched";

                    }
                    else if (!(AFExt.Replace("|", ",")).Contains(obj.FileExt))
                    {
                        obj.IsValid = false;
                        obj.Message = "Can't Upload File Extention Must Be Matched";

                    }
                    if (obj.IsValid)
                    {
                        if ((AIMGExt.Replace("|", ",")).Contains(obj.FileExt) && obj.FileLength > AIMGSize)
                        {
                            obj.IsValid = false;
                            obj.Message = "Can't Upload Image Size Must Be Matched";

                        }
                        else if ((AFExt.Replace("|", ",")).Contains(obj.FileExt) && obj.FileLength > AFSize)
                        {
                            obj.IsValid = false;
                            obj.Message = "Can't Upload File Size Must Be Matched";

                        }
                    }
                }
            }
            else
            {
                obj.IsValid = false;
                obj.Message = "Please Add Magic Number Into .Txt File";
            }
        }
        catch (Exception ex)
        {
            //ClsCommon.LogError("Error during Problem in ValidateFileWithMagicNumber. The query was executed :", ex.ToString(), "", "ClsApplicationSetting", "ClsApplicationSetting", "");
        }
        return obj;
    }

    public static Dictionary<string, string> GetMagicNumnberDictionary()
    {
        Dictionary<string, string> MagicNumnberDictionary = new Dictionary<string, string>();
        try
        {
            string GetPath = HttpContext.Current.Server.MapPath("/Attachments/UserDetails/temp");
            if (!Directory.Exists(GetPath))
            {
                Directory.CreateDirectory(GetPath);
            }
            if (System.IO.File.Exists(GetPath + "/MagicNumber.txt"))
            {
                using (StreamReader r = new StreamReader(GetPath + "/MagicNumber.txt"))
                {
                    string json = r.ReadToEnd();
                    MagicNumnberDictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                }
            }
        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.Write(ex.Message);
            HttpContext.Current.Response.End();
        }

        return MagicNumnberDictionary;
    }



    public static string GetPageName()
    {
        string RR = GetWebConfigValue("ProjectName");
        var ReturnURL = HttpContext.Current.Request.Url.Segments;

        if (ReturnURL.Length > 1)
        {
            RR = RR + ": " + ReturnURL[ReturnURL.Length - 1];
        }
        return RR;
    }
    public static string GetIPAddress()
    {
        return HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
    }
    public static string[] DecryptQueryString(string EncrptredValue)
    {
        long LoginID = 0;
        long.TryParse(GetSessionValue("LoginID"), out LoginID);
        string IPAddress = GetIPAddress();
        string[] MyMenu = null;
        string Value = "";
        try
        {
            if (!string.IsNullOrEmpty(EncrptredValue))
            {
                Value = ClsCommon.Decrypt(EncrptredValue);
                if (Value.Contains("*"))
                {
                    MyMenu = Value.Split('*');
                }
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during DecryptQueryString. The query was executed :", ex.ToString(), EncrptredValue, "ClsApplication", "ClsApplication", LoginID, IPAddress);
        }
        return MyMenu;
    }


    public static bool CreateAllJson()
    {
        bool val = false;
        try
        {
            CreateMenuJSon();
            val = true;
        }
        catch (Exception ex)
        {

        }
        return val;

    }



    public static bool CreateMenuJSon()
    {
        bool myValue = false;
        long LoginID = 0;
        try
        {

            long.TryParse(GetSessionValue("LoginID"), out LoginID);

            string DirectoryName = GetPhysicalPath("json");
            string FileName = DirectoryName + "/AdminMenu.json";
            ToolsModal Tools = new ToolsModal();
            GetResponse modal = new GetResponse();
            modal.IPAddress = GetIPAddress();
            modal.LoginID = LoginID;
            if (File.Exists(FileName))
            {
                File.Delete(FileName);
            }
            using (StreamWriter file = File.CreateText(FileName))
            {
                JsonSerializer serializer = new JsonSerializer();
                serializer.Serialize(file, Tools.GetAdminMenuList(modal));
                myValue = true;
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during CreateMenuJSon. The query was executed :", ex.ToString(), "CreateMenuJSon", "clsApplicationSetting", "clsApplicationSetting", LoginID, GetIPAddress());
        }

        return myValue;
    }

    private static List<AdminMenu> GetMenuJSON()
    {
        string FileName = GetPhysicalPath("json") + "/AdminMenu.json";
        if (!File.Exists(FileName))
        {
            CreateMenuJSon();
        }
        List<AdminMenu> items = new List<AdminMenu>();
        if (File.Exists(FileName))
        {
            using (StreamReader r = new StreamReader(FileName))
            {
                string json = r.ReadToEnd();
                items = JsonConvert.DeserializeObject<List<AdminMenu>>(json);
            }
        }
        return items;
    }



    public static List<AdminModule> GetRoleWiseModuleList(string Type)
    {
        List<AdminModule> CP_LoginModuleList = new List<AdminModule>();
        AdminModule CP_LoginModuleItem;
        string SQL = "";
        long RoleID = 0, LoginID = 0;
        long.TryParse(GetSessionValue("RoleID"), out RoleID);
        long.TryParse(GetSessionValue("LoginID"), out LoginID);
        try
        {
            var jsonModal = GetMenuJSON().Where(x => x.RoleID == RoleID && x.R == true && x.ModuleID != 0).ToList();
            var FilterModule = jsonModal.GroupBy(x => x.ModuleID)
                     .Select(x => new
                     {
                         ModuleID = x.Key,
                         Type = x.Select(ex => ex.Type).FirstOrDefault(),
                         ModuleName = x.Select(ex => ex.ModuleName).FirstOrDefault(),
                         ModuleIcon = x.Select(ex => ex.ModuleIcon).LastOrDefault(),
                         ModulePriority = x.Select(ex => ex.ModulePriority).FirstOrDefault(),
                     })
                     .ToList().OrderBy(x => x.ModuleName).OrderBy(x => x.ModulePriority).ToList();

            if (!string.IsNullOrEmpty(Type))
            {
                FilterModule = jsonModal.GroupBy(x => x.ModuleID)
                     .Select(x => new
                     {
                         ModuleID = x.Key,
                         Type = x.Select(ex => ex.Type).FirstOrDefault(),
                         ModuleName = x.Select(ex => ex.ModuleName).FirstOrDefault(),
                         ModuleIcon = x.Select(ex => ex.ModuleIcon).LastOrDefault(),
                         ModulePriority = x.Select(ex => ex.ModulePriority).FirstOrDefault(),
                     })
                     .ToList().Where(x => x.Type == Type).OrderBy(x => x.ModuleName).OrderBy(x => x.ModulePriority).ToList();
            }

            foreach (var item in FilterModule)
            {
                CP_LoginModuleItem = new AdminModule();
                CP_LoginModuleItem.ModuleID = item.ModuleID;
                CP_LoginModuleItem.Type = item.Type;
                CP_LoginModuleItem.ModuleName = item.ModuleName;
                CP_LoginModuleItem.ModuleIcon = item.ModuleIcon;
                CP_LoginModuleItem.MainMenuList = GetLoginMenuList(item.ModuleID);
                CP_LoginModuleList.Add(CP_LoginModuleItem);
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during GetRoleWiseModuleList. The query was executed :", ex.ToString(), "CP/GetRoleWiseModuleList()", "clsApplicationSetting", "clsApplicationSetting", LoginID, GetIPAddress());
        }
        return CP_LoginModuleList;
    }
    private static List<AdminMenu> GetLoginMenuList(long ModuleID, long ParentMenuID = 0)
    {
        string SQL = "";
        long RoleID = 0, LoginID = 0;
        long.TryParse(GetSessionValue("RoleID"), out RoleID);
        long.TryParse(GetSessionValue("LoginID"), out LoginID);

        List<AdminMenu> CP_LoginMenuList = new List<AdminMenu>();
        AdminMenu CP_LoginMenuItem;
        try
        {
            List<AdminMenu> jsonModal = GetMenuJSON().Where(x => x.RoleID == RoleID && x.R == true && x.ModuleID == ModuleID).ToList();
            jsonModal = jsonModal.Where(x => x.ParentMenuID == ParentMenuID).ToList();
            foreach (AdminMenu item in jsonModal.OrderBy(x => x.MenuName).OrderBy(x => x.Priority).ToList())
            {
                CP_LoginMenuItem = new AdminMenu();
                CP_LoginMenuItem.MenuID = item.MenuID;
                CP_LoginMenuItem.ParentMenuID = item.ParentMenuID;
                CP_LoginMenuItem.ModuleID = item.ModuleID;
                CP_LoginMenuItem.Priority = item.Priority;
                CP_LoginMenuItem.MenuName = item.MenuName;
                CP_LoginMenuItem.MenuURL = item.MenuURL;
                CP_LoginMenuItem.Target = item.Target;
                CP_LoginMenuItem.IsChild = item.IsChild;
                if (item.IsChild == "Y")
                {
                    CP_LoginMenuItem.ChildMenuList = GetLoginMenuList(item.ModuleID, CP_LoginMenuItem.MenuID);
                }

                CP_LoginMenuList.Add(CP_LoginMenuItem);
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during GetLoginMenuList. The query was executed :", ex.ToString(), "GetLoginMenuList", "clsApplicationSetting", "clsApplicationSetting", LoginID, GetIPAddress());
        }
        return CP_LoginMenuList;
    }

    public static PageViewPermission CheckPageViewPermission(string MenuID)
    {
        long RoleID = 0, MID = 0;
        PageViewPermission PageViewPermission = new PageViewPermission();
        try
        {
            if (MenuID == "-2")
            {
                PageViewPermission.ReadFlag = true;
                PageViewPermission.WriteFlag = true;
                PageViewPermission.ModifyFlag = true;
                PageViewPermission.DeleteFlag = true;
                PageViewPermission.ExportFlag = true;
            }
            else
            {
                long.TryParse(GetSessionValue("RoleID"), out RoleID);
                long.TryParse(MenuID, out MID);
                var MenuItems = GetMenuJSON().Where(x => x.RoleID == RoleID && x.MenuID == MID).FirstOrDefault();
                if (MenuItems != null)
                {
                    PageViewPermission.ReadFlag = MenuItems.R;
                    PageViewPermission.WriteFlag = MenuItems.W;
                    PageViewPermission.ModifyFlag = MenuItems.M;
                    PageViewPermission.DeleteFlag = MenuItems.D;
                    PageViewPermission.ExportFlag = MenuItems.E;
                    PageViewPermission.ImportFlag = MenuItems.I;
                    SetSessionValue("Read", PageViewPermission.ReadFlag.ToString());
                    SetSessionValue("Write", PageViewPermission.WriteFlag.ToString());
                    SetSessionValue("Modify", PageViewPermission.ModifyFlag.ToString());
                    SetSessionValue("Delete", PageViewPermission.DeleteFlag.ToString());
                    SetSessionValue("Export", PageViewPermission.ExportFlag.ToString());
                    SetSessionValue("Import", PageViewPermission.ImportFlag.ToString());
                }
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during CheckPageViewPermission. The query was executed :", ex.ToString(), "CheckPageViewPermission", "clsApplicationSetting", "clsApplicationSetting", 0, GetIPAddress());
        }
        return PageViewPermission;
    }

    public static IEnumerable<DateTime> EachDay(DateTime from, DateTime thru)
    {
        for (var day = from.Date; day.Date <= thru.Date; day = day.AddDays(1))
            yield return day;
    }
    public static bool ResizeImage(HttpPostedFileBase fileToUpload, string SavePath, float Width = 1000, float Height = 1000)
    {
        bool isSave = false;
        long LoginID = 0;
        long.TryParse(GetSessionValue("LoginID"), out LoginID);
        string IPAddress = GetIPAddress();
        try
        {
            using (Image image = Image.FromStream(fileToUpload.InputStream, true, false))
            {
                try
                {
                    //Size can be change according to your requirement 
                    float thumbWidth = 1000;
                    float thumbHeight = 1000;
                    //calculate  image  size
                    if (image.Width > image.Height)
                    {
                        thumbHeight = ((float)image.Height / image.Width) * thumbWidth;
                    }
                    else
                    {
                        thumbWidth = ((float)image.Width / image.Height) * thumbHeight;
                    }

                    int actualthumbWidth = Convert.ToInt32(Math.Floor(thumbWidth));
                    int actualthumbHeight = Convert.ToInt32(Math.Floor(thumbHeight));
                    var thumbnailBitmap = new Bitmap(actualthumbWidth, actualthumbHeight);
                    var thumbnailGraph = Graphics.FromImage(thumbnailBitmap);
                    thumbnailGraph.CompositingQuality = CompositingQuality.HighQuality;
                    thumbnailGraph.SmoothingMode = SmoothingMode.HighQuality;
                    thumbnailGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    var imageRectangle = new Rectangle(0, 0, actualthumbWidth, actualthumbHeight);
                    thumbnailGraph.DrawImage(image, imageRectangle);
                    var ms = new MemoryStream();
                    thumbnailBitmap.Save(SavePath, ImageFormat.Jpeg);
                    ms.Position = 0;
                    GC.Collect();
                    thumbnailGraph.Dispose();
                    thumbnailBitmap.Dispose();
                    image.Dispose();
                    isSave = true;
                }
                catch (Exception ex)
                {
                    Common_SPU.LogError("Error during ResizeImage. The query was executed :", ex.ToString(), SavePath, "ClsApplicationSetting", "ClsApplicationSetting", LoginID, IPAddress);

                    throw ex;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return isSave;
    }


    public static PostResponse UploadCameraImage(FileResponse Modal)
    {
        PostResponse result = new PostResponse();
        result.SuccessMessage = "No action Taken";
        string PhysicalPath = "";
        try
        {
            Modal.FileExt = ".jpg";
            Modal.FileName = Guid.NewGuid().ToString();
            byte[] imageBytes = Convert.FromBase64String(Modal.ImageBase64String.Split(',')[1]);


            PhysicalPath = GetPhysicalPath("");
            result = Common_SPU.fnSetProfilePic(Modal);
            PhysicalPath = Path.Combine(PhysicalPath, Modal.FileName + "" + Modal.FileExt);
            File.WriteAllBytes(PhysicalPath, imageBytes);

        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during UploadCameraImage. The query was executed :", ex.ToString(), Modal.Doctype, "ClsApplicationSetting", "ClsApplicationSetting", Modal.LoginID, Modal.IPAddress);
        }
        return result;
    }


    public static PostResponse UploadAttachment(UploadAttachment Modal)
    {
        PostResponse result = new PostResponse();
        result.SuccessMessage = "No action Taken";
        string PhysicalPath = "";
        try
        {
            var rv = ClsApplicationSetting.ValidateFile(Modal.File);
            if (rv.IsValid)
            {
                rv.ID = Modal.AttachID;
                rv.LoginID = Modal.LoginID;
                rv.IPAddress = Modal.IPAddress;
                rv.tableid = Modal.tableid;
                rv.TableName = Modal.TableName;
                rv.Token = Modal.Token;
                rv.Description = Modal.Description;
                if (Modal.Doctype.ToLower() == "onboard")
                {
                    
                    result = Common_SPU.fnSetOnboard_Attachment(rv);
                    PhysicalPath = GetPhysicalPath("onboard");
                    PhysicalPath = Path.Combine(PhysicalPath, rv.FileName + "" + rv.FileExt);
                    if (rv.IsImage)
                    {
                        if (!ResizeImage(Modal.File, PhysicalPath, 1200, 1200))
                        {
                            Modal.File.SaveAs(PhysicalPath);
                        }
                    }
                    else
                    {
                        Modal.File.SaveAs(PhysicalPath);
                    }
                }
                else
                {

                    PhysicalPath = GetPhysicalPath("");
                    result = Common_SPU.fnSetMasterAttachment(rv);
                    PhysicalPath = Path.Combine(PhysicalPath, rv.FileName + "" + rv.FileExt);
                    if (rv.IsImage)
                    {
                        if (!ResizeImage(Modal.File, PhysicalPath, 1200, 1200))
                        {
                            Modal.File.SaveAs(PhysicalPath);
                        }
                    }
                    else
                    {
                        Modal.File.SaveAs(PhysicalPath);

                    }
                }

            }
            else
            {
                result.SuccessMessage = rv.Message;
            }
        }
        catch (Exception ex)
        {
            Common_SPU.LogError("Error during UploadAttachment. The query was executed :", ex.ToString(), Modal.Doctype, "ClsApplicationSetting", "ClsApplicationSetting", Modal.LoginID, Modal.IPAddress);
        }
        return result;
    }

    private static Dictionary<string, string> GetConfigSettingPair()
    {
        List<ConfigSetting> List = new List<ConfigSetting>();
        Dictionary<string, string> obj = new Dictionary<string, string>();

        GetResponse modal = new GetResponse();
        modal.Doctype = "";
        List = Common_SPU.GetConfigSetting(modal);
        foreach (var item in List)
        {
            obj.Add(item.ConfigKey, item.ConfigValue);
        }
        return obj;
    }
    public static string GetConfigValue(string KeyName)
    {
        string ValueType = "";
        if (GetConfigSettingPair().ContainsKey(KeyName))
        {
            ValueType = GetConfigSettingPair()[KeyName];
        }
        return ValueType;
    }


}
