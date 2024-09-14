using System.ComponentModel.DataAnnotations;

namespace DataAccess.Models
{
    public class Department
    {
        public class List
        {
            public int RowNum { get; set; }
            public long DeptID { get; set; }
            public string DeptName { get; set; }
            public string DeptCode { get; set; }
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
            public long DeptID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string DeptCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string DeptName { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
    }


    public class Designation
    {
        public class List
        {
            public int RowNum { get; set; }
            public long DesignID { get; set; }
            public string DesignName { get; set; }
            public string DesignCode { get; set; }
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
            public long DesignID { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string DesignCode { get; set; }
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string DesignName { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
    }
}
