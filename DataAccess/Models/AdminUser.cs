using System.ComponentModel.DataAnnotations;

namespace DataAccess.Models
{
    public class AdminUser
    {
        public class Details
        {
            public bool status { get; set; }
            public long LoginID { get; set; }
            public string UserID { get; set; }
            public long RoleID { get; set; }
            public string Phone { get; set; }
            public string Email { get; set; }
            public string Name { get; set; }
            public string RoleName { get; set; }
            public bool IsFirstLogin { get; set; }

            public string ImageURL { get; set; }

          



        }
        public class Login
        {

            [Required(ErrorMessage = "User Name Can't Be Blank")]
            public string UserName { get; set; }
            [Required(ErrorMessage = "Password Can't Be Blank")]
            public string Password { get; set; }
            public string IPAddress { get; set; }
            public string SessionID { get; set; }
            public string grant_type { get; set; }
            
            public bool RememberMe { get; set; }
            public Login()
            {
                grant_type = "password";
            }

        }

        public class Role
        {
            public class List
            {
                public long RoleID { get; set; }
                public string rolename { get; set; }
                public string description { get; set; }
               
                public bool IsActive { get; set; }
                public string CreatedBy { get; set; }
                public string CreatedDate { get; set; }
                public string ModifiedDate { get; set; }
                public string ModifiedBy { get; set; }
                public string IPAddress { get; set; }
            }
            public class Add
            {
                public long RoleID { get; set; }
                [Required(ErrorMessage = "Role Name Can't Be Blank")]
                public string rolename { get; set; }
                public string description { get; set; }
                public string IPAddress { get; set; }
                public long LoginID { get; set; }
                public int? Priority { get; set; }
                public bool IsActive { get; set; }
            }
        }
        public class TokenDetails
        {
            public string access_token { get; set; }
            public string token_type { get; set; }
            public string expires_in { get; set; }
            public string client_id { get; set; }
            public string userName { get; set; }
            public string userDetails { get; set; }
            public string issued { get; set; }
            public string expires { get; set; }
        }
    }
    public class Users
    {
        public class List
        {
            public int RowNum { get; set; }
            public long ID { get; set; }
            public string UserID { get; set; }
            public int RoleID { get; set; }
            public string rolename { get; set; }
            public string Phone { get; set; }
            public string Name { get; set; }
            public string Password { get; set; }
            public string Description { get; set; }
            public string email { get; set; }
            
            public int Priority { get; set; }
            public bool IsActive { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }
        public class Add
        {
            public long ID { get; set; }
            [Required(ErrorMessage = "User ID Can't Be Blank")]
            [RegularExpression(@"^.{5,}$", ErrorMessage = "Minimum 5 characters required")]
            public string UserID { get; set; }

            [Required(ErrorMessage = "Role Can't Be Blank")]
            public int RoleID { get; set; }
            public string RoleName { get; set; }
           
            [Required(ErrorMessage = "Name Can't Be Blank")]
            public string Name { get; set; }
            [Required(ErrorMessage = "Password Can't Be Blank")]
            public string Password { get; set; }
            public string Description { get; set; }

            [Required(ErrorMessage = "Phone Can't Be Blank")]
            public string Phone { get; set; }

            [Required(ErrorMessage = "Email Can't Be Blank")]
            [StringLength(50, ErrorMessage = "Allowed Maximum Length 50 Characters")]
            [DataType(DataType.EmailAddress)]
            [EmailAddress]
            public string email { get; set; }
            public int? Priority { get; set; }
            public long LoginID { get; set; }

            public string IPAddress { set; get; }
        }
    }


    public class ChangePassword
    {
        public long LoginID { get; set; }
        [Required(ErrorMessage = "New Password Can't Be Blank")]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "Confirm Password Can't Be Blank")]
        public string ConfirmPassword { get; set; }
        [Required(ErrorMessage = "Old Password Can't Be Blank")]
        public string OldPassword { get; set; }

        public string Doctype { get; set; }
        public string IPAddress { get; set; }
    }

    public class ForgotPassword
    {
        [Required(ErrorMessage = "User ID Can't Be Blank")]
        public string UserID { get; set; }
    }

    public class SetPassword
    {
        [Required(ErrorMessage = "New Password Can't Be Blank")]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "Confirm Password Can't Be Blank")]
        public string ConfirmPassword { get; set; }
        public string IPAddress { get; set; }

    }

    public class FileModel
    {
        public string FileName { get; set; }
    }
}
