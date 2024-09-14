
using DataAccess.CommanClass;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;

namespace Web
{
    public static class HTMLHelper
    {
        public static string Version = ClsApplicationSetting.GetWebConfigValue("Version");
        public static MvcHtmlString IncludeVersionedJs(this HtmlHelper helper, string filename)
        {
            return MvcHtmlString.Create("<script type='text/javascript' src='" + filename + "?v=" + Version + "'></script>");
        }
        public static MvcHtmlString IncludeVersionedCss(this HtmlHelper helper, string filename)
        {
            return MvcHtmlString.Create("<link href='" + filename + "?v=" + Version + "' rel='stylesheet' />");

        }
        public static MvcHtmlString CreateImage(this HtmlHelper helper, string Link, string alt = "", string ClassName = "")
        {
            string path = "";
            ClassName = (string.IsNullOrEmpty(ClassName) ? "" : "class=\"" + ClassName + "\"");
            alt = (string.IsNullOrEmpty(alt) ? "" : "alt=\"" + alt + "\"");
            path = ClsApplicationSetting.GetPhysicalPath("Images") + "\\" + Link;
            try
            {
                if (!System.IO.File.Exists(path))
                {
                    path = path + "/NoImage.png";
                }
            }
            catch (Exception ex)
            {
                path = path + "/NoImage.png";
            }

            return MvcHtmlString.Create("<img src='" + path + "?v=" + Version + "' " + ClassName + " " + alt + " />");
        }

        public static MvcHtmlString CreateAnchor(this HtmlHelper helper, string MenuID, string Link, string Text)
        {
            Link = (string.IsNullOrEmpty(MenuID) ? Link : Link + "?src=" + ClsCommon.Encrypt(MenuID + "*" + Link));
            return MvcHtmlString.Create("<a href='" + Link + "'>" + Text + "</a>");
        }
        public static MvcHtmlString CreateAnchor(this HtmlHelper helper, string MenuID, string Link, string Text, string ClassName)
        {
            Link = (string.IsNullOrEmpty(MenuID) ? Link : Link + "?src=" + ClsCommon.Encrypt(MenuID + "*" + Link));
            return MvcHtmlString.Create("<a class=\"" + ClassName + "\" href='" + Link + "'>" + Text + "</a>");
        }
        public static MvcHtmlString CreateAnchor(this HtmlHelper helper, string MenuID, string Link, string Text, string ClassName, string Tooltip)
        {
            Link = (string.IsNullOrEmpty(MenuID) ? Link : Link + "?src=" + ClsCommon.Encrypt(MenuID + "*" + Link));
            Tooltip = (string.IsNullOrEmpty(Tooltip) ? "" : "data-toggle='tooltip' data-original-title=\"" + Tooltip + "\"");
            return MvcHtmlString.Create("<a target=\"" + Tooltip + "\" class=\"" + ClassName + "\" href='" + Link + "'>" + Text + "</a>");
        }
        public static MvcHtmlString CreateAnchor(this HtmlHelper helper, string MenuID, string Link, string Text, string ClassName, string Tooltip, string Target)
        {
            Link = (string.IsNullOrEmpty(MenuID) ? Link : Link + "?src=" + ClsCommon.Encrypt(MenuID + "*" + Link));
            Tooltip = (string.IsNullOrEmpty(Tooltip) ? "" : "data-toggle='tooltip' data-original-title=\"" + Tooltip + "\"");
            return MvcHtmlString.Create("<a " + Tooltip + " target=\"" + Target + "\" class=\"" + ClassName + "\" href='" + Link + "'>" + Text + "</a>");
        }
        public static MvcHtmlString CreateAnchor(this HtmlHelper helper, string MenuID, string Link, string Text, string ClassName, string Tooltip, string FAIcons, string Target)
        {
            Link = (string.IsNullOrEmpty(MenuID) ? Link : Link + "?src=" + ClsCommon.Encrypt(MenuID + "*" + Link));
            Tooltip = (string.IsNullOrEmpty(Tooltip) ? "" : "data-toggle='tooltip' data-original-title=\"" + Tooltip + "\"");
            Text = (string.IsNullOrEmpty(FAIcons) ? Text : "<i class=\"" + FAIcons + "\" aria-hidden='true'></i> " + Text);
            return MvcHtmlString.Create("<a " + Tooltip + " target=\"" + Target + "\" class=\"" + ClassName + "\" href='" + Link + "'>" + Text + "</a>");
        }


