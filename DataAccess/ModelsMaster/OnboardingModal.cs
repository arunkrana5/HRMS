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
    public class OnboardingModal : IOnboardingHelper
    {
        public List<Onboarding.List> GetOnboarding_List(MyTab.Approval Modal)
        {

            List<Onboarding.List> result = new List<Onboarding.List>();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@Approved", dbType: DbType.Int64, value: Modal.Approved, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetOnboarding_List", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Onboarding.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetOnboarding_List", "spu_GetOnboarding_List", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public PostResponse fnSetOnboarding_Create(Onboarding.Create modal)
        {
            PostResponse Result = new PostResponse();
            DateTime dt;
            DateTime.TryParse(modal.DOB, out dt);
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboarding_Create", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = modal.Name ?? "";
                        command.Parameters.Add("@Gender", SqlDbType.VarChar).Value = modal.Gender.ToString() ?? "";
                        command.Parameters.Add("@FatherName", SqlDbType.VarChar).Value = modal.FatherName;
                        command.Parameters.Add("@Mobile", SqlDbType.VarChar).Value = modal.Mobile;
                        command.Parameters.Add("@EmailID", SqlDbType.VarChar).Value = modal.EmailID;
                        command.Parameters.Add("@DOB", SqlDbType.VarChar).Value = dt.ToString("dd-MMM-yyyy");
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = modal.Token;
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
                                Result.AdditionalMessage = reader["AdditionalMessage"].ToString();
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


        public Onboarding.View GetOnboarding_View(GetResponse Modal)
        {

            Onboarding.View result = new Onboarding.View();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@AppID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetOnboarding_View", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Onboarding.View>().FirstOrDefault();
                        if (!reader.IsConsumed)
                        {
                            result.DocumentsList = reader.Read<Onboarding.Documents>().ToList();
                        }
                    }
                   

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetOnboarding_View", "spu_GetOnboarding_List", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetOnboardingApproval(Onboarding.ApprovalAction modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboardingApproval", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@AppID", SqlDbType.VarChar).Value = modal.IDs;
                        command.Parameters.Add("@Approved", SqlDbType.Int).Value = modal.Approved;
                        command.Parameters.Add("@ApprovedRemarks", SqlDbType.VarChar).Value = modal.ApprovedRemarks ?? "";
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



        public Onboarding.Users.BasicDetails GetOnboarding_BasicDetails(GetResponse Modal)
        {
            Onboarding.Users.BasicDetails result = new Onboarding.Users.BasicDetails();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@Token", dbType: DbType.String, value: Modal.Param1, direction: ParameterDirection.Input);
                    param.Add("@Doctype", dbType: DbType.String, value: Modal.Doctype ?? "", direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetOnboarding_Application", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Onboarding.Users.BasicDetails>().FirstOrDefault();
                        if (!reader.IsConsumed)
                        {
                            result.CountryList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.RegionList = reader.Read<DropDownlist>().ToList();
                            if (result.RegionList == null)
                            {
                                result.RegionList = new List<DropDownlist>();
                            }
                        }
                        if (!reader.IsConsumed)
                        {
                            result.StateList = reader.Read<DropDownlist>().ToList();
                            if (result.StateList == null)
                            {
                                result.StateList = new List<DropDownlist>();
                            }
                        }
                        if (!reader.IsConsumed)
                        {
                            result.CityList = reader.Read<DropDownlist>().ToList();
                            if (result.CityList == null)
                            {
                                result.CityList = new List<DropDownlist>();
                            }
                        }

                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetOnboardApplication", "spu_GetOnboardApplication", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

      
        public Onboarding.Users.BankDetails GetOnboarding_BankDetails(GetResponse Modal)
        {
            Onboarding.Users.BankDetails result = new Onboarding.Users.BankDetails();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@Token", dbType: DbType.String, value: Modal.Param1, direction: ParameterDirection.Input);
                    param.Add("@Doctype", dbType: DbType.String, value: Modal.Doctype ?? "", direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetOnboarding_Application", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Onboarding.Users.BankDetails>().FirstOrDefault();
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetOnboardApplication", "spu_GetOnboardApplication", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public Onboarding.Users.DocumentDetails GetOnboarding_Documents(GetResponse Modal)
        {
            Onboarding.Users.DocumentDetails result = new Onboarding.Users.DocumentDetails();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@Token", dbType: DbType.String, value: Modal.Param1, direction: ParameterDirection.Input);
                    param.Add("@Doctype", dbType: DbType.String, value: Modal.Doctype ?? "", direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetOnboarding_Application", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Onboarding.Users.DocumentDetails>().FirstOrDefault();

                        if(!reader.IsConsumed)
                        {
                            result.DocumentsList = reader.Read<Onboarding.Users.Documents>().ToList();
                            if (result.DocumentsList== null || result.DocumentsList.Count==0)
                            {
                                List<Onboarding.Users.Documents> docList = new List<Onboarding.Users.Documents>();
                                Onboarding.Users.Documents doc= new Onboarding.Users.Documents();
                                doc.Description = "Aadhar";
                                docList.Add(doc);
                                Onboarding.Users.Documents doc1 = new Onboarding.Users.Documents();
                                doc1.Description = "PAN";
                                docList.Add(doc1);
                                result.DocumentsList = docList;
                            }
                        }
                        
                    }
                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetOnboarding_Documents", "spu_GetOnboardApplication", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetOnboarding_BasicDetails(Onboarding.Users.BasicDetails modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    DateTime DOB;
                    DateTime.TryParse(modal.DOB, out DOB);
                  
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboarding_BasicDetails", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = modal.Token ?? "";
                        command.Parameters.Add("@Name", SqlDbType.VarChar).Value = modal.Name ?? "";
                        command.Parameters.Add("@Gender", SqlDbType.VarChar).Value = modal.Gender.ToString() ?? "";
                        command.Parameters.Add("@FatherName", SqlDbType.VarChar).Value = modal.FatherName;
                        command.Parameters.Add("@Mobile", SqlDbType.VarChar).Value = modal.Mobile;
                        command.Parameters.Add("@EmailID", SqlDbType.VarChar).Value = modal.EmailID;
                        command.Parameters.Add("@DOB", SqlDbType.VarChar).Value = DOB.ToString("dd-MMM-yyyy");
                      
                        command.Parameters.Add("@BloodGroup", SqlDbType.VarChar).Value = modal.BloodGroup.ToString() ?? "";
                        command.Parameters.Add("@MaritalStatus", SqlDbType.VarChar).Value = modal.MaritalStatus.ToString() ?? "";
                   
                        command.Parameters.Add("@VaccinationDetails", SqlDbType.VarChar).Value = modal.VaccinationDetails.ToString() ?? "";
                        command.Parameters.Add("@CountryID", SqlDbType.VarChar).Value = modal.CountryID ?? 0;
                        command.Parameters.Add("@RegionID", SqlDbType.VarChar).Value = modal.RegionID ?? 0;
                        command.Parameters.Add("@StateID", SqlDbType.VarChar).Value = modal.StateID ?? 0;
                        command.Parameters.Add("@CityID", SqlDbType.VarChar).Value = modal.CityID ?? 0;
                        command.Parameters.Add("@PINCode", SqlDbType.VarChar).Value = modal.PINCode ?? "";
                        command.Parameters.Add("@Address", SqlDbType.VarChar).Value = modal.Address ?? "";

                        command.Parameters.Add("@AadharNo", SqlDbType.VarChar).Value = modal.AadharNo ?? "";
                        command.Parameters.Add("@PAN", SqlDbType.VarChar).Value = modal.PAN ?? "";
                        command.Parameters.Add("@ESIC", SqlDbType.VarChar).Value = modal.ESIC ?? "";
                        command.Parameters.Add("@UAN", SqlDbType.VarChar).Value = modal.UAN ?? "";

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

      
        public PostResponse fnSetOnboarding_BankDetails(Onboarding.Users.BankDetails modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboarding_BankDetails", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = modal.Token ?? "";
                        command.Parameters.Add("@BankName", SqlDbType.VarChar).Value = modal.BankName ?? "";
                        command.Parameters.Add("@AccountNo", SqlDbType.VarChar).Value = modal.AccountNo ?? "";
                        command.Parameters.Add("@IFSCCode", SqlDbType.VarChar).Value = modal.IFSCCode;
                        command.Parameters.Add("@BankBranch", SqlDbType.VarChar).Value = modal.BankBranch;

                        command.Parameters.Add("@NomineeName", SqlDbType.VarChar).Value = modal.NomineeName??"";
                        command.Parameters.Add("@NomineeRelation", SqlDbType.VarChar).Value = modal.NomineeRelation??"";
                        command.Parameters.Add("@NomineeDOB", SqlDbType.DateTime).Value = modal.NomineeDOB;

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

        public PostResponse fnSetOnboarding_Final(Onboarding.Users.DocumentDetails modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetOnboarding_Final", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Token", SqlDbType.VarChar).Value = modal.Token ?? "";
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
