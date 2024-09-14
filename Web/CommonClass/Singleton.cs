
using DataAccess.CommanClass;
using System;

namespace Web.CommonClass
{
    public sealed class Singleton
    {
        private static readonly Lazy<Singleton> lazy =
       new Lazy<Singleton>(() => new Singleton());

        public static Singleton Instance { get { return lazy.Value; } }

        private Singleton()
        {
        }
        //public List<PushNotification> GetPushNotificationList(string ListType)
        //{
        //    List<PushNotification> List = new List<PushNotification>();
        //    PushNotification PushItem;
        //    string LoginID = clsApplicationSetting.GetSessionValue("LoginID");
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(LoginID))
        //        {
        //            DataSet TempModuleDataSet = Common_SPU.fnGetPushNotification(ListType);
        //            foreach (DataRow item in TempModuleDataSet.Tables[0].Rows)
        //            {
        //                PushItem = new PushNotification();
        //                PushItem.NotificationID = Convert.ToInt32(item["NotificationID"]);
        //                PushItem.Subject = item["Subject"].ToString();
        //                PushItem.MessageContent = item["MessageContent"].ToString();
        //                PushItem.GotoURL = item["GotoURL"].ToString();
        //                PushItem.Category = item["Category"].ToString();
        //                PushItem.Status = item["Status"].ToString();
        //                PushItem.Priority = Convert.ToInt32(item["Priority"]);
        //                PushItem.IsActive = Convert.ToBoolean(item["IsActive"]);
        //                PushItem.IsRecent = Convert.ToBoolean(item["IsRecent"]);
        //                PushItem.IsStatusRead = Convert.ToBoolean(item["IsStatusRead"]);
        //                PushItem.CreatedDate = Convert.ToDateTime(item["createdat"]).ToString("dd-MMM-yy hh:mm:ss tt");
        //                PushItem.CreatedByID = Convert.ToInt32(item["createdby"]);
        //                PushItem.IPAddress = item["IPAddress"].ToString();
        //                List.Add(PushItem);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //       ClsCommon.LogError("Error during GetPushNotificationList. The query was executed :", ex.ToString(), "CP/GetPushNotificationList()", "Singleton", "Singleton", "");
        //    }
        //    return List;
        //}

        public bool ClearRecentNotification(string ID)
        {
            bool Result = false;
            string SQL = "";

            try
            {
                SQL = "update PushNotification set IsRecent=0 where NotificationID=" + ID;
                //clsDataBaseHelper.ExecuteNonQuery(SQL);
                Result = true;

            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetAdminMenuList. The query was executed :", ex.ToString(), "spu_GetMenu_Admin()", "HomeModal", "HomeModal", 0, "");
            }
            return Result;
        }

        public void SendMailbySingleton()
        {
            //SendMailHelper.SendAllPendingMail();
        }
    }
}