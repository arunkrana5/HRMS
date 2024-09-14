using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.ModelsMasterHelper
{
    public interface IOnboardingHelper
    {
        List<Onboarding.List> GetOnboarding_List(MyTab.Approval Modal);
        PostResponse fnSetOnboarding_Create(Onboarding.Create modal);
        Onboarding.View GetOnboarding_View(GetResponse Modal);
        PostResponse fnSetOnboardingApproval(Onboarding.ApprovalAction modal);
        Onboarding.Users.BasicDetails GetOnboarding_BasicDetails(GetResponse Modal);
        Onboarding.Users.BankDetails GetOnboarding_BankDetails(GetResponse Modal);
        Onboarding.Users.DocumentDetails GetOnboarding_Documents(GetResponse Modal);

        PostResponse fnSetOnboarding_BasicDetails(Onboarding.Users.BasicDetails modal);
        PostResponse fnSetOnboarding_BankDetails(Onboarding.Users.BankDetails modal);
        PostResponse fnSetOnboarding_Final(Onboarding.Users.DocumentDetails modal);
     
    }
}
