using System.ComponentModel.DataAnnotations;

namespace DataAccess.Models
{
    public class Masters
    {

        public class List
        {
            public int RowNum { get; set; }
            public long MasterID { get; set; }
            public string TableName { get; set; }
            public string Name { get; set; }
            public string Value { get; set; }
            public long GroupID { get; set; }
            public string GroupName { get; set; }
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
            public long MasterID { get; set; }
            public string TableName { get; set; }

            [Required(ErrorMessage = "Name Can't be Blank")]
            public string Name { get; set; }
            [Required(ErrorMessage = "Value Can't be Blank")]
            public string Value { get; set; }
            [Required(ErrorMessage = "Can't be Blank")]
            public long GroupID { get; set; }
            public string GroupName { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

        }
    }

    public class DealerType
    {
        public class List
        {
            public int RowNum { get; set; }
            public long DealerTypeID { get; set; }
            public string Name { get; set; }
            public string Code { get; set; }

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
            public long DealerTypeID { get; set; }

            [Required(ErrorMessage = "Name Can't be Blank")]
            public string Name { get; set; }
            [Required(ErrorMessage = "Code Can't be Blank")]
            public string Code { get; set; }
            public bool IsActive { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }

        }
    }
}

