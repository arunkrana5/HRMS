using Dapper;
using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DataAccess.ModelsMaster
{
    public class MasterModal : IMasterHelper
    {
        
        public List<Masters.List> GetMastersList(GetResponse Modal)
        {

            List<Masters.List> result = new List<Masters.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@MasterID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@GroupID", dbType: DbType.Int64, value: Modal.AdditionalID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    param.Add("@TableName", dbType: DbType.String, value: ClsCommon.EnsureString(Modal.Doctype), direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMasters", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Masters.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetMasters", "GetMastersList", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Masters.Add GetMasters(GetResponse Modal)
        {

            Masters.Add result = new Masters.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@MasterID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@GroupID", dbType: DbType.Int64, value: Modal.AdditionalID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    param.Add("@TableName", dbType: DbType.String, value: ClsCommon.EnsureString(Modal.Doctype), direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMasters", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Masters.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetMasters", "GetMaster", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetMasters(Masters.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetMasters", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@MasterID", SqlDbType.Int).Value = modal.MasterID;
                        command.Parameters.Add("@TableName", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.TableName);
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.Name);
                        command.Parameters.Add("@Value", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.Value);
                        command.Parameters.Add("@GroupID", SqlDbType.Int).Value = modal.GroupID;
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



       


        public List<Department.List> GetDepartmentList(GetResponse Modal)
        {

            List<Department.List> result = new List<Department.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DeptID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDepartment", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Department.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDepartmentList", "spu_GetDepartment", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Department.Add GetDepartment(GetResponse Modal)
        {

            Department.Add result = new Department.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DeptID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDepartment", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Department.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDepartment", "spu_GetDepartment", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetDepartment(Department.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetDepartment", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@DeptID", SqlDbType.Int).Value = modal.DeptID;
                        command.Parameters.Add("@DeptCode", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.DeptCode);
                        command.Parameters.Add("@DeptName", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.DeptName);
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




        public List<Designation.List> GetDesignationList(GetResponse Modal)
        {

            List<Designation.List> result = new List<Designation.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DesignID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDesignation", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Designation.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDesignationList", "spu_GetDesignation", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Designation.Add GetDesignation(GetResponse Modal)
        {

            Designation.Add result = new Designation.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DesignID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDesignation", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Designation.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDesignation", "spu_GetDesignation", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetDesignation(Designation.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetDesignation", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@DesignID", SqlDbType.Int).Value = modal.DesignID;
                        command.Parameters.Add("@DesignCode", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.DesignCode);
                        command.Parameters.Add("@DesignName", SqlDbType.VarChar).Value = ClsCommon.EnsureString(modal.DesignName);
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




        public List<Clients.List> GetMaster_ClientsList(GetResponse Modal)
        {

            List<Clients.List> result = new List<Clients.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@ClientID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMaster_Clients", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Clients.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDesignationList", "spu_GetDesignation", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Clients.Add GetMaster_Clients(GetResponse Modal)
        {

            Clients.Add result = new Clients.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@ClientID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMaster_Clients", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Clients.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetMaster_Clients", "spu_GetMaster_Clients", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetClients(Clients.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetMaster_Clients", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ClientID", SqlDbType.Int).Value = modal.ClientID;
                        command.Parameters.Add("@ClientCode", SqlDbType.VarChar).Value = modal.ClientCode ?? "";
                        command.Parameters.Add("@ClientName", SqlDbType.VarChar).Value = modal.ClientName ?? "";
                        command.Parameters.Add("@DisplayName", SqlDbType.VarChar).Value = modal.DisplayName ?? "";
                        command.Parameters.Add("@OtherCode", SqlDbType.VarChar).Value = modal.OtherCode ?? "";
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


        public List<ClientsTran.List> GetMaster_ClientsTranList(GetResponse Modal)
        {

            List<ClientsTran.List> result = new List<ClientsTran.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    
                    param.Add("@ClientTranID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@ClientID", dbType: DbType.Int64, value: Modal.AdditionalID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMaster_ClientsTranList", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<ClientsTran.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDesignationList", "spu_GetDesignation", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public ClientsTran.Add GetMaster_ClientsTran(GetResponse Modal)
        {

            ClientsTran.Add result = new ClientsTran.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@ClientTranID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@ClientID", dbType: DbType.Int64, value: Modal.AdditionalID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetMaster_ClientsTranList", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<ClientsTran.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetMaster_ClientsTranList", "spu_GetMaster_ClientsTranList", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetMaster_ClientsTran(ClientsTran.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetMaster_ClientsTran", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@ClientTranID", SqlDbType.Int).Value = modal.ClientTranID??0;
                        command.Parameters.Add("@ClientID", SqlDbType.Int).Value = modal.ClientID??0;
                        command.Parameters.Add("@Code", SqlDbType.VarChar).Value = modal.Code ?? "";
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = modal.Name ?? "";
                        command.Parameters.Add("@PrintName", SqlDbType.VarChar).Value = modal.PrintName ?? "";
                        command.Parameters.Add("@PAN", SqlDbType.VarChar).Value = modal.PAN ?? "";
                        command.Parameters.Add("@GSTNo", SqlDbType.VarChar).Value = modal.GSTNo ?? "";
                        command.Parameters.Add("@Commission", SqlDbType.Float).Value = modal.Commission ?? 0;
                        command.Parameters.Add("@CountryID", SqlDbType.Int).Value = modal.CountryID??0;
                        command.Parameters.Add("@StateID", SqlDbType.Int).Value = modal.StateID??0;
                        command.Parameters.Add("@Address", SqlDbType.VarChar).Value = modal.Address ?? "";
                        command.Parameters.Add("@ZipCode", SqlDbType.VarChar).Value = modal.ZipCode ?? "";
                        command.Parameters.Add("@Phone", SqlDbType.VarChar).Value = modal.Phone ?? "";
                        command.Parameters.Add("@EmailID", SqlDbType.VarChar).Value = modal.EmailID ?? "";
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




        public List<Country.List> GetCountryList(GetResponse Modal)
        {

            List<Country.List> result = new List<Country.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CountryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetCountry", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Country.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetCountryList", "spu_GetCountry", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Country.Add GetCountry(GetResponse Modal)
        {

            Country.Add result = new Country.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CountryID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetCountry", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Country.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetCountry", "spu_GetCountry", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetCountry(Country.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_setCountry", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@CountryID", SqlDbType.Int).Value = modal.CountryID;
                        command.Parameters.Add("@CountryName", SqlDbType.VarChar).Value = modal.CountryName ?? "";
                        command.Parameters.Add("@CountryCode", SqlDbType.VarChar).Value = modal.CountryCode ?? "";
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


        public List<Region.List> GetRegionList(GetResponse Modal)
        {

            List<Region.List> result = new List<Region.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@RegionID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetRegion", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Region.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetRegionList", "spu_GetRegion", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Region.Add GetRegion(GetResponse Modal)
        {

            Region.Add result = new Region.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@RegionID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetRegion", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Region.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetRegion", "spu_GetRegion", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetRegion(Region.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetRegion", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@RegionID", SqlDbType.Int).Value = modal.RegionID;
                        command.Parameters.Add("@RegionName", SqlDbType.VarChar).Value = modal.RegionName ?? "";
                        command.Parameters.Add("@RegionCode", SqlDbType.VarChar).Value = modal.RegionCode ?? "";
                        command.Parameters.Add("@CountryID", SqlDbType.Int).Value = modal.CountryID;
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


        public List<State.List> GetStateList(GetResponse Modal)
        {

            List<State.List> result = new List<State.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@StateID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetState", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<State.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetRegionList", "spu_GetRegion", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public State.Add GetState(GetResponse Modal)
        {

            State.Add result = new State.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@StateID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetState", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<State.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetState", "spu_GetState", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetState(State.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetState", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@StateID", SqlDbType.Int).Value = modal.StateID;
                        command.Parameters.Add("@StateName", SqlDbType.VarChar).Value = modal.StateName ?? "";
                        command.Parameters.Add("@StateCode", SqlDbType.VarChar).Value = modal.StateCode ?? "";
                        command.Parameters.Add("@TIN", SqlDbType.VarChar).Value = modal.Tin ?? "";
                        command.Parameters.Add("@RegionID", SqlDbType.Int).Value = modal.RegionID;
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


        public List<City.List> GetCityList(GetResponse Modal)
        {
            List<City.List> result = new List<City.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CityID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetCity", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<City.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetCity", "spu_GetCity", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public City.Add GetCity(GetResponse Modal)
        {

            City.Add result = new City.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@CityID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetCity", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<City.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetCity", "spu_GetCity", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetCity(City.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetCity", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@CityID", SqlDbType.Int).Value = modal.CityID;
                        command.Parameters.Add("@CityName", SqlDbType.VarChar).Value = modal.CityName ?? "";
                        command.Parameters.Add("@CityCode", SqlDbType.VarChar).Value = modal.CityCode ?? "";
                        command.Parameters.Add("@StateID", SqlDbType.Int).Value = modal.StateID;
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



        public List<DealerType.List> GetDealerTypeList(GetResponse Modal)
        {

            List<DealerType.List> result = new List<DealerType.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DealerTypeID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDealerType", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<DealerType.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetDealerTypeList", "GetMastersList", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public DealerType.Add GetDealerType(GetResponse Modal)
        {

            DealerType.Add result = new DealerType.Add();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@DealerTypeID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetDealerType", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<DealerType.Add>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetDealerType", "spu_GetDealerType", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetDealerType(DealerType.Add modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetDealerType", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@DealerTypeID", SqlDbType.Int).Value = modal.DealerTypeID;
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = modal.Name ?? "";
                        command.Parameters.Add("@Code", SqlDbType.VarChar).Value = modal.Code ?? "";
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


    }
}
