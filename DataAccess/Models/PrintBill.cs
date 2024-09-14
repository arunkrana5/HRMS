using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
    public class PrintBill
    {
        public BillDetails Details { get; set; }
        public class BillDetails
        {
            public long BillID { get; set; }
            public string DocNo { get; set; }
            public string DocDate { get; set; }
            public long FYID { get; set; }
            public string FyName { get; set; }
            public int Month { get; set; }
            public int Year { get; set; }
            public string MonthYear { get; set; }
            public string Description { get; set; }
            public string Department { get; set; }
            public string Designation { get; set; }
            public string ClientCode { get; set; }
            public string ClientName { get; set; }
            public string SC_Code { get; set; }
            public string SC_Name { get; set; }
            public string SC_GSTNo { get; set; }
            public string SC_PANNo { get; set; }
            public string SC_CountryName { get; set; }
            public string SC_CountryCode { get; set; }
            public string SC_StateName { get; set; }
            public string SC_StateCode { get; set; }
            public string SC_ZipCode { get; set; }
            public string SC_StateTIN { get; set; }
            public string SC_Address { get; set; }
            public string SC_Phone { get; set; }
            public string SC_Email { get; set; }
            public decimal AgencyPer { get; set; }
            public decimal AgencyCommission { get; set; }
            public decimal Gross_Amt { get; set; }
            public string HSNCode { get; set; }
            public decimal IGST { get; set; }
            public decimal IGST_Amt { get; set; }
            public decimal CGST { get; set; }
            public decimal CGST_Amt { get; set; }
            public decimal SGST_Amt { get; set; }
            public decimal SGST { get; set; }
            public decimal Total_Amt { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
            public List<StaffList> StaffList { get; set; }
        }

        public class StaffList
        {
            public string MonthYear { get; set; }
            public string EMPCode { get; set; }
            public string EMPName { get; set; }
            public string DealerName { get; set; }
            public string DealerType { get; set; }
            public string Gender { get; set; }
            public string Department { get; set; }
            public string Designation { get; set; }
            public string State { get; set; }
            public string Location { get; set; }
            public float PayDays { get; set; }
            public float NetPay { get; set; }
            public float Incentive { get; set; }
            public float NetGross { get; set; }
            public float CTC { get; set; }
            public float Tran_AgencyPer { get; set; }
            public float Tran_AgencyCommission { get; set; }
            public float Total { get; set; }
        }

    }
    
}
