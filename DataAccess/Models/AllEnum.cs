using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
    public class AllEnum
    {
        public enum Target
        {
            _self,
            _blank
        }

        public enum Gender
        {
            [Display(Name = "All")]
            All,
            [Display(Name = "Male")]
            Male,
            [Display(Name = "Female")]
            Female
        }

        public enum MaritalStatus
        {
            [Display(Name = "Single")]
            Single,
            [Display(Name = "Married")]
            Married,
            [Display(Name = "Divorced")]
            Divorced
        }
        public enum BloodGroup
        {
            [Display(Name = "O+")]
            OPositive,
            [Display(Name = "A+")]
            APositive,
            [Display(Name = "B+")]
            BPositive,
            [Display(Name = "AB+")]
            ABPositive,
            [Display(Name = "AB-")]
            ABNegative,
            [Display(Name = "A-")]
            ANegative,
            [Display(Name = "B-")]
            BNegative,
            [Display(Name = "O-")]
            ONegative
        }

        public enum VaccinationStatus
        {
            [Display(Name = "1st Dose")]
            FirstDose,
            [Display(Name = "2nd Dose")]
            SecondDose,
            [Display(Name = "Booster Dose")]
            BoosterDose,
            [Display(Name = "Not Taken Any Dose")]
            NA
        }

        public enum Metropolitan
        {
            [Display(Name = "Metro")]
            Metro,
            [Display(Name = "Non-Metro")]
            NonMetro
        }

    }
    public class DropDownlist
    {
        public long ID { get; set; }
        public string Name { get; set; }
        public string Other { get; set; }

    }
}
