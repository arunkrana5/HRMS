using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace DataAccess.CommanClass
{
    public class ClsCommon
    {
        public static string GetWebsiteURL()
        {
            var request = HttpContext.Current.Request;
            var address = string.Format("{0}://{1}", request.Url.Scheme, request.Url.Authority);
            return address;
        }
        public static IEnumerable<DateTime> EachDay(DateTime from, DateTime thru)
        {
            for (var day = from.Date; day.Date <= thru.Date; day = day.AddDays(1))
                yield return day;
        }
        public static string GetIPAddress()
        {
            return HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
        }
        public static string EnsureString(string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                str = "";
            }
            return str.Replace("'", "''").Replace("\"", "" + "").Trim();
        }

        public static string Encrypt(string clearText)
        {
            try
            {
                if (!string.IsNullOrEmpty(clearText))
                {
                    string EncryptionKey = "RAISOFT";
                    byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
                    using (Aes encryptor = Aes.Create())
                    {
                        Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                        encryptor.Key = pdb.GetBytes(32);
                        encryptor.IV = pdb.GetBytes(16);
                        using (MemoryStream ms = new MemoryStream())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                            {
                                cs.Write(clearBytes, 0, clearBytes.Length);
                                cs.Close();
                            }
                            clearText = Convert.ToBase64String(ms.ToArray());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during Encrypt. The query was executed :", ex.ToString(), "ClsCommon()", "ClsCommon", "ClsCommon", 0, GetIPAddress());
            }
            return clearText;
        }
        public static string Decrypt(string cipherText)
        {
            try
            {
                if (!string.IsNullOrEmpty(cipherText))
                {
                    string EncryptionKey = "RAISOFT";
                    cipherText = cipherText.Replace(" ", "+");
                    byte[] cipherBytes = Convert.FromBase64String(cipherText);
                    using (Aes encryptor = Aes.Create())
                    {
                        Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                        encryptor.Key = pdb.GetBytes(32);
                        encryptor.IV = pdb.GetBytes(16);
                        using (MemoryStream ms = new MemoryStream())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                            {
                                cs.Write(cipherBytes, 0, cipherBytes.Length);
                                cs.Close();
                            }
                            cipherText = Encoding.Unicode.GetString(ms.ToArray());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during Decrypt. The query was executed :", ex.ToString(), "ClsCommon()", "ClsCommon", "ClsCommon", 0, GetIPAddress());
            }
            return cipherText;
        }

        public static string ConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString.ToString();
        }

        public static DataTable ToDataTable<T>(List<T> items,string [] RemoveColomn=null)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            if(RemoveColomn !=null)
            {
                foreach (var item in RemoveColomn)
                {
                    dataTable.Columns.Remove(item);
                }
            }
            return dataTable;
        }

    }
}
