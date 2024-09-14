using Dapper;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DataAccess.CommanClass
{
    public class Common_SPU
    {
       public static string EntrySource = "Web";

        public static PostResponse fnGetTokenExists(string Token)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_GetTokenExists", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = Token ?? "";
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.Status = Convert.ToBoolean(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during GetTokenExists. The query was executed :", ex.ToString(), "GetTokenExists()", "Common_SPU", "Common_SPU", 0, "");
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }


        public static PostResponse fnGetSessionExists(string SessionID, long LoginID)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_GetSessionExists", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@SessionID", SqlDbType.VarChar).Value = SessionID ?? "";
                        command.Parameters.Add("@LoginID", SqlDbType.Int).Value = LoginID;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.Status = Convert.ToBoolean(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetSessionExists. The query was executed :", ex.ToString(), "spu_GetSessionExists()", "Common_SPU", "Common_SPU", LoginID, "");
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }

        public static void LogError(string ErrDescription, string SystemException, string ActiveFunction, string ActiveForm, string ActiveModule, long LoginID, string IPAddress)
        {
            try
            {
                SqlParameter[] oparam = new SqlParameter[7];
                oparam[0] = new SqlParameter("@ErrDescription", ClsCommon.EnsureString(ErrDescription));
                oparam[1] = new SqlParameter("@SystemException", ClsCommon.EnsureString(SystemException));
                oparam[2] = new SqlParameter("@ActiveFunction", ClsCommon.EnsureString(ActiveFunction));
                oparam[3] = new SqlParameter("@ActiveForm", ClsCommon.EnsureString(ActiveForm));
                oparam[4] = new SqlParameter("@ActiveModule", ClsCommon.EnsureString(ActiveModule));
                oparam[5] = new SqlParameter("@createdby", LoginID);
                oparam[6] = new SqlParameter("@IPAddress", IPAddress??"");
                DataSet ds = clsDataBaseHelper.ExecuteDataSet("spu_SetErrorLog", oparam);
            }
            catch (Exception ex)
            {
            }

        }

        public static List<DropDownlist> GetDropDownList(GetDropDownResponse modal)
        {
            List<DropDownlist> result = new List<DropDownlist>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    var param = new DynamicParameters();
                    param.Add("@Doctype", dbType: DbType.String, value: modal.Doctype ?? "", direction: ParameterDirection.Input);
                    param.Add("@Values", dbType: DbType.String, value: modal.Values??"", direction: ParameterDirection.Input);
                    param.Add("@LoginId", dbType: DbType.Int32, value: modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDropDownList", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<DropDownlist>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetDropDownList. The query was executed :", ex.ToString(), "spu_GetDropDownList()", "Common_SPU", "Common_SPU", modal.LoginID, modal.IPAddress);

            }
            return result;
        }


      

        public static PostResponse fnSetMasterAttachment(FileResponse Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetMasterAttachment", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID ?? 0;
                        command.Parameters.Add("@filename", SqlDbType.VarChar).Value = Modal.FileName ?? "";
                        command.Parameters.Add("@contenttype", SqlDbType.VarChar).Value = Modal.FileExt ?? "";
                        command.Parameters.Add("@tableid", SqlDbType.Int).Value = Modal.tableid ?? 0;
                        command.Parameters.Add("@TableName", SqlDbType.VarChar).Value = Modal.TableName ?? "";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = Modal.Description ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetUpdateColumnResponse. The query was executed :", ex.ToString(), "spu_SetUpdateColumn_Common()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }
        public static PostResponse fnSetProfilePic(FileResponse Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetProfilePic", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@filename", SqlDbType.VarChar).Value = Modal.FileName ?? "";
                        command.Parameters.Add("@contenttype", SqlDbType.VarChar).Value = Modal.FileExt ?? "";
                        command.Parameters.Add("@tableid", SqlDbType.Int).Value = Modal.tableid ?? 0;
                        command.Parameters.Add("@TableName", SqlDbType.VarChar).Value = Modal.TableName ?? "";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = Modal.Description ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnSetProfilePic. The query was executed :", ex.ToString(), "spu_SetProfilePic()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }


        public static PostResponse fnDelRecord(GetResponse Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_DelRecord", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID;
                        command.Parameters.Add("@Doctype", SqlDbType.VarChar).Value = Modal.Doctype ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetUpdateColumnResponse. The query was executed :", ex.ToString(), "spu_SetUpdateColumn_Common()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }

        public static PostResponse fnGetUpdateColumnResponse(GetUpdateColumnResponse Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetUpdateColumn_Common", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID;
                        command.Parameters.Add("@Value", SqlDbType.VarChar).Value = Modal.Value ?? "";
                        command.Parameters.Add("@IsActive_Reason", SqlDbType.VarChar).Value = Modal.Reason ?? "";
                        command.Parameters.Add("@Doctype", SqlDbType.VarChar).Value = Modal.Doctype ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetUpdateColumnResponse. The query was executed :", ex.ToString(), "spu_SetUpdateColumn_Common()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }


        public static PostResponse fnGetCheckRecordExist(GetRecordExitsResponse Modal)
        {
            PostResponse result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_GetCheckRecordExist", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID;
                        command.Parameters.Add("@Value", SqlDbType.VarChar).Value = Modal.Value ?? "";
                        command.Parameters.Add("@Doctype", SqlDbType.VarChar).Value = Modal.Doctype ?? "";
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetCheckRecordExist. The query was executed :", ex.ToString(), "spu_GetCheckURLExist()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }



        public static List<ConfigSetting> GetConfigSetting(GetResponse modal)
        {
            List<ConfigSetting> result = new List<ConfigSetting>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    var param = new DynamicParameters();
                    param.Add("@ConfigKey", dbType: DbType.String, value: modal.Doctype??"", direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetConfigSetting", param: param, commandType: CommandType.StoredProcedure))
                    {
                        result = reader.Read<ConfigSetting>().ToList();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during GetConfigSetting. The query was executed :", ex.ToString(), "spu_GetConfigSetting()", "Common_SPU", "Common_SPU", modal.LoginID, modal.IPAddress);

            }
            return result;
        }


        public static DataSet GetBilling_RPT(GetResponse Modal)
        {
            DataSet ds = new DataSet();

            try
            {
                SqlParameter[] oparam = new SqlParameter[2];
                oparam[0] = new SqlParameter("@BillID", Modal.ID);
                oparam[1] = new SqlParameter("@LoginID", Modal.LoginID);
                ds = clsDataBaseHelper.ExecuteDataSet("spu_GetBilling_RPT", oparam);
            }
            catch (Exception ex)
            {
            }
            return ds;

        }



        public static Helpdesk.Count GetHelpdeskticketcount(GetResponse Modal)
        {

            Helpdesk.Count result = new Helpdesk.Count();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    //param.Add("@CategoryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Tickets_Count", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Count>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_Tickets_Count", "spu_GetHelpdesk_Tickets_Count", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public static PostResponse fnSetChangePassword(ChangePassword modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetChangePassword", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@NewPassword", SqlDbType.VarChar).Value = ClsCommon.Encrypt(modal.NewPassword) ?? "";
                        command.Parameters.Add("@OldPassword", SqlDbType.VarChar).Value = ClsCommon.Encrypt(modal.OldPassword) ?? "";
                        command.Parameters.Add("@Doctype", SqlDbType.VarChar).Value = modal.Doctype ?? "";
                        command.Parameters.Add("@LoginID", SqlDbType.Int).Value = modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = modal.IPAddress;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnSetChangePassword. The query was executed :", ex.ToString(), "spu_SetChangePassword()", "Common_SPU", "Common_SPU", modal.LoginID, "");
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }

        public static Profile GetProfile(GetResponse Modal)
        {
            Profile result = new Profile();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetUserProfile", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Profile>().FirstOrDefault();
                        if (!reader.IsConsumed)
                        {
                            result.BankList = reader.Read<Bank.List>().ToList();
                        }

                        if (!reader.IsConsumed)
                        {
                            result.AddressList = reader.Read<Address.List>().ToList();
                        }
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetProfile", "spu_GetUserProfile", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public static PostResponse fnSetHelpdesk_Attachments(Helpdesk.Attachment Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_Attachments", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID ?? 0;
                        command.Parameters.Add("@filename", SqlDbType.VarChar).Value = Modal.FileName ?? "";
                        command.Parameters.Add("@contenttype", SqlDbType.VarChar).Value = Modal.contenttype ?? "";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = Modal.Description ?? "";
                        command.Parameters.Add("@TicketID", SqlDbType.Int).Value = Modal.TicketID;
                        command.Parameters.Add("@NotesID", SqlDbType.VarChar).Value = Modal.NotesID;
                        command.Parameters.Add("@TempID", SqlDbType.VarChar).Value = Modal.TempID ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during spu_SetHelpdesk_Attachments. The query was executed :", ex.ToString(), "spu_SetUpdateColumn_Common()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }


        public static SMTPMail GetMailTemplate(GetResponse Modal)
        {

            SMTPMail result = new SMTPMail();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@TemplateName", dbType: DbType.String, value: Modal.Param1, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMailTemplate", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<SMTPMail>().FirstOrDefault();
                        if(!reader.IsConsumed)
                        {
                            result.TemplateData = reader.Read<Template>().FirstOrDefault();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.ConfigSettingList = reader.Read<ConfigSetting>().ToList();
                        }
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_Tickets_Count", "spu_GetHelpdesk_Tickets_Count", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }
        public static PostResponse fnSetOnboard_Attachment(FileResponse Modal)
        {
            PostResponse result = new PostResponse();

            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboarding_Attachment", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = Modal.Token ?? "";
                        command.Parameters.Add("@ID", SqlDbType.Int).Value = Modal.ID ?? 0;
                        command.Parameters.Add("@filename", SqlDbType.VarChar).Value = Modal.FileName ?? "";
                        command.Parameters.Add("@contenttype", SqlDbType.VarChar).Value = Modal.FileExt ?? "";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = Modal.Description ?? "";
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = Modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = Modal.IPAddress;
                        command.CommandTimeout = 0;
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.ID = Convert.ToInt64(reader["RET_ID"]);
                                result.StatusCode = Convert.ToInt32(reader["STATUS"]);
                                result.SuccessMessage = reader["MESSAGE"].ToString();
                                if (result.StatusCode > 0)
                                {
                                    result.Status = true;
                                }
                            }
                        }

                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                    Common_SPU.LogError("Error during fnGetUpdateColumnResponse. The query was executed :", ex.ToString(), "spu_SetUpdateColumn_Common()", "Common_SPU", "Common_SPU", Modal.LoginID, Modal.IPAddress);
                    result.StatusCode = -1;
                    result.SuccessMessage = ex.Message.ToString();
                }
            }
            return result;

        }

    }
}
