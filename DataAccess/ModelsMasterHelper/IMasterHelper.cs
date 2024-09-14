using DataAccess.Models;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace DataAccess.ModelsMasterHelper
{
    public interface IMasterHelper
    {
        List<Masters.List> GetMastersList(GetResponse Modal);
        Masters.Add GetMasters(GetResponse Modal);
        PostResponse fnSetMasters(Masters.Add modal);

       

        List<Department.List> GetDepartmentList(GetResponse Modal);
        Department.Add GetDepartment(GetResponse Modal);
        PostResponse fnSetDepartment(Department.Add modal);

        List<Designation.List> GetDesignationList(GetResponse Modal);
        Designation.Add GetDesignation(GetResponse Modal);
        PostResponse fnSetDesignation(Designation.Add modal);


        List<Clients.List> GetMaster_ClientsList(GetResponse Modal);
        Clients.Add GetMaster_Clients(GetResponse Modal);
        PostResponse fnSetClients(Clients.Add modal);

        List<ClientsTran.List> GetMaster_ClientsTranList(GetResponse Modal);
        ClientsTran.Add GetMaster_ClientsTran(GetResponse Modal);
        PostResponse fnSetMaster_ClientsTran(ClientsTran.Add modal);

        List<Country.List> GetCountryList(GetResponse Modal);
        Country.Add GetCountry(GetResponse Modal);
        PostResponse fnSetCountry(Country.Add modal);

        List<Region.List> GetRegionList(GetResponse Modal);
        Region.Add GetRegion(GetResponse Modal);
        PostResponse fnSetRegion(Region.Add modal);

        List<State.List> GetStateList(GetResponse Modal);
        State.Add GetState(GetResponse Modal);
        PostResponse fnSetState(State.Add modal);


        List<City.List> GetCityList(GetResponse Modal);
        City.Add GetCity(GetResponse Modal);
        PostResponse fnSetCity(City.Add modal);

        List<DealerType.List> GetDealerTypeList(GetResponse Modal);
        DealerType.Add GetDealerType(GetResponse Modal);
        PostResponse fnSetDealerType(DealerType.Add modal);
    }
}
