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
    public class BillingModal : IBillingHelper
    {
        public List<Billing.List> GetBillingList(MyTab.Billing Modal)
        {

            List<Billing.List> result = new List<Billing.List>();
            try
            {
                DateTime dt;
                DateTime.TryParse(Modal.Date, out dt);
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();

                    param.Add("@Month", dbType: DbType.Int64, value: dt.Month, direction: ParameterDirection.Input);
                    param.Add("@Year", dbType: DbType.Int64, value: dt.Year, direction: ParameterDirection.Input);
                    param.Add("@FYID", dbType: DbType.Int64, value: Modal.FYID??0, direction: ParameterDirection.Input);
                    param.Add("@ClientCode", dbType: DbType.String, value: Modal.ClientCode??"", direction: ParameterDirection.Input);
                    param.Add("@SC_Code", dbType: DbType.String, value: Modal.SC_Code??"", direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetBillingList", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Billing.List>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetBillingList", "spu_GetBillingList", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }

        public List<Billing.TranList> GetBillingTranList(GetResponse Modal)
        {

            List<Billing.TranList> result = new List<Billing.TranList>();
            try
            {
                DateTime dt;
                DateTime.TryParse(Modal.Date, out dt);
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();

                    param.Add("@BillID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetBilling_Tran", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Billing.TranList>().ToList();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetBilling_Tran", "GetBilling_Tran", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public Billing.Create GetBilling(GetResponse Modal)
        {
            Billing.Create result = new Billing.Create();
            try
            {
                
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@BillID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetBilling", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Billing.Create>().FirstOrDefault();
                        if (!reader.IsConsumed)
                        {
                            result.ClientList = reader.Read<DropDownlist>().ToList();
                            result.SubClientList = new List<DropDownlist>();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.HSNList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.DepartmentList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.DesignationList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.StateList = reader.Read<DropDownlist>().ToList();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.DealerTypeList = reader.Read<DropDownlist>().ToList();
                        }
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetBilling_Tran", "GetBilling_Tran", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public Billing.Create GetBilling_StaffList(GetResponse Modal)
        {
            Billing.Create result = new Billing.Create();
            try
            {
                DateTime dt;
                DateTime.TryParse(Modal.Date, out dt);
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@Month", dbType: DbType.Int64, value: dt.Month, direction: ParameterDirection.Input);
                    param.Add("@Year", dbType: DbType.Int64, value: dt.Year, direction: ParameterDirection.Input);
                    param.Add("@ClientCode", dbType: DbType.String, value: Modal.Param1, direction: ParameterDirection.Input);
                    param.Add("@SubClientCode", dbType: DbType.String, value: Modal.Param2, direction: ParameterDirection.Input);
                    param.Add("@HSNCode", dbType: DbType.String, value: Modal.Param3, direction: ParameterDirection.Input);
                    param.Add("@Department", dbType: DbType.String, value: Modal.Param4, direction: ParameterDirection.Input);
                    param.Add("@Designation", dbType: DbType.String, value: Modal.Param5, direction: ParameterDirection.Input);
                    param.Add("@StateName", dbType: DbType.String, value: Modal.Param6, direction: ParameterDirection.Input);
                    param.Add("@DealerType", dbType: DbType.String, value: Modal.Param7, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetBilling_StaffList", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<Billing.Create>().FirstOrDefault();
                        if (result == null)
                        {
                            result = new Billing.Create();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.StaffList = reader.Read<Billing.AddStaff>().ToList();
                        }
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetBilling_Tran", "GetBilling_Tran", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }


        public PostResponse fnSetBilling_Staff(Billing.Create modal)
        {
            PostResponse Result = new PostResponse();
            using (SqlConnection con = new SqlConnection(ClsCommon.ConnectionString()))
            {
                try
                {
                    string[] RemoveColomnIndex = { "IsChecked" };
                    DateTime dt;
                    DateTime.TryParse(modal.Date, out dt);
                    con.Open();
                    using (SqlCommand command = new SqlCommand("spu_SetBilling_Staff", con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter();
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@BillID", SqlDbType.Int).Value = modal.BillID??0;
                        command.Parameters.Add("@Month", SqlDbType.Int).Value = dt.Month;
                        command.Parameters.Add("@Year", SqlDbType.Int).Value = dt.Year;
                        command.Parameters.Add("@EMPCount", SqlDbType.Int).Value = modal.EMPCount ?? 0;
                        command.Parameters.Add("@DocNo_Series", SqlDbType.VarChar).Value = modal.DocNo_Series ?? 0;
                        command.Parameters.Add("@SC_Code", SqlDbType.VarChar).Value = modal.SC_Code ?? "";
                        command.Parameters.Add("@HSNCode", SqlDbType.VarChar).Value = modal.HSNCode ?? "";
                        command.Parameters.Add("@DealerType", SqlDbType.VarChar).Value = modal.DealerType ?? "";
                        command.Parameters.Add("@Department", SqlDbType.VarChar).Value = modal.Department ?? "";
                        command.Parameters.Add("@Designation", SqlDbType.VarChar).Value = modal.Designation ?? "";
                        command.Parameters.Add("@StateCode", SqlDbType.VarChar).Value = modal.StateName ?? "";
                        command.Parameters.Add("@Description", SqlDbType.VarChar).Value = modal.Description ?? "";

                        command.Parameters.Add("@Gross_Amt", SqlDbType.Decimal).Value = modal.Gross_Amt;
                        command.Parameters.Add("@AgencyPer", SqlDbType.Decimal).Value = modal.AgencyPer;
                        command.Parameters.Add("@AgencyCommission", SqlDbType.Decimal).Value = modal.AgencyCommission;
                        command.Parameters.Add("@IGST", SqlDbType.Decimal).Value = modal.IGST;
                        command.Parameters.Add("@IGST_Amt", SqlDbType.Decimal).Value = modal.IGST_Amt;
                        command.Parameters.Add("@CGST", SqlDbType.Decimal).Value = modal.CGST;
                        command.Parameters.Add("@CGST_Amt", SqlDbType.Decimal).Value = modal.CGST_Amt;
                        command.Parameters.Add("@SGST", SqlDbType.Decimal).Value = modal.SGST;
                        command.Parameters.Add("@SGST_Amt", SqlDbType.Decimal).Value = modal.SGST_Amt;
                        command.Parameters.Add("@Total_Amt", SqlDbType.Decimal).Value = modal.Total_Amt;
                        command.Parameters.Add("@createdby", SqlDbType.Int).Value = modal.LoginID;
                        command.Parameters.Add("@IPAddress", SqlDbType.VarChar).Value = modal.IPAddress;
                        command.Parameters.Add("@StaffList", SqlDbType.Structured).Value = ClsCommon.ToDataTable(modal.StaffList.Where(x=>!string.IsNullOrEmpty(x.IsChecked)).ToList(), RemoveColomnIndex);
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

        public DataSet GetEInvoiceReport(MyTab.Approval Modal)
        {
            DataSet ds = new DataSet();
            try
            {
                DateTime dt;
                DateTime.TryParse(Modal.Month, out dt);
                SqlParameter[] oparam = new SqlParameter[3];
                oparam[0] = new SqlParameter("@Month", dt.Month);
                oparam[1] = new SqlParameter("@Year", dt.Year);
                oparam[2] = new SqlParameter("@LoginID", Modal.LoginID);
                ds = clsDataBaseHelper.ExecuteDataSet("spu_GetEInvoice_Report", oparam);
            }
            catch (Exception ex)
            {
            }
            return ds;

        }

        public PrintBill GetBilling_RPT(GetResponse Modal)
        {

            PrintBill result = new PrintBill();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();

                    param.Add("@BillID", dbType: DbType.Int64, value: Modal.ID, direction: ParameterDirection.Input);
                    param.Add("@LoginID", dbType: DbType.Int64, value: Modal.LoginID, direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetBilling_RPT", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result.Details = reader.Read<PrintBill.BillDetails>().FirstOrDefault();
                        if (result == null)
                        {
                            result.Details = new PrintBill.BillDetails();
                        }
                        if (!reader.IsConsumed)
                        {
                            result.Details.StaffList = reader.Read<PrintBill.StaffList>().ToList();
                        }
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "GetBilling_Tran", "GetBilling_Tran", "DataModal", Modal.LoginID, Modal.IPAddress);
            }
            return result;
        }
    }
}