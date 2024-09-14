using DataAccess.Models;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace DataAccess.ModelsMasterHelper
{
    public interface IBillingHelper
    {
        List<Billing.List> GetBillingList(MyTab.Billing Modal);
        List<Billing.TranList> GetBillingTranList(GetResponse Modal);
        Billing.Create GetBilling(GetResponse Modal);
        Billing.Create GetBilling_StaffList(GetResponse Modal);
        PostResponse fnSetBilling_Staff(Billing.Create modal);
        DataSet GetEInvoiceReport(MyTab.Approval Modal);
        PrintBill GetBilling_RPT(GetResponse Modal);
    }
}
