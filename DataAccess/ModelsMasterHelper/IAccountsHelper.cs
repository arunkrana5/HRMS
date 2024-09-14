using DataAccess.Models;

namespace DataAccess.ModelsMasterHelper
{
    public interface IAccountsHelper
    {
        AdminUser.Details GetLogin(AdminUser.Login Model);
       
    }
}
