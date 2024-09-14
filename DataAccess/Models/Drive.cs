using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
   public class Drive
    {
       public class Folder
        {
            public string Name { get; set; }
            public string Path { get; set; }
            public bool IsChild { get; set; }
            public List<Folder> ChildList { get; set; }
        }
    }
}
