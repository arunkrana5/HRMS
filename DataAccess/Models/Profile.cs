using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
    public class Profile
    {
        public long EMPID { get; set; }
        public long LoginID { get; set; }
        public string EMPCode { get; set; }
        public string EMPName { get; set; }
        public string Phone { get; set; }
        public string PAN { get; set; }
        public string EmailID { get; set; }
        public string FatherName { get; set; }
        public string DOB { get; set; }
        public string DOJ { get; set; }
        public string Gender { get; set; }
        public string DesignName { get; set; }
        public string DepartName { get; set; }
        public string UserID { get; set; }
        public string ImageURL { get; set; }
        public string UAN { get; set; }
        public string ESIC { get; set; }
        public string PaymentMode { get; set; }
        public string rolename { get; set; }
        public List<Bank.List> BankList { get; set; }
        public List<Address.List> AddressList { get; set; }

        public string ImageBase64String { get; set; }
    }
}
