using Dapper;
using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.ModelsMaster
{
    public class HelpDeskModal: IHelpDeskHelper
    {
        public List<Helpdesk.Category.List> GetHelpdesk_CategoryList(GetResponse Modal)
        {

            List<Helpdesk.Category.List> result = new List<Helpdesk.Category.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CategoryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Category", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Category.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_Category", "spu_GetHelpdesk_Category", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Helpdesk.Category.Add GetHelpdesk_Category(GetResponse Modal)
        {

            Helpdesk.Category.Add result = new Helpdesk.Category.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CategoryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Category", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Category.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_Category", "spu_GetHelpdesk_Category", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetHelpdesk_Category(Helpdesk.Category.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_Category", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@CategoryID", SqlDbType.Int).Value = modal.CategoryID;
                        command.Parameters.Add("@CategoryName", SqlDbType.VarChar).Value = modal.CategoryName ?? "";
                        command.Parameters.Add("@CategoryDesc", SqlDbType.VarChar).Value = modal.CategoryDesc ?? "";
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

        public List<Helpdesk.SubCategory.List> GetHelpdesk_SubCategoryList(GetResponse Modal)
        {

            List<Helpdesk.SubCategory.List> result = new List<Helpdesk.SubCategory.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_SubCategoryList", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.SubCategory.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_SubCategory", "spu_GetHelpdesk_SubCategory", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Helpdesk.SubCategory.Add GetHelpdesk_SubCategory(GetResponse Modal)
        {

            Helpdesk.SubCategory.Add result = new Helpdesk.SubCategory.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@SubCategoryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_SubCategory", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.SubCategory.Add>().FirstOrDefault();
                        if(result==null)
                        {
                            result = new Helpdesk.SubCategory.Add();
                        }
                        if(!reader.IsConsumed)
                        {
                            result.CatgeoryList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.UserList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            List<long> LL = new List<long>();
                            var Ids= reader.Read<DropDownlist>().ToList();
                            if(Ids!=null)
                            {
                                
                                foreach (var item in Ids)
                                {
                                    LL.Add(item.ID);
                                }
                            }
                            result.IDs = LL;
                        }
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_Category", "spu_GetHelpdesk_Category", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetHelpdesk_SubCategory(Helpdesk.SubCategory.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    string LoginIDs = "";
                    LoginIDs=String.Join(",", modal.IDs);
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_SubCategory", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@SubCategoryID", SqlDbType.Int).Value = modal.SubCategoryID;
                        command.Parameters.Add("@CategoryID", SqlDbType.Int).Value = modal.CategoryID;
                        command.Parameters.Add("@SubName", SqlDbType.VarChar).Value = modal.SubName ?? "";
                        command.Parameters.Add("@SubDesc", SqlDbType.VarChar).Value = modal.SubDesc ?? "";
                        command.Parameters.Add("@LoginIDs", SqlDbType.VarChar).Value = LoginIDs;
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


        public List<Helpdesk.Status.List> GetHelpdesk_StatusList(GetResponse Modal)
        {

            List<Helpdesk.Status.List> result = new List<Helpdesk.Status.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@StatusID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Status", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Status.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_SubCategory", "spu_GetHelpdesk_SubCategory", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Helpdesk.Status.Add GetHelpdesk_Status(GetResponse Modal)
        {

            Helpdesk.Status.Add result = new Helpdesk.Status.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@StatusID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Status", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Status.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetHelpdesk_Status", "GetHelpdesk_Status", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetHelpdesk_Status(Helpdesk.Status.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_Status", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@StatusID", SqlDbType.Int).Value = modal.StatusID;
                        command.Parameters.Add("@StatusName", SqlDbType.VarChar).Value = modal.StatusName??"";
                        command.Parameters.Add("@DisplayName", SqlDbType.VarChar).Value = modal.DisplayName ?? "";
                        command.Parameters.Add("@Icon", SqlDbType.VarChar).Value = modal.Icon ?? "";
                        command.Parameters.Add("@Color", SqlDbType.VarChar).Value = modal.Color ?? "";
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

   


        public List<Helpdesk.Ticket.List> GetHelpdesk_Tickets_List(MyTab.Approval Modal)
        {

            List<Helpdesk.Ticket.List> result = new List<Helpdesk.Ticket.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@StatusID", dbType: DbType.Int64, value: Modal.Approved, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Tickets_List", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Helpdesk.Ticket.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetHelpdesk_SubCategory", "spu_GetHelpdesk_SubCategory", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetHelpdesk_Ticket(Helpdesk.Ticket.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    string OptionalUsers = "";
                    if (modal.OptionalUsers != null)
                    {
                        OptionalUsers = String.Join(",", modal.OptionalUsers);
                    }
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_Ticket", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@CategoryID", SqlDbType.Int).Value = modal.CategoryID;
                        command.Parameters.Add("@SubCategoryID", SqlDbType.Int).Value = modal.SubCategoryID;
                        command.Parameters.Add("@Subject", SqlDbType.VarChar).Value = modal.Subject ?? "";
                        command.Parameters.Add("@Messageinfo", SqlDbType.VarChar).Value = modal.Message ?? "";
                        command.Parameters.Add("@TicketPriority", SqlDbType.VarChar).Value = modal.TicketPriority ?? "";
                        command.Parameters.Add("@OptionalUsers", SqlDbType.VarChar).Value = OptionalUsers;
                        command.Parameters.Add("@TempID", SqlDbType.VarChar).Value = modal.TempID;
                        command.Parameters.Add("@IsActive", SqlDbType.Int).Value = 1;
                        command.Parameters.Add("@Priority", SqlDbType.Int).Value = 0;
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


        public Helpdesk.Ticket.Details GetHelpdesk_Ticket_Details(GetResponse Modal)
        {

            Helpdesk.Ticket.Details result = new Helpdesk.Ticket.Details();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@TicketID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetHelpdesk_Ticket_Details", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result.TicketDetails = reader.Read<Helpdesk.Ticket.List>().FirstOrDefault();
                        if (!reader.IsConsumed)
                        {
                            result.AssigneeList = reader.Read<Helpdesk.Users>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.DeferredList = reader.Read<Helpdesk.Users>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.NotesList = reader.Read<Helpdesk.Notes.List>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.AttachmentList = reader.Read<Helpdesk.Attachment>().ToList();
                        }
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetHelpdesk_Ticket_Details", "spu_GetHelpdesk_Ticket_Details", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetHelpdesk_Ticket_Notes(Helpdesk.Notes.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetHelpdesk_Ticket_Notes", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@TicketID", SqlDbType.Int).Value = modal.TicketID??0;
                        command.Parameters.Add("@StatusID", SqlDbType.Int).Value = modal.StatusID??0;
                        command.Parameters.Add("@UserID", SqlDbType.Int).Value = modal.UserID;
                        if (modal.NextDate == null)
                        {
                            command.Parameters.Add("@NextDate", SqlDbType.DateTime).Value = DBNull.Value;
                        }
                        else
                        {
                            command.Parameters.Add("@NextDate", SqlDbType.DateTime).Value = modal.NextDate;
                        }
                        command.Parameters.Add("@Notes", SqlDbType.VarChar).Value = modal.Notes ?? "";
                        command.Parameters.Add("@TempID", SqlDbType.VarChar).Value = modal.TempID;
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

    }
}
