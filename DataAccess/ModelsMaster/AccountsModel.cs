using Dapper;
using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMasterHelper;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DataAccess.DataModal.ModelsMaster
{
    public class AccountsModel : IAccountsHelper
    {

        public AdminUser.Details GetLogin(AdminUser.Login Model)
        {

            AdminUser.Details result = new AdminUser.Details();
            try
            {
                using (IDbConnection DBContext = new SqlConnection(ClsCommon.ConnectionString()))
                {
                    int commandTimeout = 0;
                    var param = new DynamicParameters();
                    param.Add("@UserID", dbType: DbType.String, value: Model.UserName??"", direction: ParameterDirection.Input);
                    param.Add("@Password", dbType: DbType.String, value: ClsCommon.Encrypt(Model.Password), direction: ParameterDirection.Input);
                    param.Add("@SessionID", dbType: DbType.String, value: Model.SessionID ?? "", direction: ParameterDirection.Input);
                    param.Add("@IPAddress", dbType: DbType.String, value: Model.IPAddress??"", direction: ParameterDirection.Input);
                    DBContext.Open();
                    using (var reader = DBContext.QueryMultiple("spu_GetLogin", param: param, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeout))
                    {
                        result = reader.Read<AdminUser.Details>().FirstOrDefault();
                    }

                    DBContext.Close();
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError(ex.Message.ToString(), ex.ToString(), "spu_GetLogin", "spu_GetLogin", "AccountsModal", 0, "");
            }
            return result;
        }
   

    }
}
