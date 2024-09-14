using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using static DataAccess.Models.AllEnum;
using static DataAccess.Models.Billing;

namespace DataAccess.Models
{
    public class Onboarding
    {
        public class List
        {
            public int AppID { get; set; }
            public long MasterID { get; set; }
            public string DocNo { get; set; }
            public string DocDate { get; set; }
            public string Name { get; set; }
            public string Token { get; set; }
            public string Gender { get; set; }
            public string Mobile { get; set; }
            public string EmailID { get; set; }
            public string FatherName { get; set; }
            public string DOB { get; set; }
            public string BloodGroup { get; set; }

            public string MaritalStatus { get; set; }
           
         
            public string CountryName { get; set; }
            public string RegionName { get; set; }
            public string StateName { get; set; }
            public string CityName { get; set; }
            public string PINCode { get; set; }

            public string Metropolitan { get; set; }
            public string Address { get; set; }
            public string NomineeName { get; set; }
            public string NomineeDOB { get; set; }
            public string NomineeRelation { get; set; }
            public string PAN { get; set; }
            public string AadharNo { get; set; }
          
           
          
            public string UAN { get; set; }
            public string ESIC { get; set; }
         
            public string BankName { get; set; }
            public string BankBranch{ get; set; }
            public string AccountNo { get; set; }
            public string IFSCCode { get; set; }
            public string Remarks { get; set; }
            public int Approved { get; set; }
            public string ApprovedRemarks { get; set; }
            public string ApprovedDate { get; set; }
            public string ApprovedBy { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }


        public class Create
        {
            [Required(ErrorMessage = "Name Can't be Blank")]
            public string Name { get; set; }
            [Required(ErrorMessage = "Gender Can't be Blank")]
            public Gender? Gender { get; set; }
            [Required(ErrorMessage = "Mobile Can't be Blank")]
            public string Mobile { get; set; }
            [Required(ErrorMessage = "Email Can't be Blank")]
            [EmailAddress]
            public string EmailID { get; set; }
            [Required(ErrorMessage = "Father Name  Can't be Blank")]
            public string FatherName { get; set; }
            [Required(ErrorMessage = "DOB Can't be Blank")]
            public string DOB { get; set; }
            public string Token { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }

        public class Documents
        {
            public string FileName { get; set; }
            public string contenttype { get; set; }
            public string Description { get; set; }
            public string AttachmentPath { get; set; }
            public long? ID { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
        }
        public class View
        {
            public int AppID { get; set; }
            public string DocNo { get; set; }
            public string DocDate { get; set; }
            public string Name { get; set; }
            public string Gender { get; set; }
            public string Mobile { get; set; }
            public string EmailID { get; set; }
            public string FatherName { get; set; }
            public string DOB { get; set; }
            public string BloodGroup { get; set; }

            public string MaritalStatus { get; set; }
           
           

            public string CountryName { get; set; }
            public string RegionName { get; set; }
            public string StateName { get; set; }
            public string CityName { get; set; }
            public string PINCode { get; set; }

          
            public string Address { get; set; }
            public string NomineeName { get; set; }
            public string NomineeDOB { get; set; }
            public string NomineeRelation { get; set; }
            public string PAN { get; set; }
            public string AadharNo { get; set; }
          
        
          

           
            public string UAN { get; set; }
            public string ESIC { get; set; }
          
            public string BankName { get; set; }
            public string BankBranch { get; set; }
            public string AccountNo { get; set; }
            public string IFSCCode { get; set; }
            public string Remarks { get; set; }
            public int Approved { get; set; }
            public string ApprovedStatus { get; set; }
            public string ApprovedRemarks { get; set; }
            public string ApprovedDate { get; set; }
            public string ApprovedBy { get; set; }

         
           
            public string VaccinationDetails { get; set; }
           
           
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }

            public List<Documents> DocumentsList { get; set; }
        }


        public class ApprovalAction
        {
            public string IDs { get; set; }
            public int Approved { get; set; }
            public string ApprovedRemarks { get; set; }
            public long LoginID { get; set; }
            public string IPAddress { get; set; }
            public DateTime dt { get; set; }
            public string Doctype { get; set; }


        }


