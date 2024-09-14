using Dapper;
using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DataAccess.ModelsMaster
{
    public class ToolsModal : IToolHelper
    {
        string ConnectionStrings = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString.ToString();

        public List<AdminMenu> GetAdminMenuList(GetResponse modal)
        {
            List<AdminMenu> result = new List<AdminMenu>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMenu_Admin", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<AdminMenu>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetAdminMenuList. The query was executed :", ex.ToString(), "spu_GetMenu_Admin()", "HomeModal", "HomeModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }
        public List<ErrorLog> ErrorLogList(GetResponse modal)
        {
            List<ErrorLog> result = new List<ErrorLog>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@ID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int32, value: modal.LoginID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetErrorLog", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<ErrorLog>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during ErrorLogList. The query was executed :", ex.ToString(), "spu_GetErrorLog()", "ToolsModal", "ToolsModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }

        public List<AdminUser.Role.List> GetRolesList(GetResponse modal)
        {
            List<AdminUser.Role.List> result = new List<AdminUser.Role.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@RoleID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetRoles", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<AdminUser.Role.List>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetRolesList. The query was executed :", ex.ToString(), "spu_GetRoles()", "ToolsModal", "ToolsModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }


        public AdminUser.Role.Add GetRoles(GetResponse modal)
        {
            AdminUser.Role.Add result = new AdminUser.Role.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@RoleID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetRoles", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<AdminUser.Role.Add>().FirstOrDefault();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetRoles. The query was executed :", ex.ToString(), "spu_GetRoles()", "HomeModal", "HomeModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }
        public List<AdminModule> GetModuleListWithMenu(GetResponse modal)
        {
            List<AdminModule> result = new List<AdminModule>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@Roleid", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetModuleListRoleWise", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<AdminModule>().ToList();
                    }
                    DBContext.Close();
                }
                if (result != null)
                {
                    foreach (AdminModule item in result)
                    {
                        item.MainMenuList = GetLoginMenuListWithDetails(item.ModuleID, modal.ID);
                    }
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetModuleListWithMenu. The query was executed :", ex.ToString(), "spu_GetModuleListRoleWise()", "HomeModal", "HomeModal", modal.LoginID, modal.IPAddress);
            }
            return result;
        }

        private List<AdminMenu> GetLoginMenuListWithDetails(long ModuleID, long RoleID, long ParentMenuID = 0)
        {
            string SQL = "";
            List<AdminMenu> List = new List<AdminMenu>();
            AdminMenu obj;
            try
            {
                SQL = @" select RT.TranID,M.ModuleID,LM.ModuleName,LM.ModulePriority,
                M.MenuID, M.MenuName, M.ParentMenuID, M.MenuImage, M.MenuURL, 
                M.Target,LM.ModuleIcon,M.Priority,
                RT.RoleID, RT.R, RT.W, RT.M, RT.D,RT.E,RT.I,RT.APP,
                case when (Select count(a.MenuID) from  Login_Menu as a where  a.ParentMenuID= M.MenuID and a.IsActive=1 and a.Isdeleted=0)>0 then 'Y' else 'N' End as IsChild
                from Login_Menu as M
                inner join Login_Module as LM on LM.ModuleID=M.ModuleID and LM.Isdeleted=0
                inner join Login_Menu_Role_Tran as RT on RT.MenuID=M.MenuID and RT.isdeleted=0
                where M.IsActive=1 and M.Isdeleted=0 and LM.IsActive=1 and LM.Isdeleted=0
                and LM.ModuleID=" + ModuleID + " and RT.RoleID=" + RoleID + "";

                DataSet TempMenuDataSet = clsDataBaseHelper.ExecuteDataSet(SQL);

                foreach (DataRow item in TempMenuDataSet.Tables[0].Select("ParentMenuID='" + ParentMenuID + "'"))
                {
                    obj = new AdminMenu();
                    obj.TranID = Convert.ToInt32(item["TranID"]);
                    obj.MenuID = Convert.ToInt32(item["MenuID"]);
                    obj.ParentMenuID = Convert.ToInt32(item["ParentMenuID"]);
                    obj.ModuleID = Convert.ToInt32(item["ModuleID"]);
                    obj.R = Convert.ToBoolean(item["R"]);
                    obj.W = Convert.ToBoolean(item["W"]);
                    obj.D = Convert.ToBoolean(item["D"]);
                    obj.M = Convert.ToBoolean(item["M"]);
                    obj.E = Convert.ToBoolean(item["E"]);
                    obj.I = Convert.ToBoolean(item["I"]);
                    obj.App = Convert.ToBoolean(item["APP"]);
                    obj.MenuName = item["MenuName"].ToString();
                    obj.MenuURL = item["MenuURL"].ToString();
                    obj.IsChild = item["IsChild"].ToString();
                    if (item["IsChild"].ToString() == "Y")
                    {
                        obj.ChildMenuList = GetLoginMenuListWithDetails(ModuleID, RoleID, obj.MenuID);
                    }
                    List.Add(obj);
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetModuleListWithMenu. The query was executed :", ex.ToString(), "spu_GetModuleListRoleWise()", "HomeModal", "HomeModal", 0, "");
            }
            return List;
        }



        public PostResponse fnSetUserRole(AdminUser.Role.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ConnectionStrings))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetUserRoles", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@RoleID", SqlDbType.Int).Value = modal.RoleID;
                        command.Parameters.Add("@RoleName", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.rolename);
                        command.Parameters.Add("@description", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.description);
                        command.Parameters.Add("@IsActive", SqlDbType.Int).Value = modal.IsActive;
                        command.Parameters.Add("@Priority", SqlDbType.Int).Value = modal.Priority ?? 0;
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Result.ID = Convert.ToInt64(reader["RET_ID"]);
                                Result.StatusCode = Convert.ToInt32(reader["Status"]);
                                Result.SuccessMessage = reader["Message"].ToString();
                                if (Result.StatusCode > 0)
                                {
                                    Result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Result.StatusCode = -1;
                    Result.SuccessMessage = ex.Message.ToString();
                }
            }
            return Result;
        }


        public List<EmailTemplate.List> GetEmailTemplateList(GetResponse modal)
        {
            List<EmailTemplate.List> result = new List<EmailTemplate.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@TemplateID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetEmailTemplate", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<EmailTemplate.List>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetEmailTemplateList. The query was executed :", ex.ToString(), "spu_GetEmailTemplate()", "HomeModal", "HomeModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }
        public EmailTemplate.Add GetEmailTemplate(GetResponse modal)
        {
            EmailTemplate.Add result = new EmailTemplate.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@TemplateID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetEmailTemplate", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<EmailTemplate.Add>().FirstOrDefault();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetEmailTemplate. The query was executed :", ex.ToString(), "spu_GetEmailTemplate()", "ToolsModal", "ToolsModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }

        public PostResponse fnSetEmailTemplate(EmailTemplate.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ConnectionStrings))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetEmailTemplate", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@TemplateID", SqlDbType.Int).Value = modal.TemplateID;
                        command.Parameters.Add("@TemplateName", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.TemplateName);
                        command.Parameters.Add("@Body", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.Body);
                        command.Parameters.Add("@Subject", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.Subject);
                        command.Parameters.Add("@CCMail", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.CCMail);
                        command.Parameters.Add("@BCCMail", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.BCCMail);
                        command.Parameters.Add("@SMSBody", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.SMSBody);
                        command.Parameters.Add("@Repository", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.Repository);
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Result.ID = Convert.ToInt64(reader["RET_ID"]);
                                Result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                Result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (Result.StatusCode > 0)
                                {
                                    Result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Result.StatusCode = -1;
                    Result.SuccessMessage = ex.Message.ToString();
                }
            }
            return Result;
        }


        public List<Users.List> GetUsersList(GetResponse modal)
        {
            List<Users.List> result = new List<Users.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@LoginID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetUser", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<Users.List>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetusersList. The query was executed :", ex.ToString(), "spu_GetUser()", "ToolsModal", "ToolsModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }
        public Users.Add GetUsers(GetResponse modal)
        {
            Users.Add result = new Users.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@LoginID", dbType: DbType.Int32, value: modal.ID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetUser", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<Users.Add>().FirstOrDefault();

                    }
                    DBContext.Close();
                    if (result != null)
                    {
                        if (!string.IsNullOrEmpty(result.Password))
                        {
                            result.Password = ClsCommon.Decrypt(result.Password);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetUsers. The query was executed :", ex.ToString(), "spu_GetUser()", "ToolsModal", "ToolsModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }

        public PostResponse fnSetUsers(Users.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ConnectionStrings))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetUsers", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@LoginID", SqlDbType.Int).Value = modal.ID;
                        command.Parameters.Add("@userID", SqlDbType.VarChar).Value = modal.UserID??"";
                        command.Parameters.Add("@password", SqlDbType.VarChar).Value = ClsCommon.Encrypt(modal.Password) ?? "";
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = modal.Name??"";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = modal.Description??"";
                        command.Parameters.Add("@Phone", SqlDbType.VarChar).Value = modal.Phone ?? "";
                        command.Parameters.Add("@email", SqlDbType.VarChar).Value = modal.email ?? "";
                        command.Parameters.Add("@roleid", SqlDbType.Int).Value = modal.RoleID;
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Result.ID = Convert.ToInt64(reader["RET_ID"]);
                                Result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                Result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (Result.StatusCode > 0)
                                {
                                    Result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Result.StatusCode = -1;
                    Result.SuccessMessage = ex.Message.ToString();
                }
            }
            return Result;
        }


        public List<AdminMenu> GetAppMenuList(GetMenuResponse modal)
        {
            List<AdminMenu> result = new List<AdminMenu>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ConnectionStrings))
                {
                    var param = new DynamicParameters();
                    DBContext.Open();
                    param.Add("@RoleID", dbType: DbType.Int32, value: modal.RoleID, direction: ParameterDirection.Input);
                    param.Add("@ParentMenuID", dbType: DbType.Int32, value: modal.ParentMenuID, direction: ParameterDirection.Input);
                    using (var reader = DBContext.QueryMultiple("spu_GetAppMenu", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<AdminMenu>().ToList();
                    }
                    DBContext.Close();
                }
                if (result != null)
                {
                    foreach (var item in result)
                    {
                        if (item.IsChild == "Y")
                        {
                            modal.ParentMenuID = item.MenuID;
                            item.ChildMenuList = GetAppMenuList(modal);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetAdminMenuList. The query was executed :", ex.ToString(), "spu_GetMenu_Admin()", "HomeModal", "HomeModal", modal.LoginID, modal.IPAddress);

            }
            return result;
        }

       

    }
}
