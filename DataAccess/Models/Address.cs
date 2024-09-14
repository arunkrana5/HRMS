using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.Models
{
    public class Address
    {
        public long? TableID { get; set; }
        public string TableName { get; set; }
        public long? AddressID { get; set; }
        public string Doctype { get; set; }
        public long? CountryID { get; set; }
        public long? StateID { get; set; }
        public string Location { get; set; }
        public long? CityID { get; set; }
        [Required(ErrorMessage = "Address 1 Can't be Blank")]
        public string Address1 { get; set; }

        public string Address2 { get; set; }

        public string Phone { get; set; }
        public string Zipcode { get; set; }

        public long? Priority { get; set; }
        public long LoginID { get; set; }
        public string IPAddress { get; set; }

        public class List
        {
            public string Doctype { get; set; }
            public string Country { get; set; }
            public string State { get; set; }
            public string City { get; set; }
            public long? CountryID { get; set; }
            public long? StateID { get; set; }
            public long? CityID { get; set; }
            public string Address1 { get; set; }
            public string Address2 { get; set; }
            public string Location { get; set; }
            public string Phone { get; set; }
            public string Zipcode { get; set; }
        }


    }
}
