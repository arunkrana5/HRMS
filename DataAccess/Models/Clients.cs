using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
   public class Clients
    {
        public class List
        {
            public int RowNum { get; set; }
            public long ClientID { get; set; }
            public string ClientCode { get; set; }
            public string ClientName { get; set; }
            public string DisplayName { get; set; }

            public string OtherCode { get; set; }
            public bool IsActive { get; set; }
            public int Priority { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }

        public class Add
        {
            public long ClientID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string ClientCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string ClientName { get; set; }

            [Required(ErrorMessage = "Display Name Can't be Blank")]
            public string DisplayName { get; set; }

            [Required(ErrorMessage = "Other Code Can't be Blank")]
            public string OtherCode { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
    }

    public class ClientsTran
    {
        public class List
        {
            public int RowNum { get; set; }
            public long ClientTranID { get; set; }
            public long ClientID { get; set; }
            public string Code { get; set; }
            public string Name { get; set; }
            public string PrintName { get; set; }
            public string GSTNo { get; set; }
            public string PAN { get; set; }
            public string Commission { get; set; }

            public string StateName { get; set; }
            public string StateCode { get; set; }
            public string StateTIN { get; set; }
            public bool IsActive { get; set; }
            public int Priority { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }

        public class Add
        {
            public long? ClientTranID { get; set; }
            public long? ClientID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string Code { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string Name { get; set; }

            [Required(ErrorMessage = "Print Name Can't be Blank")]
            public string PrintName { get; set; }

            [Required(ErrorMessage = "GST No Can't be Blank")]
            public string GSTNo { get; set; }

            [Required(ErrorMessage = "PAN Can't be Blank")]
            public string PAN { get; set; }

            [Required(ErrorMessage = "Commission Can't be Blank")]
            public float? Commission { get; set; }

            [Required(ErrorMessage = "Country Can't be Blank")]
            public long? CountryID { get; set; }
            [Required(ErrorMessage = "State Can't be Blank")]
            public long? StateID { get; set; }

            [Required(ErrorMessage = "Address Can't be Blank")]
            public string Address { get; set; }

            [Required(ErrorMessage = "ZipCode Can't be Blank")]
            public string ZipCode { get; set; }

            public string Phone { get; set; }
            public string EmailID { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

            public List<DropDownlist> CountryList { get; set; }

            public List<DropDownlist> StateList { get; set; }
        }
    }
}
