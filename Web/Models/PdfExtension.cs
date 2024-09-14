using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Syncfusion.Pdf;
using System.Web;
using System.Web.UI;
using Syncfusion.Pdf.Parsing;

namespace Syncfusion.Mvc.Pdf
{

    public static class PdfExtension
    {
        public static PdfResult ExportAsActionResult(this PdfDocument PdfDoc, string filename, HttpResponse response, HttpReadType type)
        {
            return new PdfResult(PdfDoc, filename, response, type);
        }
        public static PdfResult ExportAsActionResult(this PdfLoadedDocument pdfdoc, string filename, HttpResponse response, HttpReadType type)
        {
            return new PdfResult(pdfdoc, filename, response, type);

        }

       
    }
}