        public class Users
        {
            public class BasicDetails
            {
                public string Token { get; set; }
                public string DocNo { get; set; }
                public string DocDate { get; set; }

                [Required(ErrorMessage = "Name Can't be Blank")]
                public string Name { get; set; }
                [Required(ErrorMessage = "Gender Can't be Blank")]
                public Gender? Gender { get; set; }

                [Required(ErrorMessage = "Mobile Can't be Blank")]
                public string Mobile { get; set; }

                [Required(ErrorMessage = "Email Can't be Blank")]
                [EmailAddress]
                public string EmailID { get; set; }
                [Required(ErrorMessage = "Father's Name Can't be Blank")]
                public string FatherName { get; set; }

                [Required(ErrorMessage = "DOB Can't be Blank")]
                public string DOB { get; set; }
                [Required(ErrorMessage = "Blood Group Can't be Blank")]
                public BloodGroup? BloodGroup { get; set; }

                [Required(ErrorMessage = "Marital Status Can't be Blank")]
                public MaritalStatus? MaritalStatus { get; set; }

                [Required(ErrorMessage = "Vaccination Status Can't be Blank")]
                public VaccinationStatus? VaccinationDetails { get; set; }

               

               

                [Required(ErrorMessage = "Country Can't be Blank")]
                public int? CountryID { get; set; }

                [Required(ErrorMessage = "Region Can't be Blank")]
                public int? RegionID { get; set; }

                [Required(ErrorMessage = "State Can't be Blank")]
                public int? StateID { get; set; }

                [Required(ErrorMessage = "City Can't be Blank")]

                public int? CityID { get; set; }

              

                [Required(ErrorMessage = "Pin Code Can't be Blank")]
                public string PINCode { get; set; }
               
                [Required(ErrorMessage = "Address Can't be Blank")]
                public string Address { get; set; }


              
                public string UAN { get; set; }

              
                public string ESIC { get; set; }
                [Required(ErrorMessage = "PAN Can't be Blank")]
                public string PAN { get; set; }
                [Required(ErrorMessage = "AadharNo Can't be Blank")]
                public string AadharNo { get; set; }

                public int Approved { get; set; }
                public string ApprovedRemarks { get; set; }
                public string ApprovedStatus { get; set; }
                public string ApprovedDate { get; set; }
                public string ApprovedBy { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
                public List<DropDownlist> CountryList { get; set; }
                public List<DropDownlist> RegionList { get; set; }
                public List<DropDownlist> StateList { get; set; }
                public List<DropDownlist> CityList { get; set; }
            }
            public class BankDetails
            {
                public string Token { get; set; }

                [Required(ErrorMessage = "Bank Name Can't be Blank")]
                public string BankName { get; set; }
                [Required(ErrorMessage = "Account No Can't be Blank")]
                public string AccountNo { get; set; }

                [Required(ErrorMessage = "IFSC Code Can't be Blank")]
                public string IFSCCode { get; set; }

                [Required(ErrorMessage = "Bank Branch Can't be Blank")]
                public string BankBranch { get; set; }

                
                public string NomineeName { get; set; }
              
                public string NomineeDOB { get; set; }

                public string NomineeRelation { get; set; }
                public int Approved { get; set; }
                public string ApprovedRemarks { get; set; }
                public string ApprovedDate { get; set; }
                public string ApprovedBy { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
            }

            public class DocumentDetails
            {
                public string Token { get; set; }
                public int Approved { get; set; }
                public string ApprovedRemarks { get; set; }
                public string ApprovedDate { get; set; }
                public string ApprovedBy { get; set; }
                public List<Documents> DocumentsList { get; set; }
                public long LoginID { get; set; }
                public string IPAddress { get; set; }
            }
            public class Documents
            {
                public long? Attach_ID { get; set; }
                public string AttachmentPath { get; set; }
                public string FileName { get; set; }


                public HttpPostedFileBase Upload { get; set; }

                [Required(ErrorMessage = "Description Can't be Blank")]
                public string Description { get; set; }
            }
        }
    }
}