        public static MvcHtmlString CreateTooltip(this HtmlHelper helper, string ClassName, string Text)
        {
            return MvcHtmlString.Create("<i class=\"" + ClassName + "\" data-toggle='tooltip' data-original-title=\"" + Text + "\" ></i>");
        }
        public static MvcHtmlString CreateTooltip(this HtmlHelper helper, string ClassName, string Text, string Name)
        {
            return MvcHtmlString.Create("<i class=\"" + ClassName + "\"  data-toggle='tooltip' data-original-title=\"" + Text + "\" >" + Name + "</i>");
        }


        public static MvcHtmlString CreateColorPopHover(this HtmlHelper helper, string ID, string ClassName, List<(string, string)> LiList)
        {
            ClassName = (string.IsNullOrEmpty(ClassName) ? "" : "class=\"" + ClassName + "\"");
            string innerHTML = "<i " + ClassName + " data-popover-content='#" + ID + "' data-toggle='popover' data-placement='right'></i>";
            innerHTML += "<div id='" + ID + "' style='display: none'>";
            innerHTML += "<div class='popover-body'>";
            innerHTML += "<button type='button' class='popover-close close'><i class='fas fa-times'></i></button>";
            innerHTML += "<ul class='colorwheel list-unstyled'>";
            if (LiList != null)
            {
                foreach (var item in LiList)
                {
                    innerHTML += "<li><span class=\"triangle-dgn " + item.Item2 + "\"></span>" + item.Item1 + "</li>";
                }
            }
            innerHTML += "</ul></div></div>";
            return MvcHtmlString.Create(innerHTML);
        }


        //public static MvcHtmlString ShowAttachment(this HtmlHelper helper, string AttachmentID, string ClassName = "")
        //{

        //    string IsbyteImage = ApplicationSetting.GetWebConfigValue("WantImagesInBytes");
        //    long Attach = 0; string path = "", Name = "", alt = "", content_type = "";
        //    ClassName = (string.IsNullOrEmpty(ClassName) ? "" : "class=\"" + ClassName + "\"");
        //    alt = (string.IsNullOrEmpty(alt) ? "" : "alt=\"" + alt + "\"");
        //    long.TryParse(AttachmentID, out Attach);
        //    path = ApplicationSetting.GetPhysicalPath("Attachments")+"\\";
        //    if (Attach != 0)
        //    {
        //        DataSet ds = new DataSet();
        //        ds = Common_SPU.fnGetAttachmentList(Attach, "", "");
        //        foreach (DataRow item in ds.Tables[0].Rows)
        //        {
        //            AttachmentID = item["ID"].ToString();
        //            Name = item["filename"].ToString();
        //            content_type = item["content_type"].ToString();
        //        }
        //        path += AttachmentID + content_type;
        //    }
        //    else
        //    {
        //        path = HttpContext.Current.Server.MapPath("~/assets/design/images/NoImage.png");
        //    }
        //    if (!System.IO.File.Exists(path))
        //    {
        //        path = HttpContext.Current.Server.MapPath("~/assets/design/images/NoImage.png");
        //    }

        //    if ((".jpg,.jpeg,.png,.gif").Contains(content_type.ToLower()))
        //    {
        //        if (IsbyteImage == "Y")
        //        {
        //            byte[] byteData = System.IO.File.ReadAllBytes(path);
        //            string imreBase64Data = Convert.ToBase64String(byteData);
        //            path = string.Format("data:image/png;base64,{0}", imreBase64Data);
        //        }
        //        else
        //        {
        //            path = clsApplicationSetting.ReverseMapPath(path);
        //        }
        //        return MvcHtmlString.Create("<img src='" + path + "' " + ClassName + " " + alt + " />");
        //    }
        //    else
        //    {
        //        return MvcHtmlString.Create("<a target='_blank' href=\"/Download/" + Attach+ "\"   " + ClassName + "><i class='fa fa-paperclip'></i> "+ Name + "</a>");
        //    }

        //}


        public static string ReverseMapPath(string Path)
        {
            string szRoot = HttpContext.Current.Server.MapPath("~");

            if (Path.StartsWith(szRoot))
            {
                return ("/" + Path.Replace(szRoot, string.Empty).Replace(@"\", "/"));
            }
            return ("");
        }


        public static MvcHtmlString GetImage(this HtmlHelper helper, string Path, string alt = "", string ClassName = "")
        {
            Path = ClsApplicationSetting.GetWebsiteURL() + Path;
            ClassName = (string.IsNullOrEmpty(ClassName) ? "" : "class=\"" + ClassName + "\"");
            alt = (string.IsNullOrEmpty(alt) ? "" : "alt=\"" + alt + "\"");
            
            return MvcHtmlString.Create("<img src='" + Path + "?v=" + Version + "' " + ClassName + " " + alt + " />");
        }



    }
}