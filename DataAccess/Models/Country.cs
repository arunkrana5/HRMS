using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
   public class Country
    {
        public class List
        {
            public int RowNum { get; set; }
            public long CountryID { get; set; }
            public string CountryName { get; set; }
            public string CountryCode { get; set; }
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
            public long CountryID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string CountryCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string CountryName { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
    }

    public class Region
    {
        public class List
        {
            public int RowNum { get; set; }
            public long CountryID { get; set; }
            public string CountryName { get; set; }
            public long RegionID { get; set; }
            public string RegionName { get; set; }
            public string RegionCode { get; set; }
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
            public long RegionID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string RegionCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string RegionName { get; set; }

            [Required(ErrorMessage = "Country Can't be Blank")]
            public long? CountryID { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

            public List<DropDownlist> CountryList { get; set; }
        }
    }

    public class State
    {
        public class List
        {
            public int RowNum { get; set; }
            public long StateID { get; set; }
            public string StateName { get; set; }
            public string StateCode { get; set; }
            public long RegionID { get; set; }
            public string RegionName { get; set; }
            public string RegionCode { get; set; }
            public string Tin { get; set; }
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
            public long StateID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string StateCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string StateName { get; set; }

            [Required(ErrorMessage = "Region Can't be Blank")]
            public long? RegionID { get; set; }

            [Required(ErrorMessage = "TIN Can't be Blank")]
            public string Tin { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

            public List<DropDownlist> RegionList { get; set; }
        }
    }

    public class City
    {
        public class List
        {
            public int RowNum { get; set; }
            public long CityID { get; set; }
            public string CityName { get; set; }
            public string CityCode { get; set; }
            public long StateID { get; set; }
            public string StateName { get; set; }
            public string StateCode { get; set; }
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
            public long CityID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string CityCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string CityName { get; set; }

            [Required(ErrorMessage = "State Can't be Blank")]
            public long? StateID { get; set; }

            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

            public List<DropDownlist> StateList { get; set; }
        }
    }
}
