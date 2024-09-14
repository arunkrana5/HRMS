namespace DataAccess.Models
{
    public class ErrorLog
    {
        public long ID { set; get; }
        public string ErrorDescription { set; get; }
        public string SystemException { set; get; }
        public string ActiveFunction { set; get; }
        public string ActiveForm { set; get; }
        public string ActiveModule { set; get; }
        public int CreatedByID { set; get; }
        public string LoggedAt { set; get; }
        public string CreatedDate { set; get; }
        public string IPAddress { set; get; }
    }
}
