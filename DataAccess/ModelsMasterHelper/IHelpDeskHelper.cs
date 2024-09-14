using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.ModelsMasterHelper
{
    public interface IHelpDeskHelper
    {
        List<Helpdesk.Category.List> GetHelpdesk_CategoryList(GetResponse Modal);
        Helpdesk.Category.Add GetHelpdesk_Category(GetResponse Modal);
        PostResponse fnSetHelpdesk_Category(Helpdesk.Category.Add modal);
        List<Helpdesk.SubCategory.List> GetHelpdesk_SubCategoryList(GetResponse Modal);
        Helpdesk.SubCategory.Add GetHelpdesk_SubCategory(GetResponse Modal);
        PostResponse fnSetHelpdesk_SubCategory(Helpdesk.SubCategory.Add modal);
        List<Helpdesk.Status.List> GetHelpdesk_StatusList(GetResponse Modal);
        Helpdesk.Status.Add GetHelpdesk_Status(GetResponse Modal);
        PostResponse fnSetHelpdesk_Status(Helpdesk.Status.Add modal);

        List<Helpdesk.Ticket.List> GetHelpdesk_Tickets_List(MyTab.Approval Modal);
        PostResponse fnSetHelpdesk_Ticket(Helpdesk.Ticket.Add modal);
        Helpdesk.Ticket.Details GetHelpdesk_Ticket_Details(GetResponse Modal);
        PostResponse fnSetHelpdesk_Ticket_Notes(Helpdesk.Notes.Add modal);


    }
}
