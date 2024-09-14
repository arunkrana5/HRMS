using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace DataAccess.Models
{
    public class Helpdesk
    {
        public class Ticket
        {
            public class List
            {
                public long TicketID { get; set; }
                public string TicketNo { get; set; }
                public string DocDate { get; set; }
                public long CurrentStatusID { get; set; }
                public string CurrentStatus { get; set; }
                public string CurrentStatus_Color { get; set; }
                public string CurrentStatus_Icon { get; set; }
                public long CategoryID { get; set; }
                public string CategoryName { get; set; }
                public long SubCategoryID { get; set; }
                public string SubCategoryName { get; set; }
                public string Subject { get; set; }
                public string Message { get; set; }
                public string TicketPriority { get; set; }

                public string Latest_Notes { get; set; }
                public string Latest_NextDate { get; set; }
                public string CreatedBy { get; set; }
                public string CreatedDate { get; set; }
                public string ModifiedDate { get; set; }
                public string ModifiedBy { get; set; }
                public string IPAddress { get; set; }
            }
            public class Add
            {
                public long? TicketID { get; set; }
                [Required(ErrorMessage = "Subject Can't be Blank")]
                public string Subject { get; set; }

              public string TempID { get; set; }
                public string Message { get; set; }

                [Required(ErrorMessage = "Ticket Priority Can't be Blank")]
                public string TicketPriority { get; set; }

                public long? CategoryID { get; set; }
                public long? SubCategoryID { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
                public List<DropDownlist> CategoryList { get; set; }
                public List<DropDownlist> SubCategoryList { get; set; }
                public List<long> OptionalUsers { get; set; }
                public List<DropDownlist> UserList { get; set; }

                public List<HttpPostedFileBase> Upload { get; set; }
            }


            public class Details
            {
                public List TicketDetails { get; set; }
                public List<Users> AssigneeList { get; set; }
                public List<Users> DeferredList { get; set; }
                public List<Notes.List> NotesList { get; set; }
                public List<Attachment> AttachmentList { get; set; }

            }
        }


        // All <Masters
        public class Status
        {
            public class List
            {
                public long StatusID { get; set; }
                public string StatusName { get; set; }
                public string DisplayName { get; set; }
                public string Icon { get; set; }
                public string Color { get; set; }
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
                public long StatusID { get; set; }
                [Required(ErrorMessage = "Status Can't be Blank")]
                public string StatusName { get; set; }
                [Required(ErrorMessage = "Display Name Can't be Blank")]
                public string DisplayName { get; set; }
                public string Icon { get; set; }
                public string Color { get; set; }
                public bool IsActive { get; set; }
                public int? Priority { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
            }
        }

        public class Category
        {
            public class List
            {
                public long CategoryID { get; set; }
                public string CategoryName { get; set; }
                public string CategoryDesc { get; set; }
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
                public long CategoryID { get; set; }
                [Required(ErrorMessage = "Category Name Can't be Blank")]
                public string CategoryName { get; set; }
                [Required(ErrorMessage = "Category Desc Can't be Blank")]
                public string CategoryDesc { get; set; }
                public bool IsActive { get; set; }
                public int? Priority { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
            }
        }

        public class SubCategory
        {
            public class List
            {
                public long SubCategoryID { get; set; }
                public long CategoryID { get; set; }
                public string CategoryName { get; set; }

                public string Users { get; set; }
                public string SubName { get; set; }
                public string SubDesc { get; set; }
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
                public long? SubCategoryID { get; set; }
                [Required(ErrorMessage = "Category Can't be Blank")]
                public long? CategoryID { get; set; }
                [Required(ErrorMessage = "Sub Category Name Can't be Blank")]
                public string SubName { get; set; }
                [Required(ErrorMessage = "Sub Category Desc Can't be Blank")]
                public string SubDesc { get; set; }
                public bool IsActive { get; set; }
                public int? Priority { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }

                public List<DropDownlist> CatgeoryList { get; set; }

                [Required(ErrorMessage = "Users Can't be Blank")]
                public List<long> IDs { get; set; }
                public List<DropDownlist> UserList { get; set; }
            }
        }

        public class Notes
        {
            public class List
            {
                public long NotesID { get; set; }
                public string DisplayName { get; set; }
                public string Color { get; set; }
                public string icon { get; set; }
                public string Notes { get; set; }
                public string NextDate { get; set; }
                public string CreatedBy { get; set; }
                public string CreatedDate { get; set; }
                public string ModifiedDate { get; set; }
                public string ModifiedBy { get; set; }
                public string IPAddress { get; set; }
            }
            public class Add
            {
                public long? TicketID { get; set; }
                public long? NotesID { get; set; }
                public long? UserID { get; set; }

              public string TempID { get; set; }
                public string Notes { get; set; }
                [Required(ErrorMessage = "Notes Can't be Blank")]
                public long? StatusID { get; set; }
                public DateTime? NextDate { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
                public List<DropDownlist> StatusList { get; set; }
                public List<DropDownlist> UserList { get; set; }
                public List<HttpPostedFileBase> Upload { get; set; }
            }
        }

        public class Users
        {
            public long LoginID { get; set; }
            public string EMPName { get; set; }
            public string EmailID { get; set; }
            public string Doctype { get; set; }
        }



        public class Count
        {
            public int Total { get; set; }
            public int Pending { get; set; }
            public int InProcess { get; set; }
            public int Forward { get; set; }
            public int Completed { get; set; }

            public long LoginID { get; set; }
            public string IPAddress { get; set; }

        }


        public class Attachment
        {
            public string FileName { get; set; }
            public string contenttype { get; set; }
            public string Description { get; set; }
            public string Filepath { get; set; }
            public long? ID { get; set; }
            public string TempID { get; set; }
            public long TicketID { get; set; }
            public long NotesID { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
    }
}
