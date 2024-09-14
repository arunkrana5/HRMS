using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
   public class Billing
    {

        public class List
        {
            public int TranCount { get; set; }
            public long BillID { get; set; }
            public int RowNum { get; set; }
            public string DocNo { get; set; }
            public string DocDate { get; set; }
            public string FYName { get; set; }
            public string Month { get; set; }
            public string Year { get; set; }

            public string Description { get; set; }
            public string Department { get; set; }
            public string Designation { get; set; }
            public string DealerType { get; set; }
            public string DealerName { get; set; }
            public string ClientCode { get; set; }
            public string ClientName { get; set; }
            public string StateName { get; set; }
            public string SC_Code { get; set; }
            public string SC_Name { get; set; }
            public string SC_GSTNo { get; set; }
            public string SC_PANNo { get; set; }
            public string SC_CountryName { get; set; }
            public string SC_CountryCode { get; set; }


            public string SC_StateName { get; set; }
            public string SC_StateCode { get; set; }
            public string SC_ZipCode { get; set; }
            public string SC_Address { get; set; }
            public string SC_Phone { get; set; }
            public string SC_Email { get; set; }
            public string AgencyPer { get; set; }
            public string AgencyCommission { get; set; }
            public string Gross_Amt { get; set; }
            public string HSNCode { get; set; }
            public string IGST { get; set; }
            public string IGST_Amt { get; set; }
            public string CGST { get; set; }
            public string CGST_Amt { get; set; }
            public string SGST_Amt { get; set; }
            public string SGST { get; set; }
            public string Total_Amt { get; set; }
            public int Priority { get; set; }
            public bool IsActive { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }

        public class TranList
        {
            public long BillingTranID { get; set; }
            public long BillID { get; set; }
            public int RowNum { get; set; }
            public string EMPName { get; set; }
            public string EMPCode { get; set; }
            public string DealerName { get; set; }
            public string DealerType { get; set; }
            public string Gender { get; set; }
            public string Department { get; set; }
            public string Designation { get; set; }
            public string State { get; set; }
            public string Location { get; set; }
            public string PayDays { get; set; }
            public string NetPay { get; set; }
            public string Incentive { get; set; }
            public string NetGross { get; set; }
            public string CTC { get; set; }
            public string Tran_AgencyPer { get; set; }
            public string Tran_AgencyCommission { get; set; }
            public string Total { get; set; }
            public int Priority { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }

        }


        public class Create
        {
            public long? BillID { get; set; }
            public string BillingDocNo { get; set; }
            public int? DocNo_Series { get; set; }

            public string DocNo { get; set; }
            [Required(ErrorMessage = "Date Can't be Blank")]
            public string Date { get; set; }
            [Required(ErrorMessage = "Client Can't be Blank")]
            public string ClientCode { get; set; }
            [Required(ErrorMessage = "Sub Client Can't be Blank")]
            public string SC_Code { get; set; }
            public string Description { get; set; }
            [Required(ErrorMessage = "HSN Can't be Blank")]
            public string HSNCode { get; set; }
            public string Department { get; set; }
            public string DealerType { get; set; }
            public string Designation { get; set; }
            public decimal AgencyPer { get; set; }
            public decimal AgencyCommission { get; set; }
            public decimal Gross_Amt { get; set; }
            public decimal IGST { get; set; }
            public decimal IGST_Amt { get; set; }
            public decimal CGST { get; set; }
            public decimal CGST_Amt { get; set; }
            public decimal SGST { get; set; }
            public decimal SGST_Amt { get; set; }
            public decimal Total_Amt { get; set; }
            public int? EMPCount { get; set; }

            public string StateName { get; set; }
            public List<DropDownlist> HSNList { get; set; }
            public List<DropDownlist> ClientList { get; set; }
            public List<DropDownlist> SubClientList { get; set; }

            public List<DropDownlist> DepartmentList { get; set; }

            public List<DropDownlist> DesignationList { get; set; }

            public List<DropDownlist> StateList { get; set; }

            public List<DropDownlist> DealerTypeList { get; set; }

            public List<AddStaff> StaffList { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }

        public class AddStaff
        {
            public string IsChecked { get; set; }
            public string EMPName { get; set; }
            public string EMPCode { get; set; }
            public string DealerName { get; set; }
            public string DealerType { get; set; }
            public string Gender { get; set; }
            public string Department { get; set; }
            public string Designation { get; set; }
            public string State { get; set; }
            public string Location { get; set; }
            public decimal PayDays { get; set; }
            public decimal NetPay { get; set; }
            public decimal Incentive { get; set; }
            public decimal NetGross { get; set; }
            public decimal CTC { get; set; }
            public decimal Tran_AgencyPer { get; set; }
            public decimal Tran_AgencyCommission { get; set; }
            public decimal Total { get; set; }
        }
    }

}
