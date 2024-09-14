using System.Collections.Generic;

namespace DataAccess.Models
{
    public class AdminMenu
    {
        public int ModuleID { get; set; }
        public string ModuleName { set; get; }
        public string Type { get; set; }
        public int ModulePriority { get; set; }
        public string ModuleIcon { get; set; }
        public string IsChild { get; set; }
        public int RoleID { get; set; }
        public int TranID { get; set; }
        public int MenuID { get; set; }
        public string MenuName { get; set; }
        public int Priority { set; get; }

        public int ParentMenuID { get; set; }
        public string MenuImage { get; set; }
        public string Target { get; set; }


        public string MenuURL { get; set; }
        public bool R { get; set; }
        public bool W { get; set; }
        public bool M { get; set; }
        public bool D { get; set; }
        public bool E { get; set; }
        public bool I { get; set; }
        public bool App { get; set; }
        public List<AdminMenu> ChildMenuList { get; set; }
    }

    public class AdminModule
    {
        public long ModuleID { get; set; }
        public string Type { get; set; }
        public string ModuleName { get; set; }

        public string ModuleIcon { get; set; }
        public int ModulePriority { get; set; }
        public List<AdminMenu> MainMenuList { get; set; }
    }
    public class PageViewPermission
    {
        public bool ReadFlag { set; get; }
        public bool WriteFlag { set; get; }
        public bool ModifyFlag { set; get; }
        public bool DeleteFlag { set; get; }
        public bool ExportFlag { set; get; }
        public bool ImportFlag { set; get; }
    }
}
