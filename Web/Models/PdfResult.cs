using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Syncfusion.Pdf.Graphics;
using Syncfusion.Pdf;
using System.Web.Mvc;
using Syncfusion.Pdf.Parsing;


namespace Syncfusion.Mvc.Pdf
{
    public class PdfResult : ActionResult
    {
        private string m_filename;
        private PdfDocument m_pdfDocument;
        private PdfLoadedDocument m_pdfLoadedDocument;
        private HttpResponse m_response;
        private HttpReadType m_readType;

        public string FileName
        {
            get
            {
                return m_filename;
            }
            set
            {
                m_filename = value;
            }
        }
        public PdfDocument PdfDoc
        {
            get
            {
                if (m_pdfDocument != null)
                    return m_pdfDocument;
                return null;
            }
        }
        public PdfLoadedDocument pdfLoadedDoc
        {
            get
            {
                if (m_pdfLoadedDocument != null)
                    return m_pdfLoadedDocument;
                return null;
            }
        }
        public HttpResponse Response
        {
            get
            {
                return m_response;
            }
        }
        public HttpReadType ReadType
        {
            get
            {
                return m_readType;
            }
            set
            {
                m_readType = value;
            }
        }

        public PdfResult(PdfDocument pdfDocument, string filename, HttpResponse respone, HttpReadType type)
        {
            this.m_pdfDocument = pdfDocument;
            this.m_pdfLoadedDocument = null;
            this.FileName = filename;
            this.m_response = respone;
            this.ReadType = type;
            
        }

        public PdfResult(PdfLoadedDocument pdfLoadedDocument, string filename, HttpResponse respone, HttpReadType type)
        {
            this.m_pdfDocument = null;
            this.m_pdfLoadedDocument = pdfLoadedDocument;
            this.FileName = filename;
            this.m_response = respone;
            this.ReadType = type;
        }
        public  override void ExecuteResult(ControllerContext context)
        {
            if (context == null)
                return;
            if (pdfLoadedDoc != null)
                this.pdfLoadedDoc.Save(FileName, Response, ReadType);
            if (PdfDoc != null)
            {
                this.PdfDoc.Save(FileName, Response, ReadType);
                this.PdfDoc.Close(true);
            }
        }


    }
}
