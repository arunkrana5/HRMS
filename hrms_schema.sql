USE [HRMS]
GO
/****** Object:  UserDefinedTableType [dbo].[BillingStaff_Type]    Script Date: 14-09-2024 05:56:23 PM ******/
CREATE TYPE [dbo].[BillingStaff_Type] AS TABLE(
	[EMPName] [varchar](500) NULL,
	[EMPCode] [varchar](500) NULL,
	[DealerName] [varchar](500) NULL,
	[DealerType] [varchar](500) NULL,
	[Gender] [varchar](10) NULL,
	[Department] [varchar](500) NULL,
	[Designation] [varchar](500) NULL,
	[State] [varchar](500) NULL,
	[Location] [varchar](500) NULL,
	[PayDays] [decimal](18, 2) NULL,
	[NetPay] [decimal](18, 2) NULL,
	[Incentive] [decimal](18, 2) NULL,
	[NetGross] [decimal](18, 2) NULL,
	[CTC] [decimal](18, 2) NULL,
	[Tran_AgencyPer] [decimal](18, 2) NULL,
	[Tran_AgencyCommission] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FileExists]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_FileExists](@path varchar(512))
RETURNS BIT
AS
BEGIN
     DECLARE @result INT
     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
     RETURN cast(@result as bit)
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetFinancialYearID]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetFinancialYearID](@Date datetime)
RETURNS int
AS
BEGIN
     DECLARE @result INT

	 Select @result=isnull(FINID,0) from Financial_Years
	 where Isdeleted=0 and IsActive=1 and cast(@Date as date) between StartDate and EndDate
     RETURN cast(@result as Int)

END;
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetAttachPath]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetAttachPath]
(
	@AttachmentID int
)
RETURNS varchar(max) 
AS
BEGIN 
	DECLARE @ColList Varchar(MAX)='';
	SELECT @ColList = '/Attachments/' + a.FileName +''+a.ContentType
	FROM master_attachment a	
			
	WHERE a.Attach_ID=@AttachmentID
	
	RETURN @ColList
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetHelpdesk_SubCategory_Users_Values]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetHelpdesk_SubCategory_Users_Values] 
(
	@ID int
)
RETURNS VARCHAR(2000)
AS
BEGIN
	DECLARE @ColList Varchar(MAX)='';

	select  @ColList = @ColList + isnull(B.EMPName,'') + ', '  from Helpdesk_SubCategory_Users as a
	inner join UserEMP_View as B on a.LoginID=B.LoginID
	where a.Isdeleted=0 and a.subCategoryID=@ID
		
	if ((charindex(',',@ColList)>0))
		begin
			set @ColList= Substring(@ColList,1,len(@ColList)-1)
		end
	
	RETURN @ColList
END;
GO
/****** Object:  UserDefinedFunction [dbo].[splitstring]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[splitstring] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
/****** Object:  Table [dbo].[AllMaxID]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllMaxID](
	[Ticket_ID] [bigint] NOT NULL,
	[Ticket_NotesID] [bigint] NOT NULL,
	[BillID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Billing]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Billing](
	[BillID] [bigint] NOT NULL,
	[DocNo] [varchar](500) NOT NULL,
	[DocDate] [datetime] NOT NULL,
	[FYID] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[EMPCount] [int] NOT NULL,
	[DealerType] [varchar](500) NOT NULL,
	[Department] [varchar](500) NOT NULL,
	[Designation] [varchar](500) NOT NULL,
	[ClientCode] [varchar](500) NOT NULL,
	[ClientName] [varchar](500) NOT NULL,
	[StateName] [varchar](500) NOT NULL,
	[SC_Code] [varchar](500) NOT NULL,
	[SC_Name] [varchar](500) NOT NULL,
	[SC_GSTNo] [varchar](500) NOT NULL,
	[SC_PANNo] [varchar](500) NOT NULL,
	[SC_CountryName] [varchar](500) NOT NULL,
	[SC_CountryCode] [varchar](500) NOT NULL,
	[SC_StateName] [varchar](500) NOT NULL,
	[SC_StateCode] [varchar](500) NOT NULL,
	[SC_StateTIN] [varchar](500) NOT NULL,
	[SC_ZipCode] [varchar](500) NOT NULL,
	[SC_Address] [varchar](500) NOT NULL,
	[SC_Phone] [varchar](500) NOT NULL,
	[SC_Email] [varchar](500) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[AgencyPer] [decimal](18, 2) NOT NULL,
	[AgencyCommission] [decimal](18, 2) NOT NULL,
	[Gross_Amt] [decimal](18, 2) NOT NULL,
	[HSNCode] [varchar](500) NOT NULL,
	[IGST] [decimal](18, 2) NOT NULL,
	[IGST_Amt] [decimal](18, 2) NOT NULL,
	[CGST] [decimal](18, 2) NOT NULL,
	[CGST_Amt] [decimal](18, 2) NOT NULL,
	[SGST] [decimal](18, 2) NOT NULL,
	[SGST_Amt] [decimal](18, 2) NOT NULL,
	[Total_Amt] [decimal](18, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Billing] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Billing_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Billing_Tran](
	[BillingTranID] [bigint] NOT NULL,
	[BillID] [bigint] NOT NULL,
	[EMPName] [varchar](500) NOT NULL,
	[EMPCode] [varchar](500) NOT NULL,
	[DealerType] [varchar](500) NOT NULL,
	[DealerName] [varchar](500) NOT NULL,
	[Gender] [varchar](50) NOT NULL,
	[Department] [varchar](500) NOT NULL,
	[Designation] [varchar](500) NOT NULL,
	[State] [varchar](500) NOT NULL,
	[Location] [varchar](500) NOT NULL,
	[PayDays] [decimal](18, 2) NOT NULL,
	[NetPay] [decimal](18, 2) NOT NULL,
	[Incentive] [decimal](18, 2) NOT NULL,
	[NetGross] [decimal](18, 2) NOT NULL,
	[CTC] [decimal](18, 2) NOT NULL,
	[Tran_AgencyPer] [decimal](18, 2) NOT NULL,
	[Tran_AgencyCommission] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Billing_Tran] PRIMARY KEY CLUSTERED 
(
	[BillingTranID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[ID] [bigint] NOT NULL,
	[CompanyCode] [varchar](50) NOT NULL,
	[SMTP] [varchar](255) NOT NULL,
	[SMTP_USER] [varchar](255) NOT NULL,
	[SMTP_PASSWORD] [varchar](255) NOT NULL,
	[SMTP_EMAIL] [varchar](255) NOT NULL,
	[Port] [varchar](50) NOT NULL,
	[EnableSsl] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfigSetting]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigSetting](
	[ConfigID] [bigint] NOT NULL,
	[Category] [varchar](500) NOT NULL,
	[SubCategory] [varchar](500) NOT NULL,
	[ConfigKey] [varchar](500) NOT NULL,
	[ConfigValue] [varchar](500) NOT NULL,
	[Remarks] [varchar](500) NOT NULL,
	[Help] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ConfigSetting] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailTemplate]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailTemplate](
	[TemplateID] [bigint] NOT NULL,
	[TemplateName] [nvarchar](200) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[Subject] [nvarchar](500) NOT NULL,
	[CCMail] [nvarchar](500) NOT NULL,
	[BCCMail] [nvarchar](500) NOT NULL,
	[Repository] [nvarchar](max) NOT NULL,
	[SMSBody] [nvarchar](1000) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED 
(
	[TemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error_Log]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_Log](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrDescription] [nvarchar](max) NOT NULL,
	[SystemException] [nvarchar](max) NOT NULL,
	[ActiveFunction] [nvarchar](max) NOT NULL,
	[ActiveForm] [nvarchar](max) NOT NULL,
	[ActiveModule] [nvarchar](max) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Error_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Financial_Years]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Financial_Years](
	[FinID] [bigint] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Financial_Years] PRIMARY KEY CLUSTERED 
(
	[FinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Category]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Category](
	[CategoryID] [bigint] NOT NULL,
	[CategoryName] [varchar](50) NOT NULL,
	[CategoryDesc] [varchar](2000) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Status]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Status](
	[StatusID] [bigint] NOT NULL,
	[StatusName] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[Icon] [varchar](50) NOT NULL,
	[Color] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_SubCategory]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_SubCategory](
	[SubCategoryID] [bigint] NOT NULL,
	[CategoryID] [bigint] NOT NULL,
	[SubName] [varchar](500) NOT NULL,
	[SubDesc] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_SubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_SubCategory_Users]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_SubCategory_Users](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SubCategoryID] [int] NOT NULL,
	[LoginID] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_SubCategory_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Ticket]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Ticket](
	[TicketID] [bigint] NOT NULL,
	[TicketNo] [varchar](50) NOT NULL,
	[DocDate] [datetime] NOT NULL,
	[CurrentStatusID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[SubCategoryID] [int] NOT NULL,
	[Subject] [varchar](2000) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[TicketPriority] [varchar](50) NOT NULL,
	[Latest_Notes] [nvarchar](max) NOT NULL,
	[Latest_NextDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Ticket] PRIMARY KEY CLUSTERED 
(
	[TicketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Ticket_Assignee]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Ticket_Assignee](
	[AssignID] [bigint] IDENTITY(1,1) NOT NULL,
	[TicketID] [int] NOT NULL,
	[LoginID] [int] NOT NULL,
	[Doctype] [varchar](50) NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Ticket_Assignee] PRIMARY KEY CLUSTERED 
(
	[AssignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Ticket_Attachments]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Ticket_Attachments](
	[Attach_ID] [bigint] NOT NULL,
	[File] [image] NULL,
	[TempID] [varchar](2000) NOT NULL,
	[TicketID] [int] NOT NULL,
	[NotesID] [int] NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[ContentType] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Ticket_Attachments] PRIMARY KEY CLUSTERED 
(
	[Attach_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Ticket_Deferred]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Ticket_Deferred](
	[DeferredID] [int] IDENTITY(1,1) NOT NULL,
	[TicketID] [int] NOT NULL,
	[LoginID] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Ticket_Deferred] PRIMARY KEY CLUSTERED 
(
	[DeferredID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Helpdesk_Ticket_Notes]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Helpdesk_Ticket_Notes](
	[NotesID] [bigint] NOT NULL,
	[TicketID] [bigint] NOT NULL,
	[StatusID] [int] NOT NULL,
	[NextDate] [datetime] NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Helpdesk_Ticket_Notes] PRIMARY KEY CLUSTERED 
(
	[NotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lead]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lead](
	[LeadID] [int] NOT NULL,
	[TicketNo] [varchar](50) NOT NULL,
	[TicketDate] [datetime] NOT NULL,
	[StatusID] [int] NOT NULL,
	[LeadType] [varchar](50) NOT NULL,
	[CompanyName] [varchar](500) NOT NULL,
	[CompanyBusiness] [varchar](2000) NOT NULL,
	[StateID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[PinCode] [varchar](50) NOT NULL,
	[CompanyType] [varchar](50) NOT NULL,
	[CompanyPayroll] [varchar](50) NOT NULL,
	[RequirementType] [varchar](50) NOT NULL,
	[Tran_NextDate] [datetime] NULL,
	[Tran_Notes] [varchar](max) NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Lead] PRIMARY KEY CLUSTERED 
(
	[LeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lead_Contacts]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lead_Contacts](
	[ContactID] [int] NOT NULL,
	[LeadID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[EmailID] [varchar](50) NOT NULL,
	[Designation] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Lead_Contacts] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lead_Status]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lead_Status](
	[StatusID] [bigint] NOT NULL,
	[StatusName] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[Icon] [varchar](50) NOT NULL,
	[Color] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Lead_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lead_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lead_Tran](
	[LeadTranID] [int] NOT NULL,
	[LeadID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[NextDate] [datetime] NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Lead_Tran] PRIMARY KEY CLUSTERED 
(
	[LeadTranID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_Menu]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_Menu](
	[MenuID] [int] NOT NULL,
	[MenuName] [nvarchar](255) NOT NULL,
	[ParentMenuID] [int] NOT NULL,
	[MenuImage] [nvarchar](255) NOT NULL,
	[MenuURL] [nvarchar](255) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[Target] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_Menu_Role_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_Menu_Role_Tran](
	[TranID] [int] NOT NULL,
	[MenuID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[R] [bit] NOT NULL,
	[W] [bit] NOT NULL,
	[M] [bit] NOT NULL,
	[D] [bit] NOT NULL,
	[E] [bit] NOT NULL,
	[I] [bit] NOT NULL,
	[App] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Menu_Role_Tran] PRIMARY KEY CLUSTERED 
(
	[TranID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_Module]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_Module](
	[ModuleID] [int] NOT NULL,
	[ModuleName] [varchar](50) NOT NULL,
	[ModulePriority] [int] NOT NULL,
	[ModuleIcon] [varchar](50) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Module] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_Roles]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_Roles](
	[RoleID] [bigint] NOT NULL,
	[RoleName] [varchar](500) NOT NULL,
	[description] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_Users]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_Users](
	[LoginID] [bigint] NOT NULL,
	[UserID] [varchar](500) NOT NULL,
	[Password] [varchar](500) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL,
	[LastLogin] [datetime] NOT NULL,
	[IsLogin] [int] NOT NULL,
	[SessionID] [varchar](max) NOT NULL,
	[IsFirstLogin] [bit] NOT NULL,
	[AttachID] [int] NOT NULL,
	[AllowLogin] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Users] PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Address]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Address](
	[AddressID] [int] NOT NULL,
	[Doctype] [varchar](50) NOT NULL,
	[TableID] [int] NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[Address1] [varchar](max) NOT NULL,
	[Address2] [varchar](max) NOT NULL,
	[Location] [varchar](500) NOT NULL,
	[Phone] [varchar](500) NOT NULL,
	[Zipcode] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Attachment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Attachment](
	[Attach_ID] [bigint] NOT NULL,
	[File] [image] NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[TableID] [int] NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[ContentType] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Attachment] PRIMARY KEY CLUSTERED 
(
	[Attach_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Bank]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Bank](
	[BankID] [bigint] NOT NULL,
	[Doctype] [varchar](50) NOT NULL,
	[TableID] [int] NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[BankName] [varchar](500) NOT NULL,
	[AccountNo] [varchar](50) NOT NULL,
	[IFSCCode] [varchar](50) NOT NULL,
	[BranchName] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Bank] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Clients]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Clients](
	[ClientID] [bigint] NOT NULL,
	[ClientCode] [varchar](50) NOT NULL,
	[ClientName] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[OtherCode] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Clients_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Clients_Tran](
	[ClientTranID] [bigint] NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[PrintName] [varchar](50) NOT NULL,
	[GSTNo] [varchar](50) NOT NULL,
	[PAN] [varchar](50) NOT NULL,
	[Commission] [decimal](18, 2) NOT NULL,
	[CountryID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[Address] [varchar](max) NOT NULL,
	[ZipCode] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[EmailID] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Clients_Tran] PRIMARY KEY CLUSTERED 
(
	[ClientTranID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Dealer_Type]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Dealer_Type](
	[DealerTypeID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Dealer_Type] PRIMARY KEY CLUSTERED 
(
	[DealerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Department]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Department](
	[DeptID] [bigint] NOT NULL,
	[DeptCode] [varchar](500) NOT NULL,
	[DeptName] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Dept] PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Designation]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Designation](
	[DesignID] [bigint] NOT NULL,
	[DesignCode] [varchar](500) NOT NULL,
	[DesignName] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_Emp]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Emp](
	[EMPID] [bigint] NOT NULL,
	[EMPCode] [varchar](500) NOT NULL,
	[EMPName] [nvarchar](500) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[EmailID] [varchar](500) NOT NULL,
	[FatherName] [nvarchar](500) NOT NULL,
	[DOB] [datetime] NULL,
	[Gender] [varchar](50) NULL,
	[DesignID] [int] NOT NULL,
	[DepartID] [int] NOT NULL,
	[DOJ] [datetime] NULL,
	[PAN] [varchar](50) NOT NULL,
	[UAN] [varchar](50) NOT NULL,
	[ESIC] [varchar](50) NOT NULL,
	[PaymentMode] [varchar](50) NOT NULL,
	[HODID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[AttachID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Master_Emp] PRIMARY KEY CLUSTERED 
(
	[EMPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Master_HSN]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_HSN](
	[HSNID] [bigint] NOT NULL,
	[HSNName] [varchar](50) NOT NULL,
	[HSNCode] [varchar](50) NOT NULL,
	[IGST] [decimal](18, 2) NOT NULL,
	[CGST] [decimal](18, 2) NOT NULL,
	[SGST] [decimal](18, 2) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters](
	[MasterID] [bigint] NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[Name] [varchar](2000) NOT NULL,
	[Value] [varchar](2000) NOT NULL,
	[GroupID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters] PRIMARY KEY CLUSTERED 
(
	[MasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters_Area]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters_Area](
	[AreaID] [bigint] NOT NULL,
	[AreaName] [varchar](50) NOT NULL,
	[AreaCode] [varchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters_Area] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters_City]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters_City](
	[CityID] [bigint] NOT NULL,
	[CityName] [varchar](50) NOT NULL,
	[CityCode] [varchar](50) NOT NULL,
	[StateID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters_Country]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters_Country](
	[CountryID] [bigint] NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[CountryCode] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters_Region]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters_Region](
	[RegionID] [bigint] NOT NULL,
	[RegionName] [varchar](50) NOT NULL,
	[RegionCode] [varchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters_Region] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Masters_State]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Masters_State](
	[StateID] [bigint] NOT NULL,
	[StateName] [varchar](50) NOT NULL,
	[TIN] [varchar](50) NOT NULL,
	[StateCode] [varchar](50) NOT NULL,
	[RegionID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Masters_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Onboard_Application]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Onboard_Application](
	[AppID] [bigint] NOT NULL,
	[Token] [varchar](500) NOT NULL,
	[DocNo] [varchar](500) NOT NULL,
	[DocDate] [datetime] NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Gender] [varchar](50) NOT NULL,
	[Mobile] [varchar](50) NOT NULL,
	[EmailID] [varchar](50) NOT NULL,
	[FatherName] [varchar](500) NOT NULL,
	[DOB] [date] NULL,
	[BloodGroup] [varchar](50) NULL,
	[MaritalStatus] [varchar](50) NULL,
	[CountryID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[StateID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[PINCode] [varchar](50) NOT NULL,
	[Address] [varchar](2000) NOT NULL,
	[UAN] [varchar](50) NOT NULL,
	[ESIC] [varchar](50) NOT NULL,
	[PAN] [varchar](50) NOT NULL,
	[AadharNo] [varchar](50) NOT NULL,
	[BankName] [varchar](50) NOT NULL,
	[BankBranch] [varchar](50) NOT NULL,
	[AccountNo] [varchar](50) NOT NULL,
	[IFSCCode] [varchar](50) NOT NULL,
	[NomineeName] [varchar](500) NOT NULL,
	[NomineeDOB] [date] NULL,
	[NomineeRelation] [varchar](50) NOT NULL,
	[Remarks] [varchar](50) NOT NULL,
	[VaccinationDetails] [varchar](50) NULL,
	[StepCompleted] [int] NOT NULL,
	[Approved] [int] NOT NULL,
	[ApprovedRemarks] [varchar](max) NOT NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedBy] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsActive_Reason] [varchar](max) NOT NULL,
	[IsActive_By] [int] NOT NULL,
	[IsActive_Date] [datetime] NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Onboard_Application] PRIMARY KEY CLUSTERED 
(
	[AppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Onboard_Attachment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Onboard_Attachment](
	[Attach_ID] [bigint] NOT NULL,
	[File] [image] NULL,
	[AppID] [int] NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[ContentType] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[Isdeleted] [int] NOT NULL,
	[DeletedBy] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salary_Register]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salary_Register](
	[SNO] [int] NULL,
	[CODE] [varchar](100) NULL,
	[EmpName] [varchar](100) NULL,
	[StaffID] [varchar](255) NULL,
	[DOJ] [date] NULL,
	[DOB] [date] NULL,
	[FatherName] [varchar](100) NULL,
	[MobileNumber] [varchar](20) NULL,
	[GENDER] [char](1) NULL,
	[Grade] [varchar](50) NULL,
	[ZONE] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[STATE] [varchar](50) NULL,
	[Department] [varchar](50) NULL,
	[SubDepartment] [varchar](50) NULL,
	[CostCenter] [varchar](50) NULL,
	[Designation] [varchar](50) NULL,
	[BANKNAME] [varchar](50) NULL,
	[BANKACNO] [varchar](50) NULL,
	[IFSC_CODE] [varchar](50) NULL,
	[PAYMODE] [varchar](50) NULL,
	[PFNo] [varchar](50) NULL,
	[UAN] [varchar](50) NULL,
	[ESICNo] [varchar](50) NULL,
	[ESICBRANCHNAME] [varchar](50) NULL,
	[PAN] [varchar](50) NULL,
	[AADHAARNO] [varchar](50) NULL,
	[COUNTERNAME] [varchar](50) NULL,
	[PAYDAYS] [varchar](50) NULL,
	[ArrDays] [varchar](50) NULL,
	[BasicR] [decimal](18, 2) NULL,
	[HRAR] [decimal](18, 2) NULL,
	[SpecialAllowanceR] [decimal](18, 2) NULL,
	[StatutoryBonusR] [decimal](18, 2) NULL,
	[OtherAllowanceR] [decimal](18, 2) NULL,
	[PersonalConveyanceFixR] [decimal](18, 2) NULL,
	[LeaveWagesR] [decimal](18, 2) NULL,
	[StatutoryBonus2R] [decimal](18, 2) NULL,
	[GratuityR] [decimal](18, 2) NULL,
	[InsuranceR] [decimal](18, 2) NULL,
	[RATEGROSSTOTAL] [decimal](18, 2) NULL,
	[Basic] [decimal](18, 2) NULL,
	[HRA] [decimal](18, 2) NULL,
	[SpecialAllowance] [decimal](18, 2) NULL,
	[StatutoryBonus] [decimal](18, 2) NULL,
	[OtherAllowance] [decimal](18, 2) NULL,
	[PersonalConveyanceFix] [decimal](18, 2) NULL,
	[LeaveWages] [decimal](18, 2) NULL,
	[StatutoryBonus2] [decimal](18, 2) NULL,
	[Gratuity] [decimal](18, 2) NULL,
	[Insurance] [decimal](18, 2) NULL,
	[ActualGrossSalary] [decimal](18, 2) NULL,
	[BasicArrear] [decimal](18, 2) NULL,
	[HRAArrear] [decimal](18, 2) NULL,
	[SpecialAllowanceArrear] [decimal](18, 2) NULL,
	[StatutoryBonusArrear] [decimal](18, 2) NULL,
	[OtherAllowanceArrear] [decimal](18, 2) NULL,
	[PersonalConveyanceFixArrear] [decimal](18, 2) NULL,
	[LeaveWagesArrear] [decimal](18, 2) NULL,
	[StatutoryBonus2Arrear] [decimal](18, 2) NULL,
	[GratuityArrear] [decimal](18, 2) NULL,
	[InsuranceArrear] [decimal](18, 2) NULL,
	[GROSSARREAR] [decimal](18, 2) NULL,
	[Incentive] [decimal](18, 2) NULL,
	[PersonalConveyance] [decimal](18, 2) NULL,
	[ArrearPay] [decimal](18, 2) NULL,
	[SubsistenceAllowance] [decimal](18, 2) NULL,
	[LeaveWagesVariable] [decimal](18, 2) NULL,
	[LeaveEncashment] [decimal](18, 2) NULL,
	[OTAMT] [decimal](18, 2) NULL,
	[NETGROSSTOTAL] [decimal](18, 2) NULL,
	[PF] [decimal](18, 2) NULL,
	[VPF] [decimal](18, 2) NULL,
	[ESI] [decimal](18, 2) NULL,
	[ITAX] [decimal](18, 2) NULL,
	[ADDTAX] [decimal](18, 2) NULL,
	[PROFTAX] [decimal](18, 2) NULL,
	[LWFDed] [decimal](18, 2) NULL,
	[LWFDedArrear] [decimal](18, 2) NULL,
	[GROSSDED] [decimal](18, 2) NULL,
	[NETPAY] [decimal](18, 2) NULL,
	[DOL] [date] NULL,
	[PFEMPLR] [decimal](18, 2) NULL,
	[ESIEMPLR] [decimal](18, 2) NULL,
	[LWFEEMPLR] [decimal](18, 2) NULL,
	[EMPLRCont] [decimal](18, 2) NULL,
	[MonthlyCTC] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salary_Register_Provision]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salary_Register_Provision](
	[Month] [int] NULL,
	[Year] [int] NULL,
	[CODE] [varchar](10) NULL,
	[EMP_NAME] [varchar](100) NULL,
	[Deap] [varchar](50) NULL,
	[Desig] [varchar](50) NULL,
	[SSR_Classification] [varchar](50) NULL,
	[BT_Code] [varchar](50) NULL,
	[BT_Name] [varchar](100) NULL,
	[Channel_Type] [varchar](50) NULL,
	[REGION] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Dealer_Code] [varchar](50) NULL,
	[Dealer_Name] [varchar](100) NULL,
	[DOJ] [date] NULL,
	[DOL] [date] NULL,
	[PAYDAYS] [decimal](10, 2) NULL,
	[ARRDAYS] [decimal](10, 2) NULL,
	[BASIC_R] [decimal](10, 2) NULL,
	[HRA_R] [decimal](10, 2) NULL,
	[SPECIAL_ALLOWANCE_R] [decimal](10, 2) NULL,
	[STATUTORY_BONUS_R] [decimal](10, 2) NULL,
	[OTHER_ALLOWANCE_R] [decimal](10, 2) NULL,
	[RATEGROSSTOTAL] [decimal](10, 2) NULL,
	[BASIC] [decimal](10, 2) NULL,
	[HRA] [decimal](10, 2) NULL,
	[SPECIAL_ALLOWANCE] [decimal](10, 2) NULL,
	[STATUTORY_BONUS] [decimal](10, 2) NULL,
	[OTHER_ALLOWANCE] [decimal](10, 2) NULL,
	[ACTUALGROSSSALARY] [decimal](10, 2) NULL,
	[GROSSARREAR] [decimal](10, 2) NULL,
	[INCENTIVE] [decimal](10, 2) NULL,
	[PERSONAL_CONVEYANCE] [decimal](10, 2) NULL,
	[NETGROSSTOTAL] [decimal](10, 2) NULL,
	[PF] [decimal](10, 2) NULL,
	[VPF] [decimal](10, 2) NULL,
	[ESI] [decimal](10, 2) NULL,
	[PROFTAX] [decimal](10, 2) NULL,
	[LWF_DED] [decimal](10, 2) NULL,
	[GROSSDED] [decimal](10, 2) NULL,
	[NETPAY] [decimal](10, 2) NULL,
	[PF_EMPLR] [decimal](10, 2) NULL,
	[ESI_EMPLR] [decimal](10, 2) NULL,
	[LWF_EMPLR] [decimal](10, 2) NULL,
	[EMPLR_CONT] [decimal](10, 2) NULL,
	[MONTHLY_CTC] [decimal](10, 2) NULL,
	[Agency_Fee] [decimal](10, 2) NULL,
	[Total_with_Agency_Fee] [decimal](10, 2) NULL,
	[GST] [decimal](10, 2) NULL,
	[Final_Billing] [decimal](10, 2) NULL,
	[Remarks] [varchar](200) NULL,
	[BILLING_STATUS] [varchar](20) NULL,
	[RELEASE_STATUS] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserClient_Mapping]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClient_Mapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LoginID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserClient_Mapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UserEMP_View]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[UserEMP_View]
as
	SELECT  U.LoginID, U.UserID,U.RoleID,R.RoleName, isnull( E.EMPID,0)as EMPID, 
		isnull( E.EMPCode,'')as EMPCode, isnull( E.EMPName,U.Name)as EMPName,
		isnull( E.Gender,'')as Gender,isnull(Design.DesignName,'')as DesignName,
		isnull(Dept.DeptName,'')as DeptName,isnull(U.AttachID,0)as AttachID,
		(select dbo.fnGetAttachPath(isnull(U.AttachID,0)))as ImageURL,
		isnull( E.Phone,'')as Phone,isnull(U.Email,E.EmailID)as EmailID,isnull(E.FatherName,'')as FatherName,
		isnull( E.PAN,'')as PAN,isnull(E.PaymentMode,'')as PaymentMode,isnull(E.UAN,'')as UAN,isnull(E.ESIC,'')as ESIC,
		case when E.DOJ is not null and year(E.DOJ)>1900 then format(E.DOJ,'dd-MMM-yyyy') else '' end as DOJ,
		case when E.DOB is not null and year(E.DOB)>1900 then format(E.DOB,'dd-MMM-yyyy') else '' end as DOB
		FROM  Login_Users  (NOLOCK) as U
		inner join Login_Roles (NOLOCK) as R on R.RoleID=U.RoleID
		left join Master_Emp (NOLOCK) as E on E.UserID=U.LoginID
		left join Master_Department (NOLOCK) as Dept on Dept.DeptID=E.DepartID
		left join Master_Designation (NOLOCK) as Design on Design.DesignID=E.DesignID
	
		where U.Isdeleted=0
GO
ALTER TABLE [dbo].[AllMaxID] ADD  CONSTRAINT [DF_AllMaxID_TicketID]  DEFAULT ((0)) FOR [Ticket_ID]
GO
ALTER TABLE [dbo].[AllMaxID] ADD  CONSTRAINT [DF_AllMaxID_TicketNotesID]  DEFAULT ((0)) FOR [Ticket_NotesID]
GO
ALTER TABLE [dbo].[AllMaxID] ADD  CONSTRAINT [DF_AllMaxID_BillID]  DEFAULT ((0)) FOR [BillID]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_DocNo]  DEFAULT ('') FOR [DocNo]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_DocDate]  DEFAULT (getdate()) FOR [DocDate]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_FYID]  DEFAULT ((0)) FOR [FYID]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Month]  DEFAULT ((0)) FOR [Month]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Year]  DEFAULT ((0)) FOR [Year]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_EMPCount_1]  DEFAULT ((0)) FOR [EMPCount]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_DealerType]  DEFAULT ('') FOR [DealerType]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Department]  DEFAULT ('') FOR [Department]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Designation]  DEFAULT ('') FOR [Designation]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_ClientCode]  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_ClientName]  DEFAULT ('') FOR [ClientName]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_StateName]  DEFAULT ('') FOR [StateName]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Code]  DEFAULT ('') FOR [SC_Code]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Name]  DEFAULT ('') FOR [SC_Name]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_PANNo]  DEFAULT ('') FOR [SC_PANNo]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_Country]  DEFAULT ('') FOR [SC_CountryName]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_CountryName1]  DEFAULT ('') FOR [SC_CountryCode]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_State]  DEFAULT ('') FOR [SC_StateName]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_StateCode]  DEFAULT ('') FOR [SC_StateCode]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_StateTIN]  DEFAULT ('') FOR [SC_StateTIN]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SC_ZipCode]  DEFAULT ('') FOR [SC_ZipCode]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SubClient_Phone]  DEFAULT ('') FOR [SC_Phone]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_SubClient_Email]  DEFAULT ('') FOR [SC_Email]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Description]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_AgencyCommission]  DEFAULT ((0)) FOR [AgencyCommission]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Gross_Amt]  DEFAULT ((0)) FOR [Gross_Amt]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_HSNCode]  DEFAULT ('') FOR [HSNCode]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Billing] ADD  CONSTRAINT [DF_Billing_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_EMPName]  DEFAULT ('') FOR [EMPName]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_EMPCode]  DEFAULT ('') FOR [EMPCode]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_DealerName1]  DEFAULT ('') FOR [DealerType]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_DealerName]  DEFAULT ('') FOR [DealerName]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Gender]  DEFAULT ('') FOR [Gender]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Department]  DEFAULT ('') FOR [Department]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Designation]  DEFAULT ('') FOR [Designation]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_StateName]  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Location]  DEFAULT ('') FOR [Location]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_PayDays]  DEFAULT ((0)) FOR [PayDays]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_NetPay]  DEFAULT ((0)) FOR [NetPay]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Incentive]  DEFAULT ((0)) FOR [Incentive]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_NetGross]  DEFAULT ((0)) FOR [NetGross]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_CTC]  DEFAULT ((0)) FOR [CTC]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_AgencyCommission]  DEFAULT ((0)) FOR [Tran_AgencyCommission]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Total]  DEFAULT ((0)) FOR [Total]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Billing_Tran] ADD  CONSTRAINT [DF_Billing_Tran_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_CompanyName]  DEFAULT ('') FOR [CompanyCode]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_SMTP]  DEFAULT ('') FOR [SMTP]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_SMTP_USER]  DEFAULT ('') FOR [SMTP_USER]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_SMTP_PASSWORD]  DEFAULT ('') FOR [SMTP_PASSWORD]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_SMTP_EMAIL]  DEFAULT ('') FOR [SMTP_EMAIL]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_Port]  DEFAULT ('') FOR [Port]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_EnableSsl]  DEFAULT ('') FOR [EnableSsl]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_ConfigID]  DEFAULT ((0)) FOR [ConfigID]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_Category]  DEFAULT ('') FOR [Category]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_SubCategory]  DEFAULT ('') FOR [SubCategory]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_ConfigKey]  DEFAULT ('') FOR [ConfigKey]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_ConfigValue]  DEFAULT ('') FOR [ConfigValue]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[ConfigSetting] ADD  CONSTRAINT [DF_ConfigSetting_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_TemplateName]  DEFAULT ('') FOR [TemplateName]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_Body]  DEFAULT ('') FOR [Body]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_Subject]  DEFAULT ('') FOR [Subject]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_CCMail]  DEFAULT ('') FOR [CCMail]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_BCCMail]  DEFAULT ('') FOR [BCCMail]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_Repository]  DEFAULT ('') FOR [Repository]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_SMSBody]  DEFAULT ('') FOR [SMSBody]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[EmailTemplate] ADD  CONSTRAINT [DF_EmailTemplate_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_ErrDescription]  DEFAULT ('') FOR [ErrDescription]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_SystemException]  DEFAULT ('') FOR [SystemException]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_ActiveFunction]  DEFAULT ('') FOR [ActiveFunction]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_ActiveForm]  DEFAULT ('') FOR [ActiveForm]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_ActiveModule]  DEFAULT ('') FOR [ActiveModule]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Error_Log] ADD  CONSTRAINT [DF_Error_Log_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_Code]  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Financial_Years] ADD  CONSTRAINT [DF_Financial_Years_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_CategoryName]  DEFAULT ('') FOR [CategoryName]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_CategoryDesc]  DEFAULT ('') FOR [CategoryDesc]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Category] ADD  CONSTRAINT [DF_Helpdesk_Category_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_Status]  DEFAULT ('') FOR [StatusName]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_DisplayName]  DEFAULT ('') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_Icon]  DEFAULT ('') FOR [Icon]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_Color]  DEFAULT ('') FOR [Color]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Status] ADD  CONSTRAINT [DF_Helpdesk_Status_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_SubName]  DEFAULT ('') FOR [SubName]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_SubDesc]  DEFAULT ('') FOR [SubDesc]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_SubCategoryID]  DEFAULT ((0)) FOR [SubCategoryID]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_LoginID]  DEFAULT ((0)) FOR [LoginID]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_SubCategory_Users] ADD  CONSTRAINT [DF_Helpdesk_SubCategory_Users_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_TicketNo]  DEFAULT ('') FOR [TicketNo]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_DocDate]  DEFAULT (getdate()) FOR [DocDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_SubCategoryID]  DEFAULT ((0)) FOR [SubCategoryID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Subject]  DEFAULT ('') FOR [Subject]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Message]  DEFAULT ('') FOR [Message]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Ticket]  DEFAULT ('') FOR [TicketPriority]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_LatestNotes]  DEFAULT ('') FOR [Latest_Notes]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket] ADD  CONSTRAINT [DF_Helpdesk_Ticket_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_TicketID]  DEFAULT ((0)) FOR [TicketID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_LoginID]  DEFAULT ((0)) FOR [LoginID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_Doctype]  DEFAULT ('') FOR [Doctype]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Assignee] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Assignee_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_Attach_ID]  DEFAULT ((0)) FOR [Attach_ID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_TempID]  DEFAULT ('') FOR [TempID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_TicketID]  DEFAULT ((0)) FOR [TicketID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_NotesID]  DEFAULT ((0)) FOR [NotesID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_FileName]  DEFAULT ('') FOR [FileName]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_ContentType]  DEFAULT ('') FOR [ContentType]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_Description]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Attachments] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Attachments_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_TicketID]  DEFAULT ((0)) FOR [TicketID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_LoginID]  DEFAULT ((0)) FOR [LoginID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Deferred] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Deferred_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_TicketID]  DEFAULT ((0)) FOR [TicketID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_StatusID]  DEFAULT ((0)) FOR [StatusID]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_Notes]  DEFAULT ('') FOR [Notes]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Helpdesk_Ticket_Notes] ADD  CONSTRAINT [DF_Helpdesk_Ticket_Notes_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_TicketNo]  DEFAULT ('') FOR [TicketNo]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_TicketDate]  DEFAULT (getdate()) FOR [TicketDate]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_StatusID]  DEFAULT ((0)) FOR [StatusID]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_LeadType]  DEFAULT ('') FOR [LeadType]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CompanyName]  DEFAULT ('') FOR [CompanyName]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Table_2_CompanyName1]  DEFAULT ('') FOR [CompanyBusiness]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_StateID]  DEFAULT ((0)) FOR [StateID]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CityID]  DEFAULT ((0)) FOR [CityID]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_PinCode]  DEFAULT ('') FOR [PinCode]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CompanyType]  DEFAULT ('') FOR [CompanyType]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CompanyPayroll]  DEFAULT ('') FOR [CompanyPayroll]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_RequirementType]  DEFAULT ('') FOR [RequirementType]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_Tran_Notes_1]  DEFAULT ('') FOR [Tran_Notes]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_Latitude]  DEFAULT ((0)) FOR [Latitude]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_Longitude]  DEFAULT ((0)) FOR [Longitude]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_Phone]  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_EmailID]  DEFAULT ('') FOR [EmailID]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_Designation]  DEFAULT ('') FOR [Designation]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Lead_Contacts] ADD  CONSTRAINT [DF_Lead_Contacts_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_StatusName]  DEFAULT ('') FOR [StatusName]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_DisplayName]  DEFAULT ('') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_Icon]  DEFAULT ('') FOR [Icon]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_Color]  DEFAULT ('') FOR [Color]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Lead_Status] ADD  CONSTRAINT [DF_Lead_Status_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_StatusID]  DEFAULT ((0)) FOR [StatusID]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_Notes]  DEFAULT ('') FOR [Notes]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Lead_Tran] ADD  CONSTRAINT [DF_Lead_Tran_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_MenuID]  DEFAULT ((0)) FOR [MenuID]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_MenuName]  DEFAULT ('') FOR [MenuName]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_ParentMenuID]  DEFAULT ((0)) FOR [ParentMenuID]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_MenuImage]  DEFAULT ('') FOR [MenuImage]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_MenuURL]  DEFAULT ('') FOR [MenuURL]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_ModuleID]  DEFAULT ((0)) FOR [ModuleID]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Target]  DEFAULT ('') FOR [Target]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Login_Menu] ADD  CONSTRAINT [DF_Login_Menu_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_TranID]  DEFAULT ((0)) FOR [TranID]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_R]  DEFAULT ((0)) FOR [R]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_W]  DEFAULT ((0)) FOR [W]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_M]  DEFAULT ((0)) FOR [M]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_D]  DEFAULT ((0)) FOR [D]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_E]  DEFAULT ((0)) FOR [E]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_I]  DEFAULT ((0)) FOR [I]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_App_1]  DEFAULT ((0)) FOR [App]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Login_Menu_Role_Tran] ADD  CONSTRAINT [DF_Login_Menu_Role_Tran_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_ModuleID]  DEFAULT ((0)) FOR [ModuleID]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_ModuleName]  DEFAULT ('') FOR [ModuleName]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_ModulePriority]  DEFAULT ((0)) FOR [ModulePriority]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_ModuleIcon]  DEFAULT ('') FOR [ModuleIcon]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Type]  DEFAULT ('') FOR [Type]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Login_Module] ADD  CONSTRAINT [DF_Login_Module_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Role_ID]  DEFAULT ((0)) FOR [RoleID]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Role_Name]  DEFAULT ('') FOR [RoleName]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_description]  DEFAULT ('') FOR [description]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Login_Roles] ADD  CONSTRAINT [DF_Login_Roles_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_LoginID]  DEFAULT ((0)) FOR [LoginID]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_User_Name]  DEFAULT ('') FOR [UserID]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Password]  DEFAULT ('') FOR [Password]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Phone_1]  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Email_1]  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Role_ID]  DEFAULT ((0)) FOR [RoleID]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Last_Login]  DEFAULT (((1)/(1))/(1900)) FOR [LastLogin]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IsLogin]  DEFAULT ((0)) FOR [IsLogin]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_SessionID]  DEFAULT ('') FOR [SessionID]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IsFirstLogin_1]  DEFAULT ((1)) FOR [IsFirstLogin]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_AttachID]  DEFAULT ((0)) FOR [AttachID]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_AllowLogin_1]  DEFAULT ('') FOR [AllowLogin]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IsActive_Reason_1]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IsActive_By_1]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Login_Users] ADD  CONSTRAINT [DF_Login_Users_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_ID]  DEFAULT ((0)) FOR [AddressID]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Doctype]  DEFAULT ('') FOR [Doctype]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_TableID]  DEFAULT ((0)) FOR [TableID]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_TableName]  DEFAULT ('') FOR [TableName]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_CountryID]  DEFAULT ((0)) FOR [CountryID]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_StateID]  DEFAULT ((0)) FOR [StateID]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_CityID]  DEFAULT ((0)) FOR [CityID]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Address1]  DEFAULT ('') FOR [Address1]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Address2]  DEFAULT ('') FOR [Address2]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Location]  DEFAULT ('') FOR [Location]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Phone]  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Zipcode]  DEFAULT ('') FOR [Zipcode]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Address] ADD  CONSTRAINT [DF_Master_Address_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Attach_ID]  DEFAULT ((0)) FOR [Attach_ID]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_TableName]  DEFAULT ('') FOR [TableName]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_TableID]  DEFAULT ((0)) FOR [TableID]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_File_Name]  DEFAULT ('') FOR [FileName]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Content_Type]  DEFAULT ('') FOR [ContentType]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Table_1_Descrip]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Attachment] ADD  CONSTRAINT [DF_Master_Attachment_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_Doctype]  DEFAULT ('') FOR [Doctype]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_TableID]  DEFAULT ((0)) FOR [TableID]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_TableName]  DEFAULT ('') FOR [TableName]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_AccountNo]  DEFAULT ('') FOR [AccountNo]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_IFSCCode]  DEFAULT ('') FOR [IFSCCode]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_BranchName]  DEFAULT ('') FOR [BranchName]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Bank] ADD  CONSTRAINT [DF_Master_Bank_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_ClientCode]  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_ClientName]  DEFAULT ('') FOR [ClientName]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_DisplayName]  DEFAULT ('') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_OtherCode]  DEFAULT ('') FOR [OtherCode]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Clients] ADD  CONSTRAINT [DF_Master_Clients_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Code]  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_PrintName]  DEFAULT ('') FOR [PrintName]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_GST]  DEFAULT ('') FOR [GSTNo]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_PAN]  DEFAULT ('') FOR [PAN]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Commission]  DEFAULT ((0)) FOR [Commission]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_CountryID]  DEFAULT ((0)) FOR [CountryID]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_StateID]  DEFAULT ((0)) FOR [StateID]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Address]  DEFAULT ('') FOR [Address]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_ZipCode]  DEFAULT ('') FOR [ZipCode]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Phone]  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_EmailID]  DEFAULT ('') FOR [EmailID]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Clients_Tran] ADD  CONSTRAINT [DF_Master_Clients_Tran_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_Code]  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Dealer_Type] ADD  CONSTRAINT [DF_Master_Dealer_Type_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Table_1_BranchID]  DEFAULT ((0)) FOR [DeptID]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Table_1_Branch_Code]  DEFAULT ('') FOR [DeptCode]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Table_1_Branch_Name]  DEFAULT ('') FOR [DeptName]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Department] ADD  CONSTRAINT [DF_Master_Dept_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Table_1_Dept_ID]  DEFAULT ((0)) FOR [DesignID]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Table_1_Dept_Code]  DEFAULT ('') FOR [DesignCode]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Table_1_Dept_Name]  DEFAULT ('') FOR [DesignName]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Designation] ADD  CONSTRAINT [DF_Master_Designation_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_EMP_ID]  DEFAULT ((0)) FOR [EMPID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_EMP_Code]  DEFAULT ('') FOR [EMPCode]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_EMP_Name]  DEFAULT ('') FOR [EMPName]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Phone]  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Email_ID]  DEFAULT ('') FOR [EmailID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Father_Name]  DEFAULT ('') FOR [FatherName]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Design_ID]  DEFAULT ((0)) FOR [DesignID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Depart_ID]  DEFAULT ((0)) FOR [DepartID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_PAN]  DEFAULT ('') FOR [PAN]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_UAN]  DEFAULT ('') FOR [UAN]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_ESIC]  DEFAULT ('') FOR [ESIC]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Payment_Mode]  DEFAULT ('') FOR [PaymentMode]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_HOD_ID]  DEFAULT ((0)) FOR [HODID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_User_ID]  DEFAULT ((0)) FOR [UserID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Attach_ID]  DEFAULT ((0)) FOR [AttachID]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_Emp] ADD  CONSTRAINT [DF_Master_Emp_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Table_1_CityName]  DEFAULT ('') FOR [HSNName]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Table_1_CityCode]  DEFAULT ('') FOR [HSNCode]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_IGST]  DEFAULT ((0)) FOR [IGST]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_CGST]  DEFAULT ((0)) FOR [CGST]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_HGST]  DEFAULT ((0)) FOR [SGST]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_Description]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Master_HSN] ADD  CONSTRAINT [DF_Master_HSN_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_MasterID]  DEFAULT ((0)) FOR [MasterID]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Table_Name]  DEFAULT ('') FOR [TableName]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Value]  DEFAULT ('') FOR [Value]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_GroupID]  DEFAULT ((0)) FOR [GroupID]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Deleted_By]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Created_By]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Created_Date]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Modified_Date]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_Modified_By]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters] ADD  CONSTRAINT [DF_Masters_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Table_2_CityName]  DEFAULT ('') FOR [AreaName]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Table_2_CityCode]  DEFAULT ('') FOR [AreaCode]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Table_2_StateID]  DEFAULT ((0)) FOR [CityID]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters_Area] ADD  CONSTRAINT [DF_Masters_Area_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Table_2_StateName]  DEFAULT ('') FOR [CityName]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Table_2_StateCode]  DEFAULT ('') FOR [CityCode]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Table_2_RegionID]  DEFAULT ((0)) FOR [StateID]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters_City] ADD  CONSTRAINT [DF_Masters_City_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_Name]  DEFAULT ('') FOR [CountryName]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_Code]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters_Country] ADD  CONSTRAINT [DF_Masters_Country_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Table_2_CountryName]  DEFAULT ('') FOR [RegionName]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Table_2_CountryCode]  DEFAULT ('') FOR [RegionCode]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_CountryID]  DEFAULT ((0)) FOR [CountryID]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters_Region] ADD  CONSTRAINT [DF_Masters_Region_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_StateName]  DEFAULT ('') FOR [StateName]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_TIN]  DEFAULT ('') FOR [TIN]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_StateCode]  DEFAULT ('') FOR [StateCode]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_RegionID]  DEFAULT ((0)) FOR [RegionID]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Masters_State] ADD  CONSTRAINT [DF_Masters_State_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Token]  DEFAULT ('') FOR [Token]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_DocNo]  DEFAULT ('') FOR [DocNo]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_DocDate]  DEFAULT (getdate()) FOR [DocDate]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Name]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Gender]  DEFAULT ('') FOR [Gender]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Mobile]  DEFAULT ('') FOR [Mobile]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Table_1_Mobile1]  DEFAULT ('') FOR [EmailID]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Table_1_Name1]  DEFAULT ('') FOR [FatherName]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_CountryID]  DEFAULT ((0)) FOR [CountryID]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_RegionID]  DEFAULT ((0)) FOR [RegionID]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_StateID]  DEFAULT ((0)) FOR [StateID]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_CityID]  DEFAULT ((0)) FOR [CityID]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_PINCode]  DEFAULT ('') FOR [PINCode]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_CurrentAddress]  DEFAULT ('') FOR [Address]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_UAN]  DEFAULT ('') FOR [UAN]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_ESIC]  DEFAULT ('') FOR [ESIC]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_PAN]  DEFAULT ('') FOR [PAN]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_AadharNo]  DEFAULT ('') FOR [AadharNo]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_BankName]  DEFAULT ('') FOR [BankName]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_BankBranch]  DEFAULT ('') FOR [BankBranch]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_AccountNo]  DEFAULT ('') FOR [AccountNo]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_IFSCCode]  DEFAULT ('') FOR [IFSCCode]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_NomineeName]  DEFAULT ('') FOR [NomineeName]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Table_1_NomineeDOB1]  DEFAULT ('') FOR [NomineeRelation]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_StepCompleted]  DEFAULT ((0)) FOR [StepCompleted]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Approved]  DEFAULT ((0)) FOR [Approved]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_ApprovedRemarks]  DEFAULT ('') FOR [ApprovedRemarks]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_ApprovedBy]  DEFAULT ((0)) FOR [ApprovedBy]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_IsActive_Reason]  DEFAULT ('') FOR [IsActive_Reason]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_IsActive_By]  DEFAULT ((0)) FOR [IsActive_By]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Onboard_Application] ADD  CONSTRAINT [DF_Onboard_Application_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_Attach_ID]  DEFAULT ((0)) FOR [Attach_ID]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_AppID]  DEFAULT ((0)) FOR [AppID]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_FileName]  DEFAULT ('') FOR [FileName]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_ContentType]  DEFAULT ('') FOR [ContentType]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_Description]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_Isdeleted]  DEFAULT ((0)) FOR [Isdeleted]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_DeletedBy]  DEFAULT ((0)) FOR [DeletedBy]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Onboard_Attachment] ADD  CONSTRAINT [DF_Onboard_Attachment_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
ALTER TABLE [dbo].[UserClient_Mapping] ADD  CONSTRAINT [DF_UserClient_Mapping_LoginID]  DEFAULT ((0)) FOR [LoginID]
GO
ALTER TABLE [dbo].[UserClient_Mapping] ADD  CONSTRAINT [DF_UserClient_Mapping_ClientID]  DEFAULT ((0)) FOR [ClientID]
GO
ALTER TABLE [dbo].[UserClient_Mapping] ADD  CONSTRAINT [DF_UserClient_Mapping_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[UserClient_Mapping] ADD  CONSTRAINT [DF_UserClient_Mapping_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserClient_Mapping] ADD  CONSTRAINT [DF_UserClient_Mapping_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
/****** Object:  StoredProcedure [dbo].[spu_CreateMail_Helpdesk_Ticket]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spu_CreateMail_Helpdesk_Ticket] 
(
	@TicketID INT
)
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
			DECLARE @WebsiteLogo_Args NVARCHAR(1000)='',@file_attachments_Arg varchar(max), @sensitivity_Var NVARCHAR(300),@profile_name_Var VARCHAR(max),@importance_Var NVARCHAR(300),@Recipient_Single NVARCHAR(300),@Mail_CC NVARCHAR(300),@Mail_BCC NVARCHAR(300)
			DECLARE @recipients_Arg NVARCHAR(500),@body_Arg NVARCHAR(MAX),@body_Full_Arg NVARCHAR(MAX),@subject_Arg NVARCHAR(500),@FullName VARCHAR(500)
			Declare @TicketNo varchar(500), @DocDate date, @StatusName varchar(500),@StatusColor varchar(500), @CategoryName varchar(500),  @SubCategoryName varchar(500), @Subject varchar(max), @Message nvarchar(max), 
			@TicketPriority varchar(50),@Primary_LoginID int, @Primary_UserName varchar(500),@Primary_UserEMail varchar(50), @AllUsers_Name varchar(max),@AllUserEmail varchar(max), @IPAddress varchar(50)='',@CreatedBy varchar(500);

			declare @TicketAssignee table(LoginID int,Doctype varchar(50),NAME varchar(500),EMail Varchar(500))

			SET @sensitivity_Var ='Personal' 
			SET @importance_Var ='High' 
			select @profile_name_Var = isnull(ConfigValue,'') from ConfigSetting where ConfigKey='Profile_Name'
			select @WebsiteLogo_Args = isnull(ConfigValue,'') from ConfigSetting where ConfigKey='WebsiteLogPath'

			SELECT @body_Arg=isnull(Body,''),@subject_Arg=isnull([Subject],''),@Mail_CC=isnull(CCMail,''),@Mail_BCC=isnull(BCCMail,'') 
			FROM EmailTemplate WHERE TemplateName='TicketCreate'
			

			insert into @TicketAssignee(LoginID,Doctype,NAME,EMail)
			select HA.LoginID,HA.Doctype,U.EMPName,U.EmailID from Helpdesk_Ticket_Assignee as HA 
			inner join UserEMP_View as U on U.LoginID=HA.LoginID 
			where HA.Isdeleted=0 and HA.TicketID=@TicketID

			select top 1 @Primary_LoginID=LoginID, @Primary_UserEMail= Email,@Primary_UserName=NAME From @TicketAssignee where Doctype ='Primary'

			select  @AllUsers_Name = isnull(@AllUsers_Name,'') + NAME + ',' from @TicketAssignee where LoginID !=@Primary_LoginID
			if ((charindex(',',@AllUsers_Name)>0))
				begin
					set @AllUsers_Name= Substring(@AllUsers_Name,1,len(@AllUsers_Name)-1)
				end

			
			select  @AllUserEmail = isnull(@AllUserEmail,'') + EMail + ';' from @TicketAssignee  where LoginID !=@Primary_LoginID
			if ((charindex(';',@AllUserEmail)>0))
				begin
					set @AllUserEmail= Substring(@AllUserEmail,1,len(@AllUserEmail)-1)
				end

			set @Mail_CC = IIF(@Mail_CC= '',@AllUserEmail,@Mail_CC+';'+@AllUserEmail)

			SELECT @TicketNo=HT.TicketNo, @DocDate=HT.DocDate, @StatusName=s.DisplayName,@StatusColor=s.Color,@CategoryName= C.CategoryName, @SubCategoryName=SC.SubName, 
			@Subject=HT.Subject,@Message= HT.Message, 
			@TicketPriority=HT.TicketPriority, @CreatedBy=isnull(Cby.EMPName,''),@IPAddress=HT.IPAddress
			FROM Helpdesk_Ticket as HT 
			inner join Helpdesk_Status as s on s.StatusID=HT.CurrentStatusID and s.Isdeleted=0
			inner join Helpdesk_Category as C on C.CategoryID=HT.CategoryID and C.Isdeleted=0
			inner join Helpdesk_SubCategory as SC on SC.CategoryID=C.CategoryID and sc.SubCategoryID=HT.SubCategoryID and SC.Isdeleted=0
			inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
			left outer join UserEMP_View Cby on Cby.LoginID=HT.CreatedBy
			WHERE HT.TicketID=@TicketID

			SET @body_Arg=REPLACE(@body_Arg , '#WEBSITELOGOPATH#' , @WebsiteLogo_Args)		
			SET @body_Arg=REPLACE(@body_Arg , '#TICKETNO#' , @TicketNo )				
			SET @body_Arg=REPLACE(@body_Arg , '#DOCDATE#' , FORMAT(@DocDate,'dd-MMM-yyyy') )
			SET @body_Arg=REPLACE(@body_Arg , '#STATUS_NAME#' , @StatusName )	
			SET @body_Arg=REPLACE(@body_Arg , '#STATUS_COLOR#' , @StatusColor )			
			SET @body_Arg=REPLACE(@body_Arg , '#CATEGORY#' , @CategoryName )	
			SET @body_Arg=REPLACE(@body_Arg , '#SUBCATEGORY#' , @SubCategoryName )	
			SET @body_Arg=REPLACE(@body_Arg , '#MESSAGE#' , @Message )	
			SET @body_Arg=REPLACE(@body_Arg , '#SUBJECT#' , @Subject )	
			SET @body_Arg=REPLACE(@body_Arg , '#PRIORITY#' , @TicketPriority )	
			SET @body_Arg=REPLACE(@body_Arg , '#PRIMARYUSER#' , @Primary_UserName )	
			SET @body_Arg=REPLACE(@body_Arg , '#ALLUSERS#' , @AllUsers_Name )	
			SET @body_Arg=REPLACE(@body_Arg , '#CREATEDBY#' , @CreatedBy )	
			SET @body_Arg=REPLACE(@body_Arg , '#IPADDRESS#' , @IPAddress )	



			SET @subject_Arg=REPLACE(@subject_Arg , '#TICKETNO#' , @TicketNo )				
			SET @subject_Arg=REPLACE(@subject_Arg , '#DOCDATE#' , FORMAT(@DocDate,'dd-MMM-yyyy') )
			SET @subject_Arg=REPLACE(@subject_Arg , '#STATUS_NAME#' , @StatusName )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#STATUS_COLOR#' , @StatusColor )			
			SET @subject_Arg=REPLACE(@subject_Arg , '#CATEGORY#' , @CategoryName )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#SUBCATEGORY#' , @SubCategoryName )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#MESSAGE#' , @Message )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#SUBJECT#' , @Subject )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#PRIORITY#' , @TicketPriority )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#PRIMARYUSER#' , @Primary_UserName )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#ALLUSERS#' , @AllUsers_Name )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#CREATEDBY#' , @CreatedBy )	
			SET @subject_Arg=REPLACE(@subject_Arg , '#IPADDRESS#' , @IPAddress )	
			


			if @body_Arg !='' and @Primary_UserEMail !=''
				begin
					EXEC msdb.dbo.sp_send_dbmail
					@recipients=@Primary_UserEMail,
					@copy_recipients=@Mail_CC,
					@blind_copy_recipients=@Mail_BCC,
					@body=@body_Arg, 
					@sensitivity=@sensitivity_Var, 
					@importance=@importance_Var, 
					@subject=@subject_Arg,
					@body_format = 'HTML',
					@profile_name=@profile_name_Var,
					@file_attachments=@file_attachments_Arg
				end

	END TRY
	BEGIN CATCH
		print @body_Arg  
		
		print error_message()
		
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spu_CreateMail_OnboardCreate]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spu_CreateMail_OnboardCreate] 
(
	@Token varchar(500)
)
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
			DECLARE @WebsiteLogo_Args NVARCHAR(1000)='',@WebsiteURL NVARCHAR(1000)='',@file_attachments_Arg varchar(max), @sensitivity_Var NVARCHAR(300),@profile_name_Var VARCHAR(max),@importance_Var NVARCHAR(300),@Recipient_Single NVARCHAR(300),@Mail_CC NVARCHAR(300),@Mail_BCC NVARCHAR(300)
			DECLARE @recipients_Arg NVARCHAR(500),@body_Arg NVARCHAR(MAX),@body_Full_Arg NVARCHAR(MAX),@subject_Arg NVARCHAR(500),@FullName VARCHAR(500)
			
			Declare @Name varchar(500), @Mobile varchar(500),@EmailID varchar(500)
			SET @sensitivity_Var ='Personal' 
			SET @importance_Var ='High' 
			select @profile_name_Var = isnull(ConfigValue,'') from ConfigSetting where ConfigKey='Profile_Name'
			select @WebsiteLogo_Args = isnull(ConfigValue,'') from ConfigSetting where ConfigKey='WebsiteLogPath'
			select @WebsiteURL = isnull(ConfigValue,'') from ConfigSetting where ConfigKey='WebsiteURL'

			SELECT @body_Arg=isnull(Body,''),@subject_Arg=isnull([Subject],''),@Mail_CC=isnull(CCMail,''),@Mail_BCC=isnull(BCCMail,'') 
			FROM EmailTemplate WHERE TemplateName='Onboarding'
			
			SELECT @Name=HT.Name, @Mobile=HT.Mobile, @EmailID=EmailID
			FROM Onboard_Application as HT 
			where HT.Token=@Token

			SET @body_Arg=REPLACE(@body_Arg , '#WEBSITELOGOPATH#' , @WebsiteLogo_Args)		
			SET @body_Arg=REPLACE(@body_Arg , '#NAME#' , @Name )				
			SET @body_Arg=REPLACE(@body_Arg , '#EMAIL#' , @EmailID )
			SET @body_Arg=REPLACE(@body_Arg , '#URL#' , @WebsiteURL+'/OnboardBasicDetails/'+@Token )	
			

			if @EmailID !=''
				begin
					EXEC msdb.dbo.sp_send_dbmail
					@recipients=@EmailID,
					@copy_recipients=@Mail_CC,
					@blind_copy_recipients=@Mail_BCC,
					@body=@body_Arg, 
					@sensitivity=@sensitivity_Var, 
					@importance=@importance_Var, 
					@subject=@subject_Arg,
					@body_format = 'HTML',
					@profile_name=@profile_name_Var,
					@file_attachments=@file_attachments_Arg
				end

	END TRY
	BEGIN CATCH
		print @body_Arg  
		
		print error_message()
		
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spu_DelRecord]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_DelRecord](@ID int,@Doctype varchar(500),@createdby int,@IPAddress varchar(500))
as
begin
Declare @RET_ID int=0,@STATUS int=0, @MESSAGE  VARCHAR(MAX)=''
 BEGIN TRY 
	if @Doctype='BillTran'
		begin
			update Billing set AgencyPer=0, AgencyCommission=0, Gross_Amt=0, IGST=0, IGST_Amt=0, CGST=0, CGST_Amt=0, SGST=0, SGST_Amt=0, Total_Amt=0,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where BillID=@ID 


			update Billing_Tran set
			isdeleted=1,		
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where BillID=@ID
			set @RET_ID=@ID
			SET @STATUS =1
			SET @MESSAGE = 'deleted Successfully'
		end
	else if @Doctype='OnboardingAttachment'
		begin
			update Onboard_Attachment set Isdeleted=1,DeletedDate=GETDATE(),DeletedBy=@createdby,
			IPAddress=@IPAddress
			where Attach_ID=@ID 
			set @RET_ID=@ID
			SET @STATUS =1
			SET @MESSAGE = 'deleted Successfully'
		end
	
	else
		begin
				SET @MESSAGE = 'error occured, please contact to administrator'
		end
	

 END TRY 
		BEGIN CATCH
			SET @STATUS =-1
			SET @MESSAGE = ERROR_MESSAGE()
		END CATCH 

select @RET_ID as RET_ID,@STATUS as STATUS,@MESSAGE as MESSAGE
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetBilling]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spu_GetBilling](@BillID int,@LoginID int)
as
begin
	if @BillID=0
		begin
			declare @DocNo varchar(500)='',@DocNo_Series int=0,@BillingDocNo varchar(500)=''
			
			select  top 1  @DocNo_Series = (right(left(DocNo, 9),6)) from Billing where Isdeleted=0 order by BillID desc 
			set @DocNo_Series=@DocNo_Series+1
			set @DocNo_Series=format(@DocNo_Series,'000000')

			select @BillingDocNo= ConfigValue from ConfigSetting where ConfigKey='BillingDocNo'
			
			select format(getdate(),'yyyy-MM') as Date,@DocNo_Series as DocNo_Series,@BillingDocNo as BillingDocNo
		end
	else
		begin
			select ROW_NUMBER() OVER (Order By b.BillID desc) As RowNum, 
			format(CAST(CAST(b.Month AS VARCHAR(4)) + '/01/' + CAST(b.Year AS VARCHAR(4)) AS date),'yyyy-MM')as Date,
			b.BillID, b.DocNo, format(b.DocDate,'yyyy-MM') as DocDate, b.FYID, b.Month, b.Year,B.StateName,
			right(left(DocNo, 9),6) as DocNo_Series,
			b.Department,b.Designation,b.DealerType, b.ClientCode, b.ClientName,
			 b.SC_Code, b.SC_Name, b.SC_GSTNo, b.SC_PANNo, b.SC_CountryName,b.SC_CountryCode, b.SC_StateName ,B.SC_StateCode,b.SC_StateTIN,
			b.SC_ZipCode, b.SC_Address, b.SC_Phone, b.SC_Email,  b.Description, b.AgencyPer, b.AgencyCommission, b.Gross_Amt, b.HSNCode, b.IGST, b.IGST_Amt, b.CGST, b.CGST_Amt, b.SGST,
			b.SGST_Amt, b.Total_Amt, b.Priority,b.IsActive,b.EMPCount
			FROM Billing as b
			where b.BillID=@BillID
		end

	-- Cleint List
		select ROW_NUMBER() OVER (Order By Priority,ClientCode) As RowNum, 
		MC.ClientID as ID,MC.ClientCode as  Name
		from Master_Clients as MC
		inner join UserClient_Mapping as UCM on MC.ClientID=UCM.ClientID
		where isdeleted=0 and IsActive=1 and UCM.LoginID=@LoginID


	-- HSN List
	select ROW_NUMBER() OVER (Order By Priority,HSNCode) As RowNum, 
	HSNID as ID,HSNCode as Name
	from Master_HSN where isdeleted=0 and IsActive=1 

	-- Department
	select ROW_NUMBER() OVER (Order By Priority,DeptName) As RowNum, 
	DeptID as ID,DeptName as Name
	from Master_Department where isdeleted=0 and IsActive=1 

	-- Designation 
	select ROW_NUMBER() OVER (Order By Priority,DesignName) As RowNum, 
	DesignID as ID,DesignName as Name
	from Master_Designation where isdeleted=0 and IsActive=1

	-- State list
	select ROW_NUMBER() OVER (Order By Priority,StateName) As RowNum, 
	StateID as ID,StateName as Name
	from Masters_State where isdeleted=0 and IsActive=1 

	-- dealer Type
	select ROW_NUMBER() OVER (Order By Priority,Code) As RowNum, 
	DealerTypeID as ID,Code as Name
	from Master_Dealer_Type where isdeleted=0 and IsActive=1

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetBilling_RPT]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetBilling_RPT](@BillID int,@LoginID int)
as
begin
	select 
	b.BillID, b.DocNo, format(b.DocDate,C.ConfigValue) as DocDate, b.FYID,Fy.Code as FyName, 
	b.Month, b.Year,format(CAST(CAST(b.Month AS VARCHAR(4)) + '/01/' + CAST(b.Year AS VARCHAR(4)) AS date),'MMM-yyyy')as MonthYear,
	b.Department,b.Designation, b.ClientCode, b.ClientName,
	 b.SC_Code, b.SC_Name, b.SC_GSTNo, b.SC_PANNo, b.SC_CountryName,b.SC_CountryCode, b.SC_StateName,B.SC_StateCode,b.SC_StateTIN,
	b.SC_ZipCode, b.SC_Address, b.SC_Phone, b.SC_Email,  b.Description, b.AgencyPer, b.AgencyCommission, (b.AgencyCommission+b.Gross_Amt) as Gross_Amt, b.HSNCode, b.IGST, b.IGST_Amt, b.CGST, b.CGST_Amt, b.SGST,
	b.SGST_Amt, b.Total_Amt, 
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,
	format(b.CreatedDate,C.ConfigValue) as CreatedDate,
	format(b.ModifiedDate,C.ConfigValue) as ModifiedDate,b.IPAddress
	FROM Billing as b
	inner join Financial_Years as fy on Fy.FinID=b.FyID and Fy.Isdeleted=0
	left outer join UserEMP_View Cby on Cby.LoginID=b.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=b.ModifiedBy
	left outer join ConfigSetting as C on C.ConfigKey='DateFormatC'
	where b.BillID=@BillID


	-- Get Tran
	select  ROW_NUMBER() OVER (Order By a.Priority,a.EMPCode) As RowNum, 
	format(CAST(CAST(b.Month AS VARCHAR(4)) + '/01/' + CAST(b.Year AS VARCHAR(4)) AS date),'MMM-yyyy')as MonthYear,
	a.BillingTranID, a.BillID, a.EMPName, a.EMPCode, a.DealerName,a.DealerType, a.Gender, a.Department, a.Designation, a.State,a.Location, a.PayDays, a.NetPay, a.Incentive, a.NetGross, a.CTC, 
	a.Tran_AgencyPer, a.Tran_AgencyCommission, a.Total,
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,
	format(a.CreatedDate,C.ConfigValue) as CreatedDate,
	format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,a.IPAddress
	FROM            Billing_Tran as a
	inner join Billing as b on b.BillID = a.BillID
	left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
	left outer join ConfigSetting as C on C.ConfigKey='DateFormatC'
	where a.Isdeleted=0 and a.BillID=@BillID

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetBilling_StaffList]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetBilling_StaffList 5,2022,'Blue STar','','','','','','',0
CREATE proc [dbo].[spu_GetBilling_StaffList](@Month int,@year Int, @ClientCode varchar(500),@SubClientCode varchar(500),@HSNCode varchar(500),@Department varchar(500),@Designation varchar(500),@StateName varchar(500),@DealerType varchar(500), @LoginID int)
as
begin
SET NOCOUNT ON

	create table #Billing (Gross_Amt decimal, AgencyPer decimal(15,2),AgencyCommission decimal(15,2), IGST decimal(15,2),IGST_Amt decimal(15,2),CGST decimal(15,2),CGST_Amt decimal(15,2),SGST decimal(15,2),SGST_Amt decimal(15,2),Total_Amt decimal(15,2))
	
	create table  #StaffList ([Year] varchar(4),[Month] varchar(2),[companyCode] varchar(500),[EMPNAME] varchar(500),[empCode] varchar(500)
	,[GENDER] varchar(10),[DealerName] varchar(500),[Dealertype] varchar(500),[State] varchar(500),[Location] varchar(500),[Department] varchar(500),[Designation] varchar(500),[PAYDAYS] decimal(15,2),[Grade] varchar(500)
	,NETPAY decimal(15,2),Incentive decimal(15,2),NETGROSSTOTAL decimal(15,2),CTC decimal)


	declare @CGST decimal(15,2)=0,@SGST decimal(15,2)=0,@IGST decimal(15,2)=0,@AgencyPer decimal(15,2)=0,@SubClientStateID int=0
	select @CGST=CGST,@SGST=SGST,@IGST=IGST from Master_HSN where HSNCode=@HSNCode and Isdeleted=0

	select @AgencyPer =MCT.Commission,@SubClientStateID=MCT.StateID from Master_Clients as MC inner join Master_Clients_Tran as MCT on MCT.ClientID=MC.ClientID and MCT.Isdeleted=0
	where MC.ClientCode=@ClientCode and MC.Isdeleted=0 and MCT.Code=@SubClientCode

	if @SubClientStateID=9
		begin
			set @IGST=0;
		end
	else
		begin
			set @SGST=0;
			set @CGST=0;
		end
	insert into #StaffList
	exec ProHRMS.dbo.PaySP_GetSalaryDetails_THRV @Month,@year
	--exec ProHRMS.dbo.PaySP_GetSalaryDetails_THRV 5,2022

	insert into #Billing(IGST,CGST,SGST,AgencyPer,Gross_Amt)
	select @IGST,@CGST,@SGST,@AgencyPer,sum(SL.CTC) from #StaffList as SL


	-- 0 Table
	select * from #Billing

	-- 1 table
	select [Year] ,[Month] ,[companyCode] ,[EMPNAME],[empCode],[GENDER],[DealerName],[Dealertype],[State] ,[Location],[Department],[Designation],[PAYDAYS],[Grade]
	,NETPAY,Incentive,NETGROSSTOTAL,CTC
	,@AgencyPer as Tran_AgencyPer,cast(round((((CTC*@AgencyPer)/100)),2) as decimal(18,2))  as Tran_AgencyCommission,
	(CTC+cast(round((((CTC*@AgencyPer)/100)),2) as decimal(18,2)))as Total
	from #StaffList as a
	inner join Master_Clients as mc on MC.OtherCode= a.companyCode and mc.Isdeleted=0
	where mc.ClientCode=@ClientCode 
	and a.Department in ( select * from dbo.splitstring((case when @Department !='' then @Department else a.Department end)))
	and a.Designation in ( select * from dbo.splitstring((case when @Designation !='' then @Designation else a.Designation end)))
	and a.State in ( select * from dbo.splitstring((case when @StateName !='' then @StateName else a.State end)))
	and a.Dealertype in ( select * from dbo.splitstring((case when @DealerType !='' then @DealerType else a.Dealertype end)))
	
	

IF @@ERROR > 0
BEGIN
	DROP TABLE #StaffList,#Billing
	SET NOCOUNT OFF
	RETURN
END 

DROP TABLE #StaffList,#Billing
SET NOCOUNT OFF  

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetBilling_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetBilling_Tran](@BillID int,@LoginID int)
as
begin
	select  ROW_NUMBER() OVER (Order By a.Priority,a.EMPCode) As RowNum, 
	format(CAST(CAST(b.Month AS VARCHAR(4)) + '/01/' + CAST(b.Year AS VARCHAR(4)) AS date),'MMM-yyyy')as MonthYear,
	a.BillingTranID, a.BillID, a.EMPName, a.EMPCode, a.DealerName,a.DealerType, a.Gender, a.Department, a.Designation, a.State,a.Location, a.PayDays, a.NetPay,
	 a.Incentive, a.NetGross, a.CTC, 
	a.Tran_AgencyPer, a.Tran_AgencyCommission, a.Total,
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,
	format(a.CreatedDate,C.ConfigValue) as CreatedDate,
	format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,a.IPAddress
	FROM            Billing_Tran as a
	inner join Billing as b on b.BillID = a.BillID
	left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
	left outer join ConfigSetting as C on C.ConfigKey='DateFormatC'
	where a.Isdeleted=0 and a.BillID=@BillID

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetBillingList]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetBillingList 6,2022,2,'','',1
CREATE proc [dbo].[spu_GetBillingList](@Month int,@Year int,@FYID int,@ClientCode varchar(500),@SC_Code varchar(500),@LoginID int)
as
begin
	
	select ROW_NUMBER() OVER (Order By b.BillID desc) As RowNum, 
	b.BillID, b.DocNo, format(b.DocDate,C.ConfigValue) as DocDate, b.FYID,Fy.Code as FyName, b.Month, b.Year,
	b.Department,b.Designation,b.DealerType, b.ClientCode, b.ClientName,b.StateName,
	 b.SC_Code, b.SC_Name, b.SC_GSTNo, b.SC_PANNo, b.SC_CountryName,b.SC_CountryCode, b.SC_StateName,B.SC_StateCode,b.SC_StateTIN,
	b.SC_ZipCode, b.SC_Address, b.SC_Phone, b.SC_Email,  b.Description, b.AgencyPer, b.AgencyCommission, b.Gross_Amt, b.HSNCode, b.IGST, b.IGST_Amt, b.CGST, b.CGST_Amt, b.SGST,
	b.SGST_Amt, b.Total_Amt, b.Priority,b.IsActive,b.EMPCount,
	isnull((select Count(*) from Billing_Tran as BT where BT.BillID=B.BillID and BT.Isdeleted=0),0) as TranCount,
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,
	format(b.CreatedDate,C.ConfigValue) as CreatedDate,
	format(b.ModifiedDate,C.ConfigValue) as ModifiedDate,b.IPAddress
	FROM Billing as b
	inner join Financial_Years as fy on Fy.FinID=b.FyID and Fy.Isdeleted=0
	left outer join UserEMP_View Cby on Cby.LoginID=b.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=b.ModifiedBy
	left outer join ConfigSetting as C on C.ConfigKey='DateFormatC'

	where  b.isdeleted=0 and B.Month=@Month and b.Year=@Year 
	and	b.FYID = (case when @FYID=0 then b.FYID else @FYID end)
	and	b.ClientCode = (case when @ClientCode='' then b.ClientCode else @ClientCode end)
	and	b.SC_Code = (case when @SC_Code='' then b.SC_Code else @SC_Code end)

	and b.ClientCode in (select MC.ClientCode from UserClient_Mapping as UCM 
						inner join Master_Clients as MC on MC.ClientID=UCM.ClientID and MC.isdeleted=0
						where UCM.LoginID=@LoginID
						)

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetCity]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetCity](@CityID int, @LoginID int)
as
begin
	if @CityID=0
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,a.CityCOde) As RowNum, 
			a.CityID, a.CityCode,a.CityName, a.StateID,MS.StateName,MS.StateCode,
			a.IsActive, a.Priority,
			format(a.CreatedDate,C.ConfigValue) as CreatedDate,
			format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
			FROM Masters_City as a 
			inner join Masters_State as MS on MS.StateID=a.StateID and MS.Isdeleted=0
			left join ConfigSetting as C on C.ConfigKey='DateFormatC'
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By a.Priority,a.CityCOde) As RowNum, 
			a.CityID, a.StateID, a.CityCode, a.CityName, a.IsActive, a.Priority
			FROM Masters_City as a
			where a.Cityid=@CityID

		end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetConfigSetting]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetConfigSetting](@ConfigKey varchar(50))
as
begin
	if @ConfigKey=''
		begin
				SELECT      ROW_NUMBER() OVER (Order By ConfigKey) As RowNum, 
				ConfigID, Category, SubCategory, ConfigKey, ConfigValue, Remarks, Help
				FROM ConfigSetting
				where Isdeleted=0 and IsActive=1
		end
	else
		begin
				SELECT      ROW_NUMBER() OVER (Order By ConfigKey) As RowNum, 
				ConfigID, Category, SubCategory, ConfigKey, ConfigValue, Remarks, Help
				FROM ConfigSetting
				where ConfigKey=@ConfigKey and  Isdeleted=0 and IsActive=1
		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetCountry]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetCountry](@CountryID int, @LoginID int)
as
begin
	if @CountryID=0
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,a.CountryCode) As RowNum, 
			a.CountryID, a.CountryName, a.CountryCode, a.IsActive, a.Priority,
			format(a.CreatedDate,C.ConfigValue) as CreatedDate,
			format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
			FROM Masters_Country as a 
			left join ConfigSetting as C on C.ConfigKey='DateFormatC'
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By a.Priority,a.CountryCode) As RowNum, 
			a.CountryID, a.CountryName, a.CountryCode, a.IsActive, a.Priority
			FROM Masters_Country as a
			where a.CountryID=@CountryID

		end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetDealerType]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetDealerType](@DealerTypeID int, @LoginID int)
as
begin

	if @DealerTypeID !=0
		begin
			select DealerTypeID, a.Name, a.Code,a.isactive,a.Priority from Master_Dealer_Type as a where DealerTypeID=@DealerTypeID
		end
	else
		begin
			declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
			select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

			SELECT ROW_NUMBER() OVER (Order By a.Priority,a.Name) As RowNum,
			DealerTypeID, a.Name, a.Code, a.Isactive,a.Priority,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy
			FROM  Master_Dealer_Type as a
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0
		end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetDepartment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetDepartment](@DeptID int,@LoginID int)
as
begin
	declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
	select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	if @DeptID=0
		begin
			select ROW_NUMBER() OVER (Order By Priority,a.DeptName) As RowNum, 
			DeptID, DeptCode, a.DeptName, IsActive, Priority, 
			CreatedBy, ModifiedBy, IPAddress,
			format(CreatedDate,@DateFormatC) as CreatedDate,
			format(ModifiedDate,@DateFormatC) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy
			FROM            Master_Department as a
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By Priority,DeptName) As RowNum, 
			DeptID, DeptCode, DeptName, IsActive, Priority, 
			CreatedBy, CreatedDate, ModifiedDate, ModifiedBy, IPAddress
			FROM            Master_Department
			where DeptID=@DeptID

		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetDesignation]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetDesignation](@DesignID int,@LoginID int)
as
begin
	declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
	select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	if @DesignID=0
		begin
			select ROW_NUMBER() OVER (Order By Priority,DesignName) As RowNum, 
			DesignID, DesignCode, DesignName, IsActive, Priority,
			CreatedBy, ModifiedBy, IPAddress,
			format(CreatedDate,@DateFormatC) as CreatedDate,
			format(ModifiedDate,@DateFormatC) as ModifiedDate
			FROM Master_Designation
			where Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By Priority,DesignName) As RowNum, 
			DesignID, DesignCode, DesignName, IsActive, Priority
			FROM Master_Designation
			where DesignID=@DesignID

		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetDropDownList]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetDropDownList](@Doctype varchar(50),@Values varchar(500),@LoginID int)
as
begin
	if @Doctype='UserList'
		begin
			select LoginID as ID, EMPName as Name from UserEMP_View  
		end
	else if @Doctype='Department'
		begin
			select ROW_NUMBER() OVER (Order By priority,DeptName) As RowNum,
			DeptID as ID,DeptName as Name from Master_Department
			where isdeleted=0 and isactive=1 
		end	
	else if @Doctype='Designation'
		begin
			select ROW_NUMBER() OVER (Order By priority,DesignName) As RowNum,
			DesignID as ID,DesignName as Name from Master_Designation
			where isdeleted=0 and isactive=1 
		end	
	else if @Doctype='FinancialYear'
		begin
			select ROW_NUMBER() OVER (Order By Priority,Code) As RowNum, 
			FinID  as ID,Code as Name
			from Financial_Years where isdeleted=0 and IsActive=1 
		end	
	else if @Doctype='ClientList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,ClientCode) As RowNum, 
			MC.ClientID as ID,MC.ClientCode as  Name
			from Master_Clients as MC
			inner join UserClient_Mapping as UCM on MC.ClientID=UCM.ClientID
			where isdeleted=0 and IsActive=1 and UCM.LoginID=@LoginID
		end	
	else if @Doctype='SubClientList'
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,Name) As RowNum, 
			a.ClientTranID as ID,a.Code as Name
			from Master_Clients_Tran as a
			inner join Master_Clients as MC on MC.ClientID=a.ClientID and MC.Isdeleted=0
			 where a.isdeleted=0 and a.IsActive=1 and MC.ClientCode=@Values
		end
	else if @Doctype='HSNList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,HSNCode) As RowNum, 
			HSNID as ID,HSNCode as Name
			from Master_HSN where isdeleted=0 and IsActive=1 
		end	
	else if @Doctype='CountryList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,CountryName) As RowNum, 
			CountryID as ID,CountryName as Name
			from Masters_Country where isdeleted=0 and IsActive=1
		end	
	else if @Doctype='StateList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,StateName) As RowNum, 
			StateID as ID,StateName as Name
			from Masters_State where isdeleted=0 and IsActive=1 
		end	
	else if @Doctype='Region'
		begin
			select ROW_NUMBER() OVER (Order By Priority,RegionName) As RowNum, 
			RegionID as ID,RegionName as Name
			from Masters_Region where isdeleted=0 and IsActive=1  and CountryID=@Values
		end	
	else if @Doctype='State'
		begin
			select ROW_NUMBER() OVER (Order By Priority,StateName) As RowNum, 
			StateID as ID,StateName as Name
			from Masters_State where isdeleted=0 and IsActive=1  and RegionID=@Values
		end	
	else if @Doctype='City'
		begin
			select ROW_NUMBER() OVER (Order By Priority,CityName) As RowNum, 
			CityID as ID,CityName as Name
			from Masters_City where isdeleted=0 and IsActive=1  and StateID=@Values
		end	
	else if @Doctype='RegionList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,RegionName) As RowNum, 
			RegionID as ID,RegionName+' ( '+RegionCode+' )' as Name
			from Masters_Region where isdeleted=0 and IsActive=1 
		end	
	else if @Doctype='DepartmentList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,DeptName) As RowNum, 
			DeptID as ID,DeptName as Name
			from Master_Department where isdeleted=0 and IsActive=1 
		end	
	else if @Doctype='DesignationList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,DesignName) As RowNum, 
			DesignID as ID,DesignName as Name
			from Master_Designation where isdeleted=0 and IsActive=1
		end	
	else if @Doctype='DealerTypeList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,Code) As RowNum, 
			DealerTypeID as ID,Code as Name
			from Master_Dealer_Type where isdeleted=0 and IsActive=1
		end	
	else if @Doctype='Helpdesk_CategoryList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,CategoryName) As RowNum, 
			CategoryID as ID,CategoryName as Name
			from  Helpdesk_Category where isdeleted=0 and IsActive=1
		end
	else if @Doctype='Helpdesk_SubCategoryList'
		begin
			select ROW_NUMBER() OVER (Order By Priority,SubCategoryID) As RowNum, 
			SubCategoryID as ID,SubName as Name
			from  Helpdesk_SubCategory where isdeleted=0 and IsActive=1 and CategoryID=@Values
		end
	else if @Doctype='Helpdesk_NotesStatus_List'
		begin
			select ROW_NUMBER() OVER (Order By Priority,DisplayName) As RowNum, 
			StatusID as ID,DisplayName as Name
			from  Helpdesk_Status where isdeleted=0 and IsActive=1 
		end
	else if @Doctype='Helpdesk_UserList'
		begin
			select ROW_NUMBER() OVER (Order By EMPName) As RowNum, 
			LoginID as ID,EMPName as Name
			from  UserEMP_View where LoginID not in (select LoginID from Helpdesk_Ticket_Assignee where Isdeleted=0 and TicketID=@Values)
		end
	else if @Doctype='LeadStatusList'
		begin
			select ROW_NUMBER() OVER (Order By DisplayName) As RowNum, 
			StatusID as ID,DisplayName as Name
			from  Lead_Status where Isdeleted=0
		end
	else 
		begin
			select ROW_NUMBER() OVER (Order By Priority,Name) As RowNum, 
			MasterID as ID,Name
			from Masters where isdeleted=0 and IsActive=1 and tablename=@Doctype
		end	


end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetEInvoice_Report]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetEInvoice_Report](@Month int,@Year Int,@LoginID int)
as
begin
		select ROW_NUMBER() OVER (Order By b.DocNo desc) As RowNum, 
		b.ClientCode as[Company],b.DocNo as [Invoice Number], DATENAME(month, DATEADD(month, b.month -1, CAST('2008-01-01' AS datetime))) as Month ,b.DocDate as [Invoice Date],
		b.Department,mr.RegionName as [Region], b.SC_StateName as [State], b.EMPCount as [No of EMP], sum(bt.CTC) as [Sub Total],
		cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2))as [Agency Fee],
		sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2))as [Total Gross], 
		--IGST
		b.IGST as [IGST%],
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.IGST/100,2)as decimal(18,2)) as[IGST Amt] ,
		--CGST
		b.cGST as [CGST%],
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.CGST/100,2)as decimal(18,2)) as[CGST Amt] ,
		--SGST
		b.SGST as [SGST%],
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.SGST/100,2)as decimal(18,2)) as[SGST Amt],

		--Invoice Amount 
		(sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)) +
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.IGST/100,2)as decimal(18,2)) +
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.CGST/100,2)as decimal(18,2)) +
		Cast(round((sum(bt.ctc)+cast(round(sum(bt.CTC*b.AgencyPer/100),2) as decimal (18,2)))*b.SGST/100,2)as decimal(18,2)))as [Total Invoice Amt]
		from Billing as b
		inner join Billing_Tran as bt on bt.BillID = b.BillID
		inner join Masters_State as ms on ms.TIN= b.SC_StateTIN
		inner join Masters_Region as mr on mr.RegionID = ms.RegionID
		where b.Isdeleted =0 and b.IsActive =1 
		group by  b.ClientCode,  b.DocNo, b.month,b.DocDate, b.Department, b.SC_StateName, b.EMPCount, b.AgencyCommission,b.IGST, b.IGST_Amt, b.cGST, b.cGST_Amt,b.SGST,
		b.sGST_Amt,b.Total_Amt,mr.RegionName,b.AgencyPer
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetEmailTemplate]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetEmailTemplate](@TemplateID int)
as 
begin
		declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
		select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

if @TemplateID=0
begin
		SELECT  ROW_NUMBER() OVER (Order By TemplateName,Priority) As RowNum,
		TemplateID, TemplateName,SMSBody,Repository, Body, Subject, CCMail, BCCMail, SMSBody,Repository,a.IsActive,
		format(a.CreatedDate,@DateFormatC) as CreatedDate,
		format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
		isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
		FROM  EmailTemplate as a
		left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
		left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
		where a.isdeleted =0

end
else
begin
		SELECT  ROW_NUMBER() OVER (Order By TemplateName,Priority) As RowNum,
		TemplateID, TemplateName,SMSBody,Repository, Body, Subject, CCMail, BCCMail, SMSBody,Repository,a.IsActive,
		format(a.CreatedDate,@DateFormatC) as CreatedDate,
		format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
		isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
		FROM  EmailTemplate as a
		left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
		left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
		where TemplateID=@TemplateID

end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetErrorLog]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetErrorLog](@ID int,@LoginID int)
as
begin
		declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
		select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	 select ROW_NUMBER() OVER (Order By ID desc) As RowNum, 
	  ID, ErrDescription, SystemException, ActiveFunction, ActiveForm, ActiveModule, CreatedBy, 
	  format(CreatedDate,@DateFormatC) as CreatedDate,
		IPAddress
	 FROM   Error_Log
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_Category]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetHelpdesk_Category](@CategoryID int,@LoginID int)
as
begin
	if @CategoryID=0
		begin
			select C.CategoryID, C.CategoryName, C.CategoryDesc, C.IsActive, C.Priority, 
			format(C.CreatedDate,Con.ConfigValue) as CreatedDate,
			format(C.ModifiedDate,Con.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,c.IPAddress
			FROM    Helpdesk_Category as C
			left outer join UserEMP_View Cby on Cby.LoginID=c.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=c.ModifiedBy
			left join ConfigSetting as Con on ConfigKey='DateFormatC'
			where C.Isdeleted=0
		end
	else
		begin
			select C.CategoryID, C.CategoryName, C.CategoryDesc, C.IsActive, C.Priority
			FROM    Helpdesk_Category as C
			where C.CategoryID=@CategoryID
		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_Status]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetHelpdesk_Status](@StatusID int,@LoginID int)
as
begin
	if @StatusID=0
		begin
			select sc.StatusID,Sc.StatusName, SC.DisplayName,SC.Icon,SC.Color,SC.IsActive,SC.Priority,
			format(SC.CreatedDate,Con.ConfigValue) as CreatedDate,
			format(SC.ModifiedDate,Con.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,SC.IPAddress
			FROM     Helpdesk_Status as SC
			left outer join UserEMP_View Cby on Cby.LoginID=SC.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=SC.ModifiedBy
			left join ConfigSetting as Con on ConfigKey='DateFormatC'
			where SC.Isdeleted=0
		end
	else
		begin
			select StatusID,StatusName, DisplayName, Icon, Color, IsActive, Priority
			FROM   Helpdesk_Status
			where StatusID=@StatusID
		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_SubCategory]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetHelpdesk_SubCategory](@SubCategoryID int,@LoginID int)
as
begin
	
	select sc.SubCategoryID,sc.SubName,sc.SubDesc, sc.CategoryID, sc.IsActive, sc.Priority
	FROM     Helpdesk_SubCategory as sc
	where sc.SubCategoryID=@SubCategoryID

	--Category List
	select ROW_NUMBER() OVER (Order By Priority,CategoryName) As RowNum, 
	CategoryID as ID,CategoryName as Name
	from  Helpdesk_Category where isdeleted=0 and IsActive=1

	-- User List
	select LoginID as ID, EMPName as Name from UserEMP_View  
	

	-- SubCategoryUser
	select LoginID as ID from Helpdesk_SubCategory_Users where SubCategoryID=@SubCategoryID and Isdeleted=0
		
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_SubCategoryList]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetHelpdesk_SubCategoryList](@LoginID int)
as
begin
	
		select SC.SubCategoryID, SC.CategoryID, C.CategoryName, SC.SubName,SC.SubDesc,
		( select dbo.fnGetHelpdesk_SubCategory_Users_Values(SC.SubCategoryID))as Users,
		 SC.IsActive, SC.Priority, 
		format(SC.CreatedDate,Con.ConfigValue) as CreatedDate,
		format(SC.ModifiedDate,Con.ConfigValue) as ModifiedDate,
		isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,c.IPAddress
		FROM     Helpdesk_SubCategory as SC
		inner join Helpdesk_Category as C on C.CategoryID=sc.CategoryID and C.isdeleted=0
		left outer join UserEMP_View Cby on Cby.LoginID=c.CreatedBy
		left outer join UserEMP_View Mby on Mby.LoginID=c.ModifiedBy
		left join ConfigSetting as Con on ConfigKey='DateFormatC'
		where SC.Isdeleted=0
		
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_Ticket_Details]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetHelpdesk_Ticket_Details 21,0
CREATE proc [dbo].[spu_GetHelpdesk_Ticket_Details](@TicketID int,@LoginID int)
as
begin
	-- Ticket Detai;s
	select ROW_NUMBER() OVER (Order By HT.ModifiedDate desc) As RowNum, 
	HT.TicketID, HT.TicketNo, HT.CurrentStatusID,s.DisplayName as CurrentStatus,s.Color as CurrentStatus_Color,s.icon as CurrentStatus_Icon, HT.CategoryID,C.CategoryName, HT.SubCategoryID,SC.SubName as SubCategoryName, HT.Subject, HT.Message, 
	HT.TicketPriority,HT.Latest_Notes,
	format(HT.Latest_NextDate,con.ConfigValue) as Latest_NextDate,
	format(HT.CreatedDate,con.ConfigValue) as CreatedDate,
	format(HT.ModifiedDate,con.ConfigValue) as ModifiedDate,
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,HT.IPAddress
	FROM   Helpdesk_Ticket as HT
	inner join Helpdesk_Status as s on s.StatusID=HT.CurrentStatusID and s.Isdeleted=0
	inner join Helpdesk_Category as C on C.CategoryID=HT.CategoryID and C.Isdeleted=0
	inner join Helpdesk_SubCategory as SC on SC.CategoryID=C.CategoryID and sc.SubCategoryID=HT.SubCategoryID and SC.Isdeleted=0
	inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
	left outer join UserEMP_View Cby on Cby.LoginID=HT.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=HT.ModifiedBy
	left join  ConfigSetting as con on ConfigKey='DateFormatC'
	where HT.isdeleted=0  and HT.TicketID=@TicketID
	-- LoginID not checking
	group by HT.ModifiedDate,HT.TicketID, HT.TicketNo, HT.CurrentStatusID,s.DisplayName,s.Color,s.icon, HT.CategoryID,C.CategoryName, HT.SubCategoryID,SC.SubName, HT.Subject, HT.Message, 
	HT.TicketPriority,HT.Latest_Notes,
	format(HT.Latest_NextDate,con.ConfigValue),	format(HT.CreatedDate,con.ConfigValue),format(HT.ModifiedDate,con.ConfigValue),
	isnull(Cby.EMPName,''),isnull(Mby.EMPName,''),HT.IPAddress

	-- Assignee List
	select ROW_NUMBER() OVER (Order By TA.AssignID desc) As RowNum,TA.LoginID, U.EMPName,U.EmailID,TA.Doctype from Helpdesk_Ticket_Assignee as TA
	inner join UserEMP_View as U on U.LoginID=TA.LoginID
	where TA.Isdeleted=0 and TA.TicketID=@TicketID

	-- Deferred List
	select ROW_NUMBER() OVER (Order By TA.DeferredID desc) As RowNum,TA.LoginID, U.EMPName,U.EmailID 
	from Helpdesk_Ticket_Deferred as TA
	inner join UserEMP_View as U on U.LoginID=TA.LoginID
	where TA.Isdeleted=0 and TA.TicketID=@TicketID

	-- Ticket ID Notes
	SELECT  ROW_NUMBER() OVER (Order By HN.ModifiedDate desc) As RowNum, 
	HN.NotesID, HN.TicketID, HN.StatusID, 
	case when HN.NextDate is null then '' else format(HN.NextDate,con.ConfigValue) end as NextDate,
	 HN.Notes, s.DisplayName,s.Color,s.icon,
	format(HN.CreatedDate,con.ConfigValue) as CreatedDate,
	format(HN.ModifiedDate,con.ConfigValue) as ModifiedDate,
	isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,HN.IPAddress
	FROM Helpdesk_Ticket_Notes as HN
	inner join Helpdesk_Status as s on s.StatusID=HN.StatusID and s.Isdeleted=0
	left outer join UserEMP_View Cby on Cby.LoginID=HN.CreatedBy
	left outer join UserEMP_View Mby on Mby.LoginID=HN.ModifiedBy
	left join  ConfigSetting as con on ConfigKey='DateFormatC'
	where HN.TicketID=@TicketID and HN.Isdeleted=0

	---- User List
	--select U.LoginID, U.EMPName,U.EmailID  from UserEMP_View as U
	--where LoginID not in (select LoginID from Helpdesk_Ticket_Assignee where Isdeleted=0 and TicketID=@TicketID)
	--and LoginID not in (select LoginID from Helpdesk_Ticket_Deferred where Isdeleted=0 and TicketID=@TicketID)


	select TicketID,NotesID,FileName,ContentType,Description, ('/Attachments/Helpdesk/'+format(a.createdDate,'MMMyyyy')+'/' + a.FileName +''+a.ContentType )as Filepath
	from Helpdesk_Ticket_Attachments as a where TicketID=@TicketID and a.isdeleted=0
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_Tickets_Count]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spu_GetHelpdesk_Tickets_Count]
(@LoginID int)
as
begin
		SET NOCOUNT ON;  
		declare @TempTable table (StatusID int,Value int)
		declare @FinalTable table (Total int,Pending int ,InProcess int,Forward int,Completed int)

		if exists(select * from UserEMP_View where RoleID in (1,6) and LoginID=@LoginID)
			begin
				insert into @TempTable(StatusID,Value)
				select HT.CurrentStatusID,Count(HT.TicketID) as Value
				FROM  Helpdesk_Ticket as HT (Nolock)
				inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
				where HT.isdeleted=0 
				group by HT.CurrentStatusID
			end
		else
			begin
				insert into @TempTable(StatusID,Value)
				select HT.CurrentStatusID,Count(HT.TicketID) as Value
				FROM  Helpdesk_Ticket as HT (Nolock)
				inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
				where HT.isdeleted=0 and HA.LoginID= @LoginID
				group by HT.CurrentStatusID
			end
		

		insert into @FinalTable(Total,Pending,InProcess,Forward,Completed)values(0,0,0,0,0)

		update @FinalTable set Pending= isnull((select Value from @TempTable where StatusID=1),0)
		update @FinalTable set InProcess= isnull((select Value from @TempTable where StatusID=2),0)
		update @FinalTable set Forward= isnull((select Value from @TempTable where StatusID=3),0)
		update @FinalTable set Completed= isnull((select Value from @TempTable where StatusID=4),0)
		update @FinalTable set Total= isnull((select sum(Value) from @TempTable),0)
		
		select * from @FinalTable
		
end

GO
/****** Object:  StoredProcedure [dbo].[spu_GetHelpdesk_Tickets_List]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spu_GetHelpdesk_Tickets_List](@StatusID int,@LoginID int)
as
begin
	if exists(select * from UserEMP_View where RoleID in (1,6) and LoginID=@LoginID)
		begin
			select ROW_NUMBER() OVER (Order By HT.ModifiedDate desc) As RowNum, 
			HT.TicketID, HT.TicketNo, HT.CurrentStatusID,s.DisplayName as CurrentStatus,s.Color as CurrentStatus_Color,s.icon as CurrentStatus_Icon, HT.CategoryID,C.CategoryName, HT.SubCategoryID,SC.SubName as SubCategoryName, HT.Subject, HT.Message, 
			HT.TicketPriority,HT.Latest_Notes,
			format(HT.Latest_NextDate,con.ConfigValue) as Latest_NextDate,
			format(HT.CreatedDate,con.ConfigValue) as CreatedDate,
			format(HT.ModifiedDate,con.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,HT.IPAddress
			FROM            Helpdesk_Ticket as HT
			inner join Helpdesk_Status as s on s.StatusID=HT.CurrentStatusID and s.Isdeleted=0
			inner join Helpdesk_Category as C on C.CategoryID=HT.CategoryID and C.Isdeleted=0
			inner join Helpdesk_SubCategory as SC on SC.CategoryID=C.CategoryID and sc.SubCategoryID=HT.SubCategoryID and SC.Isdeleted=0
			inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
			left outer join UserEMP_View Cby on Cby.LoginID=HT.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=HT.ModifiedBy
			left join  ConfigSetting as con on ConfigKey='DateFormatC'
			where HT.isdeleted=0 and HT.CurrentStatusID= @StatusID
			-- LoginID not checking
			group by HT.ModifiedDate,HT.TicketID, HT.TicketNo, HT.CurrentStatusID,s.DisplayName,s.Color,s.icon, HT.CategoryID,C.CategoryName, HT.SubCategoryID,SC.SubName, HT.Subject, HT.Message, 
			HT.TicketPriority,HT.Latest_Notes,
			format(HT.Latest_NextDate,con.ConfigValue),	format(HT.CreatedDate,con.ConfigValue),format(HT.ModifiedDate,con.ConfigValue),
			isnull(Cby.EMPName,''),isnull(Mby.EMPName,''),HT.IPAddress
		end
	else
		begin
			select ROW_NUMBER() OVER (Order By HT.ModifiedDate desc) As RowNum, 
			HT.TicketID, HT.TicketNo, HT.CurrentStatusID,s.DisplayName as CurrentStatus,s.Color as CurrentStatus_Color,s.icon as CurrentStatus_Icon, HT.CategoryID,C.CategoryName, HT.SubCategoryID,SC.SubName as SubCategoryName, HT.Subject, HT.Message, 
			HT.TicketPriority,HT.Latest_Notes,
			format(HT.Latest_NextDate,con.ConfigValue) as Latest_NextDate,
			format(HT.CreatedDate,con.ConfigValue) as CreatedDate,
			format(HT.ModifiedDate,con.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,HT.IPAddress
			FROM            Helpdesk_Ticket as HT
			inner join Helpdesk_Status as s on s.StatusID=HT.CurrentStatusID and s.Isdeleted=0
			inner join Helpdesk_Category as C on C.CategoryID=HT.CategoryID and C.Isdeleted=0
			inner join Helpdesk_SubCategory as SC on SC.CategoryID=C.CategoryID and sc.SubCategoryID=HT.SubCategoryID and SC.Isdeleted=0
			inner join Helpdesk_Ticket_Assignee as HA on HA.TicketID=HT.TicketID and HA.Isdeleted=0
			left outer join UserEMP_View Cby on Cby.LoginID=HT.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=HT.ModifiedBy
			left join  ConfigSetting as con on ConfigKey='DateFormatC'
			where HT.isdeleted=0 and HT.CurrentStatusID= @StatusID
			and HA.LoginID= @LoginID
		end

end



GO
/****** Object:  StoredProcedure [dbo].[spu_GetLead_Details]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetLead_Details 2,1
CREATE proc [dbo].[spu_GetLead_Details](@LeadID int,@LoginID int)
as
begin
	select ROW_NUMBER() OVER (Order By L.ModifiedDate desc) As RowNum,  L.LeadID, L.TicketNo, 
	format(L.TicketDate,'dd-MMM-yyyy')as TicketDate, 
	L.StatusID,LS.DisplayName as StatusDisplay,LS.Color as StatusColor,
	format(L.Tran_NextDate,'dd-MMM-yyyy hh:mm tt')as Tran_NextDate, L.Tran_Notes,
	L.LeadType, L.CompanyName, L.CompanyBusiness,StateMst.StateName,CityMst.CityName,
	L.PinCode, L.CompanyType, L.CompanyPayroll, L.RequirementType,
	format(L.CreatedDate,con.ConfigValue) as CreatedDate,
	format(L.ModifiedDate,con.ConfigValue) as ModifiedDate,
	isnull(Cby.UserID,'')as CreatedBy,isnull(Mby.UserID,'')as ModifiedBy,L.IPAddress
	FROM            Lead  as L
	inner join Lead_Status as LS on LS.StatusID=L.StatusID
	left join Masters_State as StateMst on StateMst.StateID=L.StateID
	left join Masters_City as CityMst on CityMst.CityID=L.CityID
	left outer join Login_Users Cby on Cby.LoginID=L.CreatedBy
	left outer join Login_Users Mby on Mby.LoginID=L.ModifiedBy
	left outer join ConfigSetting as con on ConfigKey='DateFormatC'
	WHERE L.Isdeleted=0 and L.LeadID=@LeadID


	select  ROW_NUMBER() OVER (Order By ContactID) As RowNum,  ContactID, LeadID, Name, Phone, EmailID, Designation,CreatedBy,ModifiedBy,IPAddress
	from Lead_Contacts where LeadID=@LeadID and Isdeleted=0

	select  ROW_NUMBER() OVER (Order By LeadTranID desc) As RowNum,
	LeadTranID, LeadID, format(L.NextDate,'dd-MMM-yyyy hh:mm tt')as NextDate_Display, Notes, 
	L.StatusID,LS.DisplayName as StatusDisplay,LS.Color as StatusColor,
	format(L.CreatedDate,con.ConfigValue) as CreatedDate,
	format(L.ModifiedDate,con.ConfigValue) as ModifiedDate,
	isnull(Cby.UserID,'')as CreatedBy,isnull(Mby.UserID,'')as ModifiedBy,L.IPAddress
	from Lead_Tran as L 
	inner join Lead_Status as LS on LS.StatusID=L.StatusID
	left outer join Login_Users Cby on Cby.LoginID=L.CreatedBy
	left outer join Login_Users Mby on Mby.LoginID=L.ModifiedBy
	left outer join ConfigSetting as con on ConfigKey='DateFormatC'
	where LeadID=@LeadID and L.Isdeleted=0

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetLead_Export]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetLead_Export 0,1
CREATE proc [dbo].[spu_GetLead_Export](@Approved int,@LoginID int)
as
begin
	select ROW_NUMBER() OVER (Order By L.ModifiedDate desc) As RowNum,  L.TicketNo, 
	format(L.TicketDate,'dd-MMM-yyyy')as TicketDate, 
	LS.DisplayName as StatusDisplay,
	format(L.Tran_NextDate,'dd-MMM-yyyy hh:mm tt')as NextDate, L.Tran_Notes as FollowUp,
	L.LeadType, L.CompanyName, L.CompanyBusiness,StateMst.StateName,CityMst.CityName,
	L.PinCode, L.CompanyType, L.CompanyPayroll, L.RequirementType,
	format(L.CreatedDate,con.ConfigValue) as CreatedDate,
	format(L.ModifiedDate,con.ConfigValue) as ModifiedDate,
	isnull(Cby.UserID,'')as CreatedBy,isnull(Mby.UserID,'')as ModifiedBy,L.IPAddress
	FROM            Lead  as L
	inner join Lead_Status as LS on LS.StatusID=L.StatusID
	left join Masters_State as StateMst on StateMst.StateID=L.StateID
	left join Masters_City as CityMst on CityMst.CityID=L.CityID
	left outer join Login_Users Cby on Cby.LoginID=L.CreatedBy
	left outer join Login_Users Mby on Mby.LoginID=L.ModifiedBy
	left outer join ConfigSetting as con on ConfigKey='DateFormatC'
	WHERE L.Isdeleted=0


	select  ROW_NUMBER() OVER (Order By ContactID) As RowNum, 
	L.TicketNo,LC.Name, LC.Phone, LC.EmailID,LC.Designation
	from Lead_Contacts as LC 
	inner join Lead  as L on L.LeadID=LC.LeadID
	where  LC.Isdeleted=0

	select  ROW_NUMBER() OVER (Order By LT.LeadTranID desc) As RowNum,
	L.TicketNo, format(LT.NextDate,'dd-MMM-yyyy hh:mm tt')as NextDate, LT.Notes, 
	LS.DisplayName as StatusDisplay,
	format(L.CreatedDate,con.ConfigValue) as CreatedDate,
	isnull(Cby.UserID,'')as CreatedBy,L.IPAddress
	from Lead_Tran as LT 
	inner join Lead  as L on L.LeadID=LT.LeadID
	inner join Lead_Status as LS on LS.StatusID=LT.StatusID
	left outer join Login_Users Cby on Cby.LoginID=LT.CreatedBy
	left outer join ConfigSetting as con on ConfigKey='DateFormatC'
	where LT.Isdeleted=0

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetLead_List]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[spu_GetLead_List](@start INT,@length INT,@SearchText VARCHAR(50),@sortColumn Int,@sortOrder VARCHAR(50),@LoginID int,@StatusID int)
as
begin
		SET NOCOUNT ON;
		select ROW_NUMBER() OVER (Order By L.ModifiedDate desc) As RowNum,  L.LeadID, L.TicketNo, format(L.TicketDate,'dd-MMM-yyyy')as TicketDate, 
		L.StatusID,LS.DisplayName as StatusDisplay,LS.Color as StatusColor,
		format(L.Tran_NextDate,'dd-MMM-yyyy hh:mm tt')as Tran_NextDate, L.Tran_Notes,
		L.LeadType, L.CompanyName, L.CompanyBusiness,StateMst.StateName,CityMst.CityName,
		L.PinCode, L.CompanyType, L.CompanyPayroll, L.RequirementType,
		format(L.CreatedDate,con.ConfigValue) as CreatedDate,
		format(L.ModifiedDate,con.ConfigValue) as ModifiedDate,
		isnull(Cby.Name,'')as CreatedBy,isnull(Mby.name,'')as ModifiedBy,L.IPAddress,
		count(L.LeadID) OVER () AS TotalCount 
		FROM            Lead  as L
		inner join Lead_Status as LS on LS.StatusID=L.StatusID
		left join Masters_State as StateMst on StateMst.StateID=L.StateID
		left join Masters_City as CityMst on CityMst.CityID=L.CityID
		left outer join Login_Users Cby on Cby.LoginID=L.CreatedBy
		left outer join Login_Users Mby on Mby.LoginID=L.ModifiedBy
		left outer join ConfigSetting as con on ConfigKey='DateFormatC'
		 WHERE L.Isdeleted=0 
		 and L.StatusID=@StatusID 
		 and (  
            (  
                @SearchText <> ''  
                AND (  
                    L.TicketNo LIKE '%' + @SearchText + '%'  
                    OR format(L.TicketDate,'dd-MMM-yyyy') LIKE '%' + @SearchText + '%'  
					OR LS.DisplayName LIKE '%' + @SearchText + '%'  
					OR L.LeadType LIKE '%' + @SearchText + '%'  
					OR L.CompanyName LIKE '%' + @SearchText + '%'  
					OR L.CompanyBusiness LIKE '%' + @SearchText + '%' 
					OR isnull(StateMst.StateName,'') LIKE '%' + @SearchText + '%' 
					OR isnull(CityMst.CityName,'') LIKE '%' + @SearchText + '%' 
					OR L.PinCode LIKE '%' + @SearchText + '%' 
					OR L.CompanyType LIKE '%' + @SearchText + '%' 
					OR L.CompanyPayroll LIKE '%' + @SearchText + '%' 
					OR  L.RequirementType LIKE '%' + @SearchText + '%' 
					OR format(L.CreatedDate,con.ConfigValue) LIKE '%' + @SearchText + '%' 
					OR format(L.ModifiedDate,con.ConfigValue) LIKE '%' + @SearchText + '%' 
					OR isnull(Cby.UserID,'') LIKE '%' + @SearchText + '%' 
					OR isnull(Mby.UserID,'') LIKE '%' + @SearchText + '%'  
					OR L.IPAddress LIKE '%' + @SearchText + '%' 
                    )  
                )  
            OR (@SearchText = '')  
            )  
		 ORDER BY 
		CASE   
            WHEN @sortOrder <> 'ASC'  
                THEN ''  
            WHEN @sortColumn = 0
                THEN L.TicketNo
            END ASC ,
		CASE   
            WHEN @sortOrder <> 'ASC'  
                THEN ''  
            WHEN @sortColumn = 1
                THEN LS.DisplayName
            END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 2
				THEN format(L.TicketDate,'dd-MMM-yyyy')  
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 3
				THEN L.LeadType
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 4
				THEN L.CompanyName
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 5
				THEN format(L.Tran_NextDate,'dd-MMM-yyyy hh:mm tt')
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 6
				THEN L.Tran_Notes
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 7
				THEN format(L.ModifiedDate,con.ConfigValue)
			END ASC,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 8
				THEN isnull(Mby.UserID,'')
			END ASC ,
		CASE   
			WHEN @sortOrder <> 'ASC'  
				THEN ''  
		WHEN @sortColumn = 9
				THEN L.IPAddress
			END ASC ,
		CASE   
            WHEN @sortOrder <> 'DESC'  
                THEN ''  
            WHEN @sortColumn = 0
                THEN L.TicketNo
            END DESC ,
		CASE   
            WHEN @sortOrder <> 'DESC'  
                THEN ''  
            WHEN @sortColumn = 1
                THEN LS.DisplayName
            END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 2
				THEN format(L.TicketDate,'dd-MMM-yyyy')  
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 3
				THEN L.LeadType
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 4
				THEN L.CompanyName
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 5
				THEN format(L.Tran_NextDate,'dd-MMM-yyyy hh:mm tt')
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 6
				THEN L.Tran_Notes
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 7
				THEN format(L.ModifiedDate,con.ConfigValue)
			END DESC,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 8
				THEN isnull(Mby.UserID,'')
			END DESC ,
		CASE   
			WHEN @sortOrder <> 'DESC'  
				THEN ''  
		WHEN @sortColumn = 9
				THEN L.IPAddress
			END DESC 
		OFFSET @start ROWS 
		FETCH NEXT @length ROWS ONLY  
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetLogin]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetLogin](@UserID nvarchar(100),@Password nvarchar(100),@SessionID nvarchar(max),@IPAddress varchar(50))
as
begin
	if exists(select LoginID from Login_Users where UserID=@UserID and Password=@Password and Isdeleted=0 and IsActive=1)
		begin
			update Login_Users set SessionID=@SessionID,LastLogin=getdate(),IsLogin=1,
			IPAddress=@IPAddress
			where UserID=@UserID and Password=@Password and isdeleted=0

			SELECT 'true' as status,
			U.LoginID, U.UserID, U.Name,U.Phone,U.Email,U.RoleID,R.RoleName, U.LastLogin, U.IsLogin, U.SessionID,U.IsFirstLogin,
			U.AllowLogin
			from Login_Users  as U
			inner join Login_Roles as R on R.RoleID=U.RoleID and R.Isdeleted=0
			where U.UserID=@UserID and U.Password=@Password and U.Isdeleted=0
		end
	else
		begin	
			SELECT 'false' as status
		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetMailTemplate]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spu_GetMailTemplate 'Onboarding',1
CREATE proc [dbo].[spu_GetMailTemplate](@TemplateName varchar(50), @LoginID int)
as
begin
	SET NOCOUNT ON;  
	Declare @InDate date,@Attendance_Month int,@Attendance_Year int,@Month int,@Year int,@ConfigKey varchar(500)='',@ConfigValue varchar(500)='',@_Body VARCHAR(Max),@_Subject varchar(Max)=''
	

	CREATE TABLE #BodyHTML (TemplateName VARCHAR(500),Body VARCHAR(Max),Subject varchar(Max),CCMail varchar(2000),BCCMail varchar(2000),SMSBody varchar(max));
	insert into #BodyHTML(TemplateName,Body,Subject,CCMail,BCCMail,SMSBody)
	select TemplateName, Body, Subject, CCMail, BCCMail, SMSBody from EmailTemplate where TemplateName=@TemplateName and Isdeleted=0

	select @_Body=Body,@_Subject=Subject from #BodyHTML
	
	SET @_Body=REPLACE(@_Body , '#WEBSITEURL#' , (select ConfigValue from ConfigSetting where ConfigKey='WebsiteURL') )		
	SET @_Body=REPLACE(@_Body , '#WEBSITELOGOPATH#' , (select ConfigValue from ConfigSetting where ConfigKey='WebsiteLogPath') )

	update #BodyHTML set Body=@_Body,Subject=@_Subject

	-- 0 SMTP Details
	select CompanyCode, SMTP, SMTP_USER, SMTP_PASSWORD, SMTP_EMAIL, Port, EnableSsl FROM   Company
	
	-- 2 Template details

	select * from #BodyHTML

	select ConfigValue,ConfigKey from ConfigSetting where Isdeleted=0

	IF @@ERROR > 0
	BEGIN
		DROP TABLE #BodyHTML
		SET NOCOUNT OFF
		CLOSE Template_Cursor
		DEALLOCATE Template_Cursor

		RETURN
	END 
	DROP TABLE #BodyHTML

	SET NOCOUNT OFF  
end

--spu_GetAuto_ReportData '11-Jul-2022',102
GO
/****** Object:  StoredProcedure [dbo].[spu_GetMaster_Clients]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetMaster_Clients](@ClientID int,@LoginID int)
as
begin
	declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
	select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	if @ClientID=0
		begin
			select ROW_NUMBER() OVER (Order By Priority,ClientCode) As RowNum, 
			ClientID, ClientCode, ClientName, DisplayName, OtherCode,IsActive, Priority,
			CreatedBy, ModifiedBy, IPAddress,
			format(CreatedDate,@DateFormatC) as CreatedDate,
			format(ModifiedDate,@DateFormatC) as ModifiedDate
			FROM  Master_Clients
			where Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By Priority,ClientCode) As RowNum, 
			ClientID, ClientCode, ClientName, DisplayName, OtherCode,IsActive, Priority
			FROM  Master_Clients
			where ClientID=@ClientID

		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetMaster_ClientsTranList]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetMaster_ClientsTranList](@ClientTranID int, @ClientID int,@LoginID int)
as
begin
	declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
	select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	if @ClientTranID=0
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,Code) As RowNum, 
			a.ClientTranID, a.ClientID, a.Code, a.Name, a.PrintName, a.GSTNo, a.PAN, Commission, a.CountryID, a.StateID,s.StateName,s.StateCode,s.TIN as StateTIN, a.Address, a.ZipCode, a.Phone, a.EmailID,  
			a.Priority,a.Isactive,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
				isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
			FROM            Master_Clients_Tran as a
			inner join Masters_State as s on s.StateID=a.StateID and s.Isdeleted=0
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0 and a.ClientID=@ClientID
		end
	else
		begin
			select ROW_NUMBER() OVER (Order By Priority,Code) As RowNum, 
			ClientTranID, ClientID, Code, Name, PrintName, GSTNo, PAN, Commission, CountryID, StateID, Address, ZipCode, Phone, EmailID, 
			Priority,Isactive,CreatedBy, ModifiedBy, IPAddress
			FROM            Master_Clients_Tran
			where Isdeleted=0 and ClientTranID=@ClientTranID

		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetMasters]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetMasters](@MasterID int,@TableName varchar(50),@GroupID int, @LoginID int)
as
begin
	declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
	select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

	if @MasterID=0 and @GroupID=0
		begin
			SELECT ROW_NUMBER() OVER (Order By a.Priority,a.Name) As RowNum,
			a.MasterID, a.TableName, a.Name, a.Value, a.IsActive, a.Priority,a.GroupID,
			isnull(b.Name,'')as GroupName,isnull(b.Value,'')as GroupValue,
			a.createdby, a.modifiedby,  a.IsActive, a.IPAddress,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy
			FROM            Masters as a
			left outer join Masters as b on b.MasterID=a.GroupID and b.isdeleted=0 
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.TableName=@TableName and a.Isdeleted=0
		end
	else if @MasterID=0 and @GroupID>0
		begin
			SELECT ROW_NUMBER() OVER (Order By a.Priority,a.Name) As RowNum,
			a.MasterID, a.TableName, a.Name, a.Value, a.IsActive, a.Priority,a.GroupID,
			isnull(b.Name,'')as GroupName,isnull(b.Value,'')as GroupValue,
			a.createdby, a.modifiedby, a.IsActive, a.IPAddress,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy
			FROM            Masters as a
			left outer join Masters as b on b.MasterID=a.GroupID and b.isdeleted=0 
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.TableName=@TableName and a.Isdeleted=0 and a.GroupID=@GroupID
		end
	else	
		begin
			SELECT ROW_NUMBER() OVER (Order By a.Priority,a.Name) As RowNum,
			a.MasterID, a.TableName, a.Name, a.Value, a.IsActive, a.Priority,a.GroupID,
			isnull(b.Name,'')as GroupName,isnull(b.Value,'')as GroupValue,
			a.createdby, a.modifiedby,  a.IsActive, a.IPAddress,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate
			FROM            Masters as a
			left outer join Masters as b on b.MasterID=a.GroupID and b.isdeleted=0 
			where a.TableName=@TableName and a.Isdeleted=0 and a.MasterID=@MasterID
		end
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetMenu_Admin]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetMenu_Admin]
as
begin
	select M.ModuleID,LM.ModuleName,LM.ModulePriority,
	M.MenuID, M.MenuName, M.ParentMenuID, M.MenuImage, M.MenuURL, 
	M.Target,LM.ModuleIcon,M.Priority,RT.App,
	RT.RoleID, RT.R, RT.W, RT.M, RT.D,RT.E,RT.I,
	case when (Select count(a.MenuID) from  Login_Menu as a where  a.ParentMenuID= M.MenuID and a.IsActive=1 and a.Isdeleted=0)>0 then 'Y' else 'N' End as IsChild
	from Login_Menu as M
	inner join Login_Module as LM on LM.ModuleID=M.ModuleID and LM.Isdeleted=0
	inner join Login_Menu_Role_Tran as RT on RT.MenuID=M.MenuID and RT.isdeleted=0
	where M.IsActive=1 and M.Isdeleted=0
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetModuleListRoleWise]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetModuleListRoleWise](@Roleid int)
as 
begin
	select 
	MM.ModuleID,MM.ModuleName,MM.ModuleIcon,MM.ModulePriority
	from  Login_Menu as M
	inner join Login_Module as MM on MM.ModuleID=M.ModuleID and MM.isdeleted=0
	inner join Login_Menu_Role_Tran as MT on MT.MenuID=M.MenuID
	where MM.isdeleted=0 and MM.IsActive=1 and M.isdeleted=0 and M.IsActive=1 and M.MenuID !=0 AND Roleid=@Roleid
	group by MM.ModuleID,MM.ModuleName,MM.ModuleIcon,MM.ModulePriority
	order by MM.ModulePriority,ModuleName
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetOnboarding_Application]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetOnboarding_Application](@Token varchar(50),@LoginID int,@Doctype varchar(50))
as
begin
	
		SELECT  AppID, DocNo, DocDate, Name,Token, Gender, Mobile, EmailID, FatherName, 
		format(DOB,'yyyy-MM-dd')as dob,
		
		BloodGroup, MaritalStatus, 
		a.CountryID,isnull(CountryMst.CountryName,'')as CountryName,
		a.RegionID,isnull(RegionMst.RegionName,'')as RegionName,
		a.StateID,isnull(StateMst.StateName,'')as StateName,
		a.CityID, isnull(CityMst.CityName,'')as CityName,
		PINCode, Address,  PAN, VaccinationDetails,
		AadharNo, UAN, ESIC,BankName,BankBranch, AccountNo, IFSCCode,NomineeName, NomineeRelation,
		case when year(NomineeDOB)>1900 then format(NomineeDOB,'yyyy-MM-dd') else null end as NomineeDOB, 
		Remarks, 
		Approved, ApprovedRemarks, ApprovedDate, ApprovedBy,
		(case when Approved=1 then 'Approved' when Approved=2 then 'Resubmitted' else 'Pending' end)as ApprovedStatus
		FROM Onboard_Application as a
		left join Masters_Country as CountryMst on CountryMst.CountryID=a.CountryID
		left join Masters_Region as RegionMst on RegionMst.RegionID=a.RegionID
		left join Masters_State as StateMst on StateMst.StateID=a.StateID
		left join Masters_City as CityMst on CityMst.CityID=a.CityID
		where a.Isdeleted=0 and Token=@Token

		if @Doctype='BasicDetails' 
			begin
				declare @CountryID int=0,@RegionID int=0,@StateID int=0

				select  @CountryID=isnull(CountryID,0),@RegionID=isnull(RegionID,0),@StateID=isnull(StateID,0)
				from Onboard_Application where Isdeleted=0 and Token=@Token

				-- Country
				select ROW_NUMBER() OVER (Order By Priority,CountryName) As RowNum, 
				CountryID as ID,CountryName as Name
				from Masters_Country where isdeleted=0 and IsActive=1

				-- Region
				select ROW_NUMBER() OVER (Order By Priority,RegionName) As RowNum, 
				RegionID as ID,RegionName as Name
				from Masters_Region where isdeleted=0 and IsActive=1  
				and CountryID =@CountryID

				-- State
				select ROW_NUMBER() OVER (Order By Priority,StateName) As RowNum, 
				StateID as ID,StateName as Name
				from Masters_State where isdeleted=0 and IsActive=1  
				and RegionID =@RegionID
				
				-- City
				select ROW_NUMBER() OVER (Order By Priority,CityName) As RowNum, 
				CityID as ID,CityName as Name
				from Masters_City where isdeleted=0 and IsActive=1  
				and StateID =@StateID
			end
		else if @Doctype='documents' 
			begin
				declare @AppID int=0

				select  @AppID=isnull(AppID,0)
				from Onboard_Application where Isdeleted=0 and Token=@Token

				exec spu_GetOnboarding_Attachments  @AppID
			end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetOnboarding_Attachments]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetOnboarding_Attachments](@AppID int) 
as
begin
	SELECT  a.Attach_ID, [File],a.FileName, a.ContentType, a.Description,
		('/Attachments/onboard/'+format(a.createdDate,'MMMyyyy')+'/' + a.FileName +''+a.ContentType )as AttachmentPath,
		a.AppID
		FROM    Onboard_Attachment as a
		where a.AppID =@AppID and a.Isdeleted=0 

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetOnboarding_List]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetOnboarding_List](@LoginID int,@Approved int)
as
begin
	SELECT ROW_NUMBER() OVER (Order By a.ModifiedDate desc) As RowNum, 
	AppID, DocNo, DocDate, Name, Gender, Mobile, EmailID, FatherName, format(DOB,'dd-MMM-yyyy')as DOB, BloodGroup, 
	MaritalStatus, PINCode, Token,
	a.CountryID,isnull(CountryMst.CountryName,'')as CountryName,
	a.RegionID,isnull(RegionMst.RegionName,'')as RegionName,
	a.StateID,isnull(StateMst.StateName,'')as StateName,
	a.CityID, isnull(CityMst.CityName,'')as CityName,
	Address, NomineeName, format(NomineeDOB,'dd-MMM-yyyy')as NomineeDOB,  NomineeRelation, PAN, AadharNo,
	UAN, ESIC, BankName, AccountNo, IFSCCode, a.Remarks, 
	Approved, ApprovedRemarks, ApprovedDate, ApprovedBy, a.IsActive, a.IsActive_Reason, 
	a.IsActive_By, a.IsActive_Date, a.Priority, a.Isdeleted, a.DeletedBy, a.DeletedDate, a.CreatedBy,
	a.ModifiedBy, a.IPAddress, a.VaccinationDetails,
	format(a.CreatedDate,Con.ConfigValue) as CreatedDate,
	format(a.ModifiedDate,Con.ConfigValue) as ModifiedDate
	FROM   Onboard_Application as a
	left join Masters_Country as CountryMst on CountryMst.CountryID=a.CountryID
	left join Masters_Region as RegionMst on RegionMst.RegionID=a.RegionID
	left join Masters_State as StateMst on StateMst.StateID=a.StateID
	left join Masters_City as CityMst on CityMst.CityID=a.CityID
	left join ConfigSetting as Con on ConfigKey='DateFormatC'
	where a.Isdeleted=0 and Approved=@Approved
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetOnboarding_View]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetOnboarding_View](@AppID int,@LoginID int)
as
begin
	SELECT ROW_NUMBER() OVER (Order By a.ModifiedDate desc) As RowNum, 
	AppID, DocNo, DocDate, Name, Gender, Mobile, EmailID, FatherName, format(DOB,'dd-MMM-yyyy')as DOB, BloodGroup, 
	MaritalStatus, PINCode, Token,
	a.CountryID,isnull(CountryMst.CountryName,'')as CountryName,
	a.RegionID,isnull(RegionMst.RegionName,'')as RegionName,
	a.StateID,isnull(StateMst.StateName,'')as StateName,
	a.CityID, isnull(CityMst.CityName,'')as CityName, Address,  PAN, AadharNo,
	UAN, ESIC,BankName,BankBranch, AccountNo, IFSCCode,
	NomineeName, format(NomineeDOB,'dd-MMM-yyyy')as NomineeDOB, NomineeRelation, 
	a.Remarks, a.VaccinationDetails,
	Approved, (case when Approved=1 then 'Approved' when Approved=2 then 'Resubmitted' else 'Pending' end)as ApprovedStatus,ApprovedRemarks, ApprovedDate, ApprovedBy, a.IsActive, a.IsActive_Reason, 
	a.IsActive_By, a.IsActive_Date, a.Priority, a.Isdeleted, a.DeletedBy, a.DeletedDate, a.CreatedBy,
	a.ModifiedBy, a.IPAddress,
	format(a.CreatedDate,Con.ConfigValue) as CreatedDate,
	format(a.ModifiedDate,Con.ConfigValue) as ModifiedDate
	FROM   Onboard_Application as a
	left join Masters_Country as CountryMst on CountryMst.CountryID=a.CountryID
	left join Masters_Region as RegionMst on RegionMst.RegionID=a.RegionID
	left join Masters_State as StateMst on StateMst.StateID=a.StateID
	left join Masters_City as CityMst on CityMst.CityID=a.CityID
	left join ConfigSetting as Con on ConfigKey='DateFormatC'
	where AppID=@AppID


	exec spu_GetOnboarding_Attachments @AppID
	
end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetRegion]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetRegion](@RegionID int, @LoginID int)
as
begin
	if @RegionID=0
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,a.RegionCode) As RowNum, 
			a.RegionID, a.CountryID, cu.CountryName, cu.CountryCode,a.RegionName,a.RegionCode,
			a.IsActive, a.Priority,
			format(a.CreatedDate,C.ConfigValue) as CreatedDate,
			format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
			FROM Masters_Region as a 
			inner join Masters_Country as cu on cu.CountryID=a.CountryID and cu.Isdeleted=0
			left join ConfigSetting as C on C.ConfigKey='DateFormatC'
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By a.Priority,a.RegionCode) As RowNum, 
			a.RegionID, a.CountryID, a.RegionName, a.RegionCode, a.IsActive, a.Priority
			FROM Masters_Region as a
			where a.RegionID=@RegionID

		end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetRoles]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetRoles](@RoleID int)
as
begin
	if @RoleID=0
		begin

			declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
			select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'


			SELECT ROW_NUMBER() OVER (Order By a.Priority,a.RoleName) As RowNum, 
			a.RoleID, a.RoleName, a.IsActive, a.Priority, a.description,
			format(a.CreatedDate,@DateFormatC) as CreatedDate,
			format(a.ModifiedDate,@DateFormatC) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy, a.IPAddress
			FROM  Login_Roles as a
			
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where Isdeleted=0
		end
	else
		begin
			SELECT ROW_NUMBER() OVER (Order By Priority,RoleName) As RowNum, 
			RoleID, RoleName, IsActive, Priority, description,
			CreatedBy, CreatedDate, ModifiedDate, ModifiedBy, IPAddress
			FROM  Login_Roles
			where RoleID=@RoleID
		end


end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetSessionExists]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetSessionExists](@SessionID varchar(2000),@LoginID int)
as
begin
	declare @RET_ID int=0,@Status bit=0,@Message varchar(500)='You are not allowed to login'

	if exists(select LoginID from Login_Users where Isdeleted=0 and SessionID=@SessionID and LoginID=@LoginID)
		begin
			set @RET_ID=@LoginID
			set @Status=1;
			set @Message='Availiable'
		end
	
	
	select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetState]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_GetState](@StateID int, @LoginID int)
as
begin
	if @StateID=0
		begin
			select ROW_NUMBER() OVER (Order By a.Priority,a.StateCode) As RowNum, 
			a.StateID, a.StateCode,a.StateName,a.Tin,  a.RegionID,MR.RegionCode,MR.RegionName,
			a.IsActive, a.Priority,
			format(a.CreatedDate,C.ConfigValue) as CreatedDate,
			format(a.ModifiedDate,C.ConfigValue) as ModifiedDate,
			isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy,a.IPAddress
			FROM Masters_State as a 
			inner join Masters_Region as MR on MR.RegionID=a.RegionID and MR.Isdeleted=0
			left join ConfigSetting as C on C.ConfigKey='DateFormatC'
			left outer join UserEMP_View Cby on Cby.LoginID=a.CreatedBy
			left outer join UserEMP_View Mby on Mby.LoginID=a.ModifiedBy
			where a.Isdeleted=0
		end
	else 
		begin	
			select ROW_NUMBER() OVER (Order By a.Priority,a.StateCode) As RowNum, 
			a.RegionID, a.StateID, a.StateCode,a.Tin, a.StateName, a.IsActive, a.Priority
			FROM Masters_State as a
			where a.StateID=@StateID

		end

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetTokenExists]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetTokenExists](@Token varchar(2000))
as
begin
	declare @RET_ID int=0,@Status bit=0,@Message varchar(500)='You are not allowed'

	if exists(select ConfigID from ConfigSetting where Isdeleted=0 and ConfigKey='Token' and ConfigValue=@Token)
		begin
			set @RET_ID=1
			set @Status=1;
			set @Message='Availiable'
		end
	
	
	select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_GetUser]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spu_GetUser]
(@LoginID AS INT)  
AS  
IF @LoginID=0   
	BEGIN  
		declare @DateFormatC varchar(50)='dd-MMM-yy hh:mm:ss tt'
		select @DateFormatC =ISNULL(ConfigValue,@DateFormatC) from ConfigSetting where ConfigKey='DateFormatC'

		SELECT  ROW_NUMBER() OVER (Order By U.Priority,Name) As RowNum,
		R.rolename, U.LoginID as ID, U.UserID, U.Name, U.Password,U.Phone,U.Email,
		u.roleid ,u.isdeleted,u.IsActive,
		format(u.CreatedDate,@DateFormatC) as CreatedDate,
		format(u.ModifiedDate,@DateFormatC) as ModifiedDate,
		isnull(Cby.EMPName,'')as CreatedBy,isnull(Mby.EMPName,'')as ModifiedBy, u.IPAddress
		FROM         Login_Users as U
		INNER JOIN
		Login_Roles as R ON U.roleid = R.RoleID and R.isdeleted=0
		
		left outer join UserEMP_View Cby on Cby.LoginID=U.CreatedBy
		left outer join UserEMP_View Mby on Mby.LoginID=U.ModifiedBy
		WHERE u.isdeleted=0		
 END  
ELSE  
 BEGIN  
		SELECT  ROW_NUMBER() OVER (Order By U.Priority,Name) As RowNum,
		R.rolename, U.LoginID as ID, U.UserID, U.Name, U.Password,U.Phone,U.Email,
		U.createdby, U.modifiedby,  u.CreatedDate, u.ModifiedDate, 
		u.roleid ,u.isdeleted,u.IsActive,u.IPAddress
		FROM         Login_Users as U
		INNER JOIN
		Login_Roles as R ON U.roleid = R.RoleID and R.isdeleted=0
		WHERE U.LoginID=@LoginID
    
 END
GO
/****** Object:  StoredProcedure [dbo].[spu_GetUserProfile]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_GetUserProfile](@LoginID int)
	as
	begin
		
		SELECT   LoginID, UserID, RoleID, RoleName, EMPID, EMPCode, EMPName, Gender, DesignName, DeptName, 
		AttachID, ImageURL, Phone, EmailID, FatherName, PAN, PaymentMode, UAN, ESIC, DOJ, DOB
		FROM   UserEMP_View
		where LoginID=@LoginID

		---- Bank Details
		--select B.BankID, B.Doctype, B.EMPID, EMPCode, EMPName,BankName, AccountNo, IFSCCode,
		-- BranchName
		--from Master_Bank as B
		--inner join UserEMP_View as E on E.EMPID=B.EMPID 
		--where B.Isdeleted=0 and b.IsActive=1 and E.LoginID=@LoginID and E.EMPID!=0

		---- Address Details
		--select  AddressID, Doctype,
		--a.CountryID, a.StateID, a.CityID, 
		--isnull(mstcountry.Name,'')as Country,isnull(mstState.Name,'')as State,isnull(mstcity.Name,'')as City,
		--a.Address1, a.Address2, a.Location, a.Phone, a.Zipcode
		--from Master_Address as a
		--inner join UserEMP_View as E on E.EMPID=a.TableID and a.TableName='EMP' 
		--left outer join Masters as mstcountry on mstcountry.MasterID=a.CountryID
		--left outer join Masters as mstState on mstState.MasterID=a.StateID
		--left outer join Masters as mstcity on mstcountry.MasterID=a.CityID
		--where a.Isdeleted=0 and a.IsActive=1 and E.LoginID=@LoginID and E.EMPID!=0

	end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetBilling_Staff]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetBilling_Staff](
@BillID int,
@DocNo_Series int,
@Month int,
@year Int,
@EMPCount int,
@SC_Code varchar(500),
@HSNCode varchar(500),
@DealerType varchar(500),
@Department varchar(500),
@Designation varchar(500),
@StateCode varchar(500),
@Description varchar(max), 
@Gross_Amt decimal(18,2), 
@AgencyPer decimal(18,2), 
@AgencyCommission decimal(18,2), 
@IGST decimal(18,2),
@IGST_Amt decimal(18,2), 
@CGST decimal(18,2), 
@CGST_Amt decimal(18,2), 
@SGST decimal(18,2), 
@SGST_Amt decimal(18,2), 
@Total_Amt decimal(18,2), 
@createdby int,
@IPAddress varchar(50),
@StaffList BillingStaff_Type readonly
)
as
begin
declare @RET_ID int=0,@Status int=0,@Message varchar(500)='',@BillingDocNo varchar(500)='',@DocNo varchar(500)=''
declare @FinYearID int=0,@ClientCode varchar(500)='', @ClientName varchar(500)='',@SC_Name varchar(500)='',@SC_GSTNo varchar(500)='',@SC_PANNo varchar(500)='',
@SC_CountryName varchar(500)='',@SC_CountryCode varchar(50)='',
@SC_StateName varchar(500)='',@SC_StateCode varchar(500)='',@SC_StateTIN varchar(500)='',@SC_ZipCode varchar(500)='',@SC_Address varchar(max)='',@SC_Phone varchar(max)='',@SC_Email varchar(max)='';

BEGIN TRY		
		if exists(select BillID from Billing where Isdeleted=0 and (right(left(DocNo, 9),6))=format(@DocNo_Series,'000000') and BillID!=@BillID)
		throw 51000,'Doc No already exists',1

		select @FinYearID= dbo.fn_GetFinancialYearID(getdate())

		select @SC_Name=MC.Name, 
		@ClientName=CL.ClientName,@ClientCode=CL.ClientCode,
		@SC_CountryName=C.CountryName,@SC_CountryCode=C.CountryCode,
		@SC_StateName= MS.StateName,@SC_StateCode=MS.StateCode, @SC_StateTIN=MS.TIN, @SC_ZipCode=MC.ZipCode,@SC_Address=MC.Address,
		@SC_GSTNo=MC.GSTNo,@SC_PANNo=MC.PAN
		from Master_Clients_Tran as MC
		inner join Master_Clients as CL on CL.Isdeleted=0 and CL.ClientID=MC.ClientID and CL.Isdeleted=0
		inner join Masters_State as MS on MS.StateID=MC.StateID and MS.Isdeleted=0
		inner join Masters_Country as C on C.CountryID=MC.CountryID and C.Isdeleted=0
		where MC.Code=@SC_Code and MC.Isdeleted=0

		if @BillID=0
			begin
				
				select @RET_ID=Isnull(BillID,0) from AllMaxID
				set @RET_ID+=1;

				select @BillingDocNo= ConfigValue from ConfigSetting where ConfigKey='BillingDocNo'
				set @DocNo=format(@DocNo_Series,'000000')
				set @DocNo=REPLACE(@BillingDocNo, '#', @DocNo)

				insert into Billing(BillID,DocNo,  FYID, Month, Year,EMPCount,DealerType,Department,Designation, StateName,
				ClientCode, ClientName, 
				SC_Code, SC_Name, SC_GSTNo, SC_PANNo, SC_CountryName,SC_CountryCode, 
				SC_StateName,SC_StateCode,SC_StateTIN,  SC_ZipCode, SC_Address, SC_Phone, SC_Email, 
				Description, AgencyPer, AgencyCommission, Gross_Amt, HSNCode, IGST, IGST_Amt, CGST, CGST_Amt, SGST, SGST_Amt, Total_Amt, 
				CreatedBy,ModifiedBy,IPAddress)
				values
				(@RET_ID,@DocNo,@FinYearID, @Month, @year,@EMPCount,@DealerType,@Department,@Designation,@StateCode,
				@ClientCode, @ClientName, 
				@SC_Code, @SC_Name, @SC_GSTNo, @SC_PANNo, @SC_CountryName,@SC_CountryCode,
				@SC_StateName, @SC_StateCode,@SC_StateTIN,@SC_ZipCode, @SC_Address, @SC_Phone, @SC_Email, 
				@Description, @AgencyPer, @AgencyCommission, @Gross_Amt, @HSNCode, @IGST, @IGST_Amt, @CGST, @CGST_Amt, @SGST, @SGST_Amt, @Total_Amt,@createdby,@createdby,@IPAddress
				)

				update AllMaxID set BillID=@RET_ID

				
			end
		else
			begin
				update Billing set DocDate=GETDATE(),
				StateName=@StateCode,
				FYID=@FinYearID, Month=@Month, Year=@year,EMPCount=@EMPCount,DealerType=@DealerType,Department=@Department,Designation=@Designation,
				ClientCode=@ClientCode, ClientName=@ClientName,SC_Code=@SC_Code,SC_Name=@SC_Name,SC_GSTNo= @SC_GSTNo,SC_PANNo= @SC_PANNo,SC_CountryName= @SC_CountryName,
				SC_CountryCode=@SC_CountryCode,SC_StateName=@SC_StateName, SC_StateCode=@SC_StateCode,SC_StateTIN=@SC_StateTIN,SC_ZipCode=@SC_ZipCode,SC_Address= @SC_Address,
				SC_Phone=@SC_Phone,SC_Email=@SC_Email, Description=@Description,AgencyPer= @AgencyPer,AgencyCommission= @AgencyCommission,Gross_Amt= @Gross_Amt,HSNCode= @HSNCode,IGST= @IGST,
				IGST_Amt= @IGST_Amt,CGST= @CGST,CGST_Amt= @CGST_Amt,SGST= @SGST,SGST_Amt= @SGST_Amt,Total_Amt= @Total_Amt,
				ModifiedBy= @createdby,ModifiedDate=GETDATE(),
				IPAddress=@IPAddress
				where BillID=@BillID

				set @RET_ID=@BillID
			end

		if exists(select Top 1 * from @StaffList) and @RET_ID>0
			begin
				insert into Billing_Tran(BillingTranID, BillID, EMPName, EMPCode,DealerName,DealerType, Gender, Department, Designation, State,Location, 
				PayDays, NetPay, Incentive, NetGross, CTC, Tran_AgencyPer, Tran_AgencyCommission, Total, CreatedBy, ModifiedBy, IPAddress)
					
				(select Next value for dbo.seq_Billing_Tran,@RET_ID,EMPName, EMPCode,isnull(DealerName,''),isnull(DealerType,''),Gender, Department, Designation, State, Location,
				PayDays, NetPay, Incentive, NetGross, CTC, Tran_AgencyPer, Tran_AgencyCommission, Total,@createdby,@createdby,@IPAddress
				from @StaffList )

			end
		set @Status=1
		set @Message='Inserted Successfully'
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetChangePassword]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spu_SetChangePassword](
@LoginID int,
@Doctype varchar(50),
@NewPassword varchar(100),
@OldPassword varchar(100),
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500);

BEGIN TRY	
		if @Doctype='ByLink'
			begin
				update Login_Users set
				Password=@NewPassword,
				ModifiedBy= @LoginID,ModifiedDate=GETDATE(),
				IPAddress=@IPAddress
				where LoginID=@LoginID

				set @RET_ID=@LoginID
				set @Status=1
				set @Message='Password Updated Successfully'
			end
		else
			begin
				if not  exists(select LoginID from Login_Users where Isdeleted=0 and Password=@OldPassword and  LoginID=@LoginID)
				throw 51000,'Old Password not matched',0
		
				update Login_Users set
				Password=@NewPassword,IsFirstLogin=0,
				ModifiedBy= @LoginID,ModifiedDate=GETDATE(),
				IPAddress=@IPAddress
				where LoginID=@LoginID

				set @RET_ID=@LoginID
				set @Status=1
				set @Message='Password Updated Successfully'
			end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetCity]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetCity](
@CityID int,
@CityName varchar(500),
@CityCode varchar(2000),
@StateID int,
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select CityID from Masters_City where Isdeleted=0 and CityID !=@CityID and CityCode=@CityCode)
	throw 51000,'Code already exists',1

	if @CityID=0
		begin
			select @RET_ID=Isnull(Max(CityID),0) from Masters_City
			set @RET_ID=@RET_ID+1;
			insert into Masters_City(CityID,CityName,CityCode,StateID, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(@RET_ID,@CityName, @CityCode,@StateID, @Priority,@createdby,@createdby,@IPAddress)

			
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Masters_City set
			CityName=@CityName,CityCode=@CityCode,StateID=@StateID,
			Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where CityID=@CityID

			set @RET_ID=@CityID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetCountry]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[spu_SetCountry](
@CountryID int,
@CountryName varchar(500),
@CountryCode varchar(2000),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select CountryID from Masters_Country where Isdeleted=0 and CountryID !=@CountryID and CountryCode=@CountryCode)
	throw 51000,'Code already exists',1

	if @CountryID=0
		begin
			insert into Masters_Country(CountryID, CountryCode,CountryName, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Masters_Country,@CountryCode, @CountryName, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Masters_Country'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Masters_Country set
			CountryCode=@CountryCode,
			CountryName=@CountryName,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where CountryID=@CountryID

			set @RET_ID=@CountryID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetDealerType]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetDealerType](
@DealerTypeID int,
@Name varchar(500),
@Code varchar(2000),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select DealerTypeID from  Master_Dealer_Type where Isdeleted=0 and DealerTypeID !=@DealerTypeID  and Code=@Code)
	throw 51000,'Code already exists',1

	if @DealerTypeID=0
		begin
			select @RET_ID=isnull(Max(DealerTypeID),0) from Master_Dealer_Type
			set @RET_ID=@RET_ID+1

			insert into  Master_Dealer_Type(DealerTypeID, Name, Code,Priority,CreatedBy,ModifiedBy,IPAddress)
			values(@RET_ID,@Name, @Code, @Priority,@createdby,@createdby,@IPAddress)
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Dealer_Type set
			Name=@Name,Code=@Code,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where DealerTypeID=@DealerTypeID

			set @RET_ID=@DealerTypeID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetDepartment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetDepartment](
@DeptID int,
@DeptCode varchar(500),
@DeptName varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select DeptID from Master_Department where Isdeleted=0 and DeptID!=@DeptID and DeptName=@DeptName)
	throw 51000,'Record already exists',1

	if @DeptID=0
		begin
			insert into Master_Department(DeptID, DeptCode, DeptName, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Department,@DeptCode,@DeptName, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Department'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Department set
			DeptCode=@DeptCode,DeptName=@DeptName,Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where DeptID=@DeptID

			set @RET_ID=@DeptID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetDesignation]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetDesignation](
@DesignID int,
@DesignCode varchar(500),
@DesignName varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select DesignID from Master_Designation where Isdeleted=0 and DesignID!=@DesignID and DesignName=@DesignName)
	throw 51000,'Record already exists',1

	if @DesignID=0
		begin
			insert into Master_Designation(DesignID, DesignCode, DesignName, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Designation,@DesignCode,@DesignName, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Designation'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Designation set
			DesignCode=@DesignCode,DesignName=@DesignName,Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where DesignID=@DesignID

			set @RET_ID=@DesignID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetEmailTemplate]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetEmailTemplate]
(@TemplateID bigint,
@TemplateName nvarchar(1000), 
@Body nvarchar(max),
@Subject nvarchar(1000),
@CCMail nvarchar(500),
@BCCMail nvarchar(500),
@SMSBody nvarchar(1000),
@Repository nvarchar(max),
@createdby int, 
@IPAddress nvarchar(50)
)
as begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
 BEGIN TRY 
	
	if exists(select TemplateID from EmailTemplate where Isdeleted=0 and TemplateID!=@TemplateID and TemplateName=@TemplateName)
	throw 51000,'Record already exists',1


	if @TemplateID=0
	begin
			select @TemplateID=Isnull(TemplateID,0) from EmailTemplate
			set @TemplateID+=1;
				
			insert into EmailTemplate(TemplateID, TemplateName,SMSBody, Body, Subject, CCMail, BCCMail,Repository, createdby, modifiedby,IPAddress)
			values (@TemplateID,@TemplateName,@SMSBody,@Body,@Subject,@CCMail,@BCCMail,@Repository, @createdby,@createdby,@IPAddress)

			select @RET_ID =@TemplateID
			set @Status=1
			set @Message='Inserted Successfully'		
	end 
else 
	begin
			update EmailTemplate set  TemplateName=@TemplateName, Body=@Body,Repository=@Repository,
			Subject=@Subject, CCMail=@CCMail, BCCMail=@BCCMail,SMSBody=@SMSBody,
			modifiedby=@createdby,ModifiedDate=getdate(),
			IPAddress=@IPAddress where TemplateID=@TemplateID

			set @RET_ID=@TemplateID
			set @Status=1
			set @Message='Update Successfully'			
	end
END TRY 
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetErrorLog]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [dbo].[spu_SetErrorLog]  
(   
 @ErrDescription varchar(max),  
 @SystemException varchar(max),  
 @ActiveFunction nvarchar(500),  
 @ActiveForm nvarchar(500),  
 @ActiveModule   nvarchar(500),  
 @CreatedBy  int,  
 @IPAddress nvarchar(100)  
   
)  
AS   
BEGIN        
 declare @RET_ID int=0,@Status int,@Message varchar(500)  
  
BEGIN TRY   
       
   INSERT INTO  Error_Log (ErrDescription, SystemException, ActiveFunction,ActiveModule, ActiveForm, CreatedBy, IPAddress)  
   Values (@ErrDescription, @SystemException, @ActiveFunction,@ActiveModule, @ActiveForm, @CreatedBy, @IPAddress)  
  
   set @RET_ID= scope_identity();  
   set @Status=1  
   set @Message= 'Inserted Successfully'  
END TRY  
BEGIN CATCH  
   set @Status=-1  
   set @Message= ERROR_MESSAGE()  
END CATCH  
  
select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]  
     
END;
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_Attachments]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spu_SetHelpdesk_Attachments]
	(
		@id AS int,		
		@filename As varchar(255),
		@contenttype AS varchar(255),
		@Description as Varchar(255),
		@TempID varchar(2000),
		@TicketID as bigint,
		@NotesID as bigint,
		@createdby int,
		@IPAddress Varchar(255)
	)
	AS 
	begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
	BEGIN TRY 
		
		IF @ID=0
			BEGIN     
				select @RET_ID=Isnull(Max(Attach_ID),0) from Helpdesk_Ticket_Attachments
				set @RET_ID+=1;

				INSERT INTO Helpdesk_Ticket_Attachments (Attach_ID,[filename],TempID,TicketID,NotesID, contenttype,Description,createdby,IPAddress)
				Values (Next value for dbo.seq_master_attachment,@filename,@TempID,@TicketID,@NotesID,@contenttype,@Description,@createdby,@IPAddress)				

				SET @Status =1
				SET @Message = 'Added Successfully'	
			
				
			END        
		Else            
			BEGIN 
				UPDATE Helpdesk_Ticket_Attachments SET [filename]=@filename,TicketID=@TicketID,contenttype=@contenttype,Description=@Description  ,TempID=@TempID,
				NotesID=@NotesID,ModifiedBy=@createdby,ModifiedDate=getdate(),IPAddress=@IPAddress
				WHERE Attach_ID=@id
				SET @RET_ID = @id			
				
				SET @Status =1
				SET @Message = 'Update Successfully'			
			END    	
	END TRY 
	BEGIN CATCH
		SET @Status =-1
		SET @Message = ERROR_MESSAGE()
	END CATCH 

	select @RET_ID as RET_ID,@Status as STATUS,@Message as [MESSAGE]
	END;
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_Category]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetHelpdesk_Category](
@CategoryID int,
@CategoryName varchar(500),
@CategoryDesc varchar(max),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select CategoryID from HelpDesk_Category where Isdeleted=0 and CategoryID!=@CategoryID and CategoryName =@CategoryName )
	throw 51000,'Category already exists',1

	if @CategoryID=0
		begin
			select @CategoryID=Isnull(Max(CategoryID),0) from HelpDesk_Category
			set @CategoryID+=1;

			insert into HelpDesk_Category(CategoryID, CategoryName, CategoryDesc, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(@CategoryID,@CategoryName,@CategoryDesc, @Priority,@createdby,@createdby,@IPAddress)

			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update HelpDesk_Category set
			CategoryName=@CategoryName,CategoryDesc=@CategoryDesc,Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where CategoryID=@CategoryID

			set @RET_ID=@CategoryID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_Status]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetHelpdesk_Status](
@StatusID int,
@StatusName varchar(500),
@DisplayName varchar(500),
@Icon varchar(500),
@Color varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select StatusID from Helpdesk_Status where Isdeleted=0 and StatusID!=@StatusID and StatusName =@StatusName )
	throw 51000,'Status already exists',1

	if @StatusID=0
		begin
			select @StatusID=Isnull(Max(StatusID),0) from Helpdesk_Status
			set @StatusID+=1;

			insert into Helpdesk_Status(StatusID ,StatusName,DisplayName, Icon, Color, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(@StatusID,@StatusName,@DisplayName, @Icon, @Color, @Priority,@createdby,@createdby,@IPAddress)

			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Helpdesk_Status set
			StatusName=@StatusName,DisplayName=@DisplayName,Icon= @Icon,Color=@Color,Priority=@Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where StatusID=@StatusID

			set @RET_ID=@StatusID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_SubCategory]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetHelpdesk_SubCategory](
@SubCategoryID int,
@CategoryID int,
@SubName varchar(500),
@SubDesc varchar(Max),
@LoginIDs varchar(Max),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select SubCategoryID from HelpDesk_SubCategory where Isdeleted=0 and SubCategoryID!=@SubCategoryID and SubName  =@SubName  )
	throw 51000,'Sub Category already exists',1

	if @SubCategoryID=0
		begin
			select @SubCategoryID=Isnull(Max(SubCategoryID),0) from HelpDesk_SubCategory
			set @SubCategoryID+=1;

			insert into HelpDesk_SubCategory(SubCategoryID,CategoryID, SubName, SubDesc, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(@SubCategoryID,@CategoryID,@SubName,@SubDesc, @Priority,@createdby,@createdby,@IPAddress)

			set @RET_ID=@SubCategoryID
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update HelpDesk_SubCategory set
			CategoryID=@CategoryID,SubName=@SubName,SubDesc=@SubDesc,
			Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where SubCategoryID=@SubCategoryID

			set @RET_ID=@SubCategoryID
			set @Status=1
			set @Message='Update Successfully'

		end
	if @RET_ID>0 and @LoginIDs!=''
			 
			update Helpdesk_SubCategory_Users set Isdeleted=1 where SubCategoryID=@RET_ID 

			begin
				DECLARE @loginID int,@ID int=0
				DECLARE Cursor_SBLogin CURSOR
				FOR SELECT * from dbo.splitstring(@LoginIDs) 
				OPEN Cursor_SBLogin;
				FETCH NEXT FROM Cursor_SBLogin INTO @loginID
				WHILE @@FETCH_STATUS = 0
					BEGIN
						select @ID=isnull(ID,0) from Helpdesk_SubCategory_Users where SubCategoryID=@RET_ID and LoginID=@loginID and Isdeleted=0
	
						if @ID=0
							begin
								insert into Helpdesk_SubCategory_Users( SubCategoryID, LoginID,CreatedBy,ModifiedBy,IPAddress)
								values(@RET_ID, @loginID,@createdby,@createdby,@IPAddress)
							end
						else
							begin
								update Helpdesk_SubCategory_Users set SubCategoryID=@RET_ID,LoginID=@loginID,Isdeleted=0,ModifiedDate=getdate(),ModifiedBy=@createdby,IPAddress=@IPAddress
								where ID=@ID
							end
						FETCH NEXT FROM Cursor_SBLogin INTO  @loginID
					END;
				CLOSE Cursor_SBLogin;
				DEALLOCATE Cursor_SBLogin;
			end
END TRY
BEGIN CATCH
			CLOSE Cursor_SBLogin;
			DEALLOCATE Cursor_SBLogin;
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_Ticket]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetHelpdesk_Ticket](
@CategoryID int,
@SubCategoryID int,
@Subject varchar(2000),
@Messageinfo  varchar(max),
@TicketPriority varchar(50),
@OptionalUsers varchar(max),
@TempID varchar(2000),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
declare @TicketID int,@TicketNo varchar(50),@CurrentStatusID int=1

BEGIN TRY		
		declare @TicketAssignee table(LoginID int,Doctype varchar(50))
		insert into @TicketAssignee (LoginID,Doctype)
		select LoginID,'Primary' from Helpdesk_SubCategory_Users where Isdeleted=0 and SubCategoryID=@SubCategoryID
		
		if @OptionalUsers !=''
			begin
				insert into @TicketAssignee (LoginID,Doctype)
				select Name,'Optional' from dbo.splitstring(@OptionalUsers) where Name not in (select LoginID from @TicketAssignee)
			end
		if not exists(select * from @TicketAssignee where LoginID=@createdby)
			begin
				insert into @TicketAssignee (LoginID,Doctype)
				select @createdby ,'Owner'
			end

		if exists(select * from @TicketAssignee)
			begin
				select @TicketID=Isnull(Ticket_ID,0) from AllMaxID
				set @TicketID+=1;
				set @TicketNo='TKT-'+format(@TicketID,'000000')

				insert into Helpdesk_Ticket(TicketID,TicketNo,CurrentStatusID, CategoryID,SubCategoryID,Subject,Message, TicketPriority, CreatedBy,ModifiedBy,IPAddress)
				values(@TicketID,@TicketNo,@CurrentStatusID,@CategoryID,@SubCategoryID,@Subject,@Messageinfo, @TicketPriority,@createdby,@createdby,@IPAddress)

				update AllMaxID set Ticket_ID=@TicketID

			
				insert into Helpdesk_Ticket_Assignee (LoginID,Doctype,TicketID,CreatedBy,ModifiedBy,IPAddress)
				select LoginID,Doctype,@TicketID,@createdby,@createdby,@IPAddress from @TicketAssignee
				
				set @Status=1
				set @Message='Inserted Successfully'

				if(@TicketID>0)
					begin
						--exec spu_CreateMail_Helpdesk_Ticket @TicketID

						if @TempID!=''
							begin
								update Helpdesk_Ticket_Attachments set TicketID=@TicketID,TempID='' 
								where Isdeleted=0 and TicketID=0 and NotesID=0 and TempID=@TempID
							end
					end
				
				
			end 
		else
			begin
				set @Status=0
				set @Message='No Assignee Availiable in this Sub Category'
			end
	
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetHelpdesk_Ticket_Notes]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetHelpdesk_Ticket_Notes](
@TicketID int,
@StatusID int,
@NextDate datetime,
@Notes  varchar(max),
@UserID int,
@TempID varchar(2000),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY		
		select @RET_ID=Isnull(Ticket_NotesID,0) from AllMaxID
		set @RET_ID+=1;
		
		insert into Helpdesk_Ticket_Notes(NotesID,TicketID,StatusID,NextDate,Notes, CreatedBy,ModifiedBy,IPAddress)
		values(@RET_ID,@TicketID,@StatusID,@NextDate,@Notes,@createdby,@createdby,@IPAddress)

		update AllMaxID set Ticket_NotesID=@RET_ID

		update Helpdesk_Ticket set Latest_Notes=@Notes,Latest_NextDate=@NextDate,CurrentStatusID=@StatusID,
		ModifiedBy=@createdby,ModifiedDate=getdate(),IPAddress=@IPAddress
		where TicketID=@TicketID

		if @StatusID=3 and not exists(select * from Helpdesk_Ticket_Assignee where Isdeleted=0 and TicketID=@TicketID and LoginID=@UserID)
			begin
				insert into Helpdesk_Ticket_Assignee (LoginID,TicketID,CreatedBy,ModifiedBy,IPAddress)
				values (@UserID, @TicketID,@createdby,@createdby,@IPAddress)
			end

		if @StatusID=3  and not exists(select * from Helpdesk_Ticket_Deferred where Isdeleted=0 and TicketID=@TicketID and LoginID=@createdby)
			begin
				insert into Helpdesk_Ticket_Deferred (LoginID,TicketID,CreatedBy,ModifiedBy,IPAddress)
				values (@createdby, @TicketID,@createdby,@createdby,@IPAddress)
			end

		if @RET_ID>0 and @TempID!=''
				begin
					update Helpdesk_Ticket_Attachments set NotesID=@RET_ID,TempID='' 
					where Isdeleted=0 and TicketID=@TicketID and NotesID=0 and TempID=@TempID
				end
		set @Status=1
		set @Message='Inserted Successfully'
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetLead]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetLead](
@LeadID int,
@LeadType varchar(500),
@CompanyName varchar(500),
@CompanyBusiness varchar(500),
@StateID int,
@CityID int,
@PinCode varchar(50),
@CompanyType varchar(50),
@CompanyPayroll varchar(50),
@RequirementType varchar(50),
@Latitude varchar(500),
@Longitude varchar(500),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
declare @TicketNo varchar(50),@StatusID int=1

BEGIN TRY		
		
		select @RET_ID=Isnull(max(LeadID),0) from Lead
		set @RET_ID+=1;
		set @TicketNo='LD-'+format(@RET_ID,'000000')

		insert into Lead(LeadID, TicketNo, StatusID, LeadType, CompanyName, CompanyBusiness, StateID, CityID, 
		PinCode, CompanyType, CompanyPayroll, RequirementType,Latitude,Longitude,CreatedBy,ModifiedBy,IPAddress)
		values(@RET_ID,@TicketNo,@StatusID,@LeadType, @CompanyName, @CompanyBusiness, @StateID, @CityID, @PinCode, 
		@CompanyType, @CompanyPayroll, @RequirementType,@Latitude,@Longitude,@createdby,@createdby,@IPAddress)

		set @Status=1
		set @Message='Inserted Successfully'
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetLead_Contacts]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetLead_Contacts](
@ContactID int,
@LeadID int,
@Name varchar(500),
@Phone varchar(500),
@EmailID varchar(500),
@Designation  varchar(500),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	
	if @ContactID=0
		begin
			select @RET_ID=Isnull(max(ContactID),0) from Lead_Contacts
			set @RET_ID+=1;
			
			insert into Lead_Contacts(ContactID, LeadID, Name, Phone, EmailID, Designation,CreatedBy,ModifiedBy,IPAddress)
			values(@RET_ID, @LeadID, @Name, @Phone, @EmailID, @Designation,@createdby,@createdby,@IPAddress)

			set @Status=1
			set @Message='Inserted Successfully'
		end
	else
		begin
			update Lead_Contacts set 
			LeadID=@LeadID, Name=@Name, Phone=@Phone,EmailID=@EmailID,Designation=@Designation,
			ModifiedBy=@createdby,CreatedBy=@createdby,ModifiedDate=getdate(), IPAddress=@IPAddress
			where ContactID=@ContactID

			set @RET_ID=@ContactID
			set @Status=1;
			set @Message= 'Updated Successfully'
		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetLead_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetLead_Tran](
@LeadID int,
@StatusID int,
@NextDate datetime,
@Notes  varchar(max),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY		
		select @RET_ID=Isnull(max(LeadTranID),0) from Lead_Tran
		set @RET_ID+=1;
		
		insert into Lead_Tran( LeadTranID, LeadID, StatusID, NextDate, Notes, CreatedBy,ModifiedBy,IPAddress)
		values(@RET_ID,@LeadID,@StatusID,@NextDate,@Notes,@createdby,@createdby,@IPAddress)

		
		update Lead set Tran_Notes=@Notes,Tran_NextDate=@NextDate,StatusID=@StatusID,
		ModifiedBy=@createdby,ModifiedDate=getdate(),IPAddress=@IPAddress
		where LeadID=@LeadID

		set @Status=1
		set @Message='Inserted Successfully'
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMaster_Address]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spu_SetMaster_Address](
@AddressID int,
@Doctype varchar(500),
@TableID int,
@TableName varchar(500),
@CountryID int,
@StateID int,
@CityID int,
@Address1 varchar(max),
@Address2 varchar(max),
@Location varchar(500),
@Phone varchar(500),
@Zipcode varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	
	
	if exists(select AddressID from Master_Address where Isdeleted=0 and Doctype=@Doctype and TableID=@TableID and TableName=@TableName)
		begin
			select @AddressID=AddressID from Master_Address where Isdeleted=0 and Doctype=@Doctype and TableID=@TableID and TableName=@TableName
		end

	if @AddressID=0
		begin
			insert into Master_Address(AddressID, 
			Doctype, CountryID, StateID, CityID, Address1, Address2,Priority,Location,Phone,Zipcode,TableID,TableName,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Address,
			 @Doctype, @CountryID, @StateID, @CityID, @Address1, @Address2, @Priority,@Location,@Phone,@Zipcode,@TableID,@TableName,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Address'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Address set
			Doctype=@Doctype, CountryID=@CountryID, StateID=@StateID, CityID=@CityID,
			 Address1=@Address1, Address2=@Address2,
			Location= @Location,Phone=@Phone,Zipcode=@Zipcode,TableID=@TableID,TableName=@TableName,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where AddressID=@AddressID

			set @RET_ID=@AddressID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMaster_Bank]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetMaster_Bank](
@BankID int,
@Doctype varchar(500),
@TableID int,
@TableName varchar(500),
@BankName varchar(500),
@AccountNo varchar(500),
@IFSCCode varchar(500),
@BranchName varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	
	if exists(select BankID from Master_Bank where Isdeleted=0 and Doctype=@Doctype and TableID=@TableID and TableName=@TableName)
		begin
			select @BankID=BankID from Master_Bank where Isdeleted=0 and Doctype=@Doctype and TableID=@TableID and TableName=@TableName
		end

	

	if @BankID=0
		begin
			insert into Master_Bank(BankID, 
			Doctype, TableID,TableName, BankName, AccountNo, IFSCCode, BranchName,Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Bank,
			@Doctype, @TableID,@TableName, @BankName, @AccountNo, @IFSCCode, @BranchName, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Bank'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Bank set
			Doctype=@Doctype,TableID= @TableID,TableName=@TableName, BankName=@BankName, AccountNo=@AccountNo, 
			IFSCCode=@IFSCCode, BranchName=@BranchName,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where BankID=@BankID

			set @RET_ID=@BankID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMaster_Clients]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetMaster_Clients](
@ClientID int,
@ClientCode varchar(500),
@ClientName varchar(500),
@DisplayName varchar(500),
@OtherCode varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select ClientID from Master_Clients where Isdeleted=0 and ClientID!=@ClientID and ClientCode=@ClientCode)
	throw 51000,'Record already exists',1

	if @ClientID=0
		begin
			insert into Master_Clients(ClientID, ClientCode, ClientName, DisplayName, OtherCode,  Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Clients,@ClientCode,@ClientName,@DisplayName,@OtherCode, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Clients'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Clients set
			ClientCode=@ClientCode,ClientName=@ClientName,DisplayName=@DisplayName,OtherCode=@OtherCode,
			Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where ClientID=@ClientID

			set @RET_ID=@ClientID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMaster_ClientsTran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetMaster_ClientsTran](
@ClientTranID int,
@ClientID int,
@Code varchar(500),
@Name varchar(500),
@PrintName varchar(500),
@PAN varchar(500),
@GSTno varchar(500),
@Commission float,
@CountryID int,
@StateID int,
@Address varchar(max),
@ZipCode varchar(500),
@Phone varchar(500),
@EmailID varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select ClientTranID from Master_Clients_Tran where Isdeleted=0 and ClientTranID!=@ClientTranID and ClientID=@ClientID and Code=@Code)
	throw 51000,'Record already exists',1

	if @ClientTranID=0
		begin
			insert into Master_Clients_Tran(ClientTranID, ClientID, Code, Name, PrintName, GSTNo,PAN, Commission,CountryID,StateID,Address,ZipCode,Phone, EmailID,Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Master_Clients_Tran,@ClientID,@Code,@Name,@PrintName,@GSTNO, @PAN,@Commission,@CountryID,@StateID,@Address,@ZipCode,@Phone, @EmailID,@Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Master_Clients_Tran'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Master_Clients_Tran set
			ClientID=@ClientID,CountryID=@CountryID,StateID=@StateID,Address=@Address,ZipCode=@ZipCode,Phone=@Phone,
			Code=@Code,Name=@Name,PrintName=@PrintName,PAN=@PAN,Commission=@Commission,GSTNO=@GSTNO,
			Priority= @Priority,
			ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where ClientTranID=@ClientTranID

			set @RET_ID=@ClientTranID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMasterAttachment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spu_SetMasterAttachment]
	(
		@id AS int,		
		@filename As varchar(255),
		@contenttype AS varchar(255),
		@Description as Varchar(255),
		@tableid as bigint,
		@TableName as Varchar(255),
		@createdby int,
		@IPAddress Varchar(255)
	)
	AS 
	begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
	BEGIN TRY 
		
		IF @ID=0
			BEGIN     
				
				INSERT INTO master_attachment (Attach_ID,[filename],TableID, contenttype,Description,TableName,createdby,IPAddress)
				Values (Next value for dbo.seq_master_attachment,@filename,@tableid,@contenttype,@Description,@TableName,@createdby,@IPAddress)				

				select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_master_attachment'
				SET @Status =1
				SET @Message = 'Added Successfully'	
			
				
			END        
		Else            
			BEGIN 
				UPDATE master_attachment SET [filename]=@filename,TableID=@tableid,contenttype=@contenttype,Description=@Description  ,
				TableName=@TableName,ModifiedBy=@createdby,ModifiedDate=getdate(),IPAddress=@IPAddress
				WHERE Attach_ID=@id
				SET @RET_ID = @id			
				
				SET @Status =1
				SET @Message = 'Update Successfully'			
			END    	
	END TRY 
	BEGIN CATCH
		SET @Status =-1
		SET @Message = ERROR_MESSAGE()
	END CATCH 

	select @RET_ID as RET_ID,@Status as STATUS,@Message as [MESSAGE]
	END;

GO
/****** Object:  StoredProcedure [dbo].[spu_SetMasters]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[spu_SetMasters](
@MasterID int,
@TableName varchar(500),
@Name varchar(2000),
@GroupID int,
@Value varchar(2000),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select MasterID from Masters where Isdeleted=0 and MasterID !=@MasterID and TableName=@TableName and Value=@Value)
	throw 51000,'Code already exists',1

	if @MasterID=0
		begin
			insert into masters(MasterID, TableName, Name, Value, GroupID, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Masters,@TableName, @Name, @Value,@GroupID, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Masters'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update masters set
			GroupID=@GroupID,
			Name=@Name,Value=@Value,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where MasterID=@MasterID

			set @RET_ID=@MasterID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetMasters_Country]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[spu_SetMasters_Country](
@CountryID int,
@CountryName varchar(500),
@CountryCode varchar(500),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select CountryID from Masters_Country where Isdeleted=0 and CountryID !=@CountryID and CountryCode=@CountryCode)
	throw 51000,'Code already exists',1

	if @CountryID=0
		begin
			insert into Masters_Country(CountryID, CountryCode, CountryName,Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.Seq_Masters_Country, @CountryCode, @CountryName , @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='Seq_Masters_Country'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Masters_Country set
			CountryCode=@CountryCode,CountryName=@CountryName,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where CountryID=@CountryID

			set @RET_ID=@CountryID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_Attachment]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spu_SetOnboarding_Attachment]
	(
		@Token Varchar(500),
		@id AS int,		
		@filename As varchar(255),
		@contenttype AS varchar(255),
		@Description as Varchar(255),
		@createdby int,
		@IPAddress Varchar(255)
	)
	AS 
	begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@AppID int=0
	BEGIN TRY 
		select @AppID= AppID from Onboard_Application where Token=@Token
		IF @ID=0
			BEGIN     
				select @RET_ID =isnull(max(Attach_ID),0) from Onboard_Attachment
				set @RET_ID=@RET_ID+1;
				INSERT INTO Onboard_Attachment (Attach_ID,[filename],AppID, contenttype,Description,createdby,IPAddress)
				Values (@RET_ID,@filename,@AppID,@contenttype,@Description,@createdby,@IPAddress)				
				SET @Status =1
				SET @Message = 'Added Successfully'	
			
				
			END        
		Else            
			BEGIN 
				UPDATE Onboard_Attachment SET 
				[filename]=@filename,
				AppID=@AppID,
				contenttype=@contenttype,
				Description=@Description,
				ModifiedBy=@createdby,ModifiedDate=getdate(),IPAddress=@IPAddress
				WHERE Attach_ID=@id
				SET @RET_ID = @id			
				
				SET @Status =1
				SET @Message = 'Update Successfully'			
			END    	
	END TRY 
	BEGIN CATCH
		SET @Status =-1
		SET @Message = ERROR_MESSAGE()
	END CATCH 

	select @RET_ID as RET_ID,@Status as STATUS,@Message as [MESSAGE]
	END;
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_BankDetails]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboarding_BankDetails](
@Token Varchar(500),
@BankName varchar(500),
@BankBranch varchar(500),
@AccountNo varchar(500),
@IFSCCode varchar(500),
@NomineeName varchar(500),
@NomineeDOB varchar(500)=null,
@NomineeRelation varchar(500),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@DocNo varchar(50)

BEGIN TRY	
	update Onboard_Application set 
	BankName=@BankName, AccountNo=@AccountNo, IFSCCode=@IFSCCode,BankBranch=@BankBranch,
	NomineeName=@NomineeName,NomineeDOB=@NomineeDOB,NomineeRelation=@NomineeRelation,
	ModifiedBy=@createdby,CreatedBy=@createdby,ModifiedDate=getdate(), IPAddress=@IPAddress
	where Token=@Token

	set @RET_ID=1;
	set @Status=1;
	set @Message= 'Updated Successfully'
	
	
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_BasicDetails]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboarding_BasicDetails](
@Token Varchar(500),
@Name varchar(500),
@Gender varchar(500),
@FatherName varchar(500),
@DOB varchar(50),
@Mobile varchar(500),
@EmailID varchar(500),
@BloodGroup varchar(50),
@MaritalStatus varchar(50),
@CountryID int,
@RegionID int,
@StateID int,
@CityID int,
@PINCode varchar(500),
@Address varchar(max),
@AadharNo varchar(50),
@UAN varchar(50),
@ESIC varchar(50),
@PAN varchar(50),
@VaccinationDetails varchar(50),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@DocNo varchar(50)

BEGIN TRY	
	
	 update Onboard_Application set Name=@Name, Gender=@Gender, Mobile=@Mobile, EmailID=@EmailID, FatherName=@FatherName,
	 DOB=@DOB, BloodGroup=@BloodGroup, MaritalStatus=@MaritalStatus, VaccinationDetails=@VaccinationDetails,
	 CountryID=@CountryID, RegionID=@RegionID,StateID=@StateID, CityID=@CityID, StepCompleted=1,
     PINCode=@PINCode,Address=@Address,
	 AadharNo=@AadharNo,PAN=@PAN,ESIC=@ESIC,UAN=@UAN
	 ,ModifiedBy=@createdby,CreatedBy=@createdby,ModifiedDate=getdate(), IPAddress=@IPAddress
	where Token=@Token

	set @RET_ID=1;
	set @Status=1;
	set @Message= 'Updated Successfully'
	
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_Create]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboarding_Create](
@Name varchar(500),
@Gender varchar(500),
@FatherName varchar(500),
@Mobile varchar(500),
@EmailID varchar(500),
@DOB varchar(50),
@Token varchar(500),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@DocNo varchar(50)=''

BEGIN TRY	

	--if exists(select AppID from Onboard_Application where Isdeleted=0 and Name =@Name and Mobile=@Mobile and EmailID=@EmailID )
	--throw 51000,'Application already exists',1

	
	select @RET_ID=Isnull(Max(AppID),0) from Onboard_Application
	set @RET_ID+=1;
	set @DocNo='TH'+format(@RET_ID,'000000')

	insert into Onboard_Application(AppID,DocNo, Name,Gender,FatherName,Mobile,DOB,EmailID,Token, Approved,CreatedBy,ModifiedBy,IPAddress)
	values(@RET_ID,@DocNo,@Name,@Gender,@FatherName,@Mobile,@DOB,@EmailID,@Token,-1, @createdby,@createdby,@IPAddress)
	set @Status=1
	set @Message='Inserted Successfully'
	
	if @RET_ID>0
		begin
			exec spu_CreateMail_OnboardCreate  @Token
		end

END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message],@DocNo as AdditionalMessage

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_Final]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboarding_Final](
@Token Varchar(500),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@DocNo varchar(50)

BEGIN TRY	
	update Onboard_Application set Approved=0,ApprovedRemarks='',
	ModifiedBy=@createdby,CreatedBy=@createdby,ModifiedDate=getdate(), IPAddress=@IPAddress
	where Token=@Token

	set @RET_ID=1;
	set @Status=1;
	set @Message= 'Updated Successfully'
	
	
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboarding_Update]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboarding_Update](
@AppID int,
@DocNo varchar(50),
@Name varchar(500),
@FatherName varchar(500),
@Gender varchar(500),
@Mobile varchar(500),

@EmailID varchar(500),
--@DOB date,
@BloodGroup varchar(500),
@MaritalStatus varchar(500),
@Qualification varchar(500),
@Experience varchar(500),
@EmergencyMobile varchar(500),
@EmergencyName varchar(500),
@EmergencyRelation varchar(500),
@State varchar(500),
@City varchar(500),
@PINCode varchar(500),
@Metropolitan varchar(500),
@CurrentAddress varchar(500),
@NomineeName varchar(500),

--@NomineeDOB datetime,
--@DOB datetime,
--@ContractEndDate datetime,
--@DOJ datetime,

@Attach_ID int,

@NomineeRelation varchar(500),
@PAN varchar(500),
@AadharNo varchar(500),
@WL_State varchar(500),
@WL_City varchar(500),

@WL_PIN varchar(500),
--@DOJ date,
@Department varchar(500),
@Designation varchar(500),
@SalaryType varchar(500),
@Salary_Month decimal(18, 2),

@NoticePeriod int,
@RPT_ManagerName varchar(500),
@RPT_ManagerEmail varchar(500),
@RPT_ManagerPhone varchar(500),
@UAN varchar(500),
@ESIC varchar(500),
@Category varchar(500),
@BankName varchar(500),
@AccountNo varchar(500),
@IFSCCode varchar(500),
@Remarks varchar(500),
@Approved int,
@ApprovedRemarks varchar(500),
--@ApprovedDate datetime,
--@ApprovedBy int,


@DealerName varchar(500),
@WorkProfile varchar(500),
@NetPay varchar(500),
@Dose1 varchar(500),
@Dose2 varchar(500),


@PaymentMode varchar(500),
@EmergencyEmail varchar(500),
@Country varchar(500),


@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

		update Onboard_Application set
		 Name=@Name,DocNo=@DocNo,Gender=@Gender,Mobile=@Mobile,EmailID=@EmailID,FatherName=@FatherName,
		 --NomineeDOB=@NomineeDOB,DOB=@DOB,ContractEndDate=@ContractEndDate,DOJ=@DOJ,
		PaymentMode=@PaymentMode,EmergencyEmail=@EmergencyEmail,Country=@Country,Attach_ID=@Attach_ID,
		BloodGroup=@BloodGroup,MaritalStatus=@MaritalStatus,Qualification=@Qualification,Experience=@Experience,
		EmergencyMobile=@EmergencyMobile,EmergencyName=@EmergencyName,EmergencyRelation=@EmergencyRelation,State=@State,
		City=@City,PINCode=@PINCode,Metropolitan=@Metropolitan,CurrentAddress=@CurrentAddress,NomineeName=@NomineeName,
		NomineeRelation=@NomineeRelation,PAN=@PAN,AadharNo=@AadharNo,WL_State=@WL_State,WL_City=@WL_City,
		WL_PIN=@WL_PIN,Department=@Department,Designation=@Designation,SalaryType=@SalaryType,Salary_Month=@Salary_Month,
		NoticePeriod=@NoticePeriod,RPT_ManagerName=@RPT_ManagerName,RPT_ManagerEmail=@RPT_ManagerEmail,
		RPT_ManagerPhone=@RPT_ManagerPhone,UAN=@UAN,ESIC=@ESIC,Category=@Category,BankName=@BankName,AccountNo=@AccountNo,
		IFSCCode=@IFSCCode,Remarks=@Remarks,Approved=@Approved,ApprovedRemarks=@ApprovedRemarks,
			
		DealerName=@DealerName,WorkProfile=@WorkProfile,NetPay=@NetPay,Dose1=@Dose1,Dose2=@Dose2,
		ModifiedBy= @createdby,ModifiedDate=GETDATE(),
		IPAddress=@IPAddress
		where DocNo=@DocNo

		set @RET_ID=@AppID
		set @Status=1
		set @Message='Update Successfully'

		
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetOnboardingApproval]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetOnboardingApproval](
@APPID  varchar(max),
@Approved int,
@ApprovedRemarks  varchar(max),
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500),@ID int=0,@LogID int=0;
declare @outputcurs table (RET_ID int,Status int ,Message varchar(max))

BEGIN TRY	
		
			update Onboard_Application set
			Approved=@Approved,ApprovedRemarks=@ApprovedRemarks,ApprovedDate=getdate(),ApprovedBy=@createdby,
			ModifiedDate=GETDATE(),ModifiedBy=@createdby,
			IPAddress=@IPAddress
			where AppID in (select * from dbo.splitstring(@APPID))

			set @Status=1
			set @Message= (case when @Approved=1 then 'Approved' when @Approved=2 then 'Resubmitted' end)+' Successfully';

		
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE();
			update Onboard_Application set Approved=0 where AppID in (select * from dbo.splitstring(@APPID))
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetProfilePic]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spu_SetProfilePic]
	(	
		@filename As varchar(255),
		@contenttype AS varchar(255),
		@Description as Varchar(255),
		@tableid as bigint,
		@TableName as Varchar(255),
		@createdby int,
		@IPAddress Varchar(255)
	)
	AS 
	begin
	declare @RET_ID int=0,@Status int,@Message varchar(500)
	BEGIN TRY 
		
		if exists(select LoginID from Login_Users where LoginID=@createdby and AttachID=0 and Isdeleted=0)
			BEGIN     
				INSERT INTO master_attachment (Attach_ID,[filename],TableID, contenttype,Description,TableName,createdby,IPAddress)
				Values (Next value for dbo.seq_master_attachment,@filename,@tableid,@contenttype,@Description,@TableName,@createdby,@IPAddress)				

				select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_master_attachment'
				SET @Status =1
				SET @Message = 'Added Successfully'	
			
			END        
		Else            
			BEGIN 
				UPDATE master_attachment SET [filename]=@filename,TableID=@tableid,contenttype=@contenttype,Description=@Description  ,
				TableName=@TableName,createdby=@createdby,IPAddress=@IPAddress,ModifiedDate=GETDATE()
				WHERE Attach_ID=(select AttachID from Login_Users where LoginID=@createdby)
						
				select @RET_ID=AttachID from Login_Users where Isdeleted=0 and LoginID=@createdby
				SET @Status =1		
			END    	

				update Login_Users set AttachID=@RET_ID,IPAddress=@IPAddress,ModifiedBy=@createdby,ModifiedDate=GETDATE()
				where LoginID=@createdby

				select @Message=dbo.fnGetAttachPath(@RET_ID);
	END TRY 
	BEGIN CATCH
		SET @Status =-1
		SET @Message = ERROR_MESSAGE()
	END CATCH 

	select @RET_ID as RET_ID,@Status as STATUS,@Message as [MESSAGE]
	END;
GO
/****** Object:  StoredProcedure [dbo].[spu_SetRegion]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[spu_SetRegion](
@RegionID int,
@RegionName varchar(500),
@RegionCode varchar(2000),
@CountryID int,
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select RegionID from Masters_Region where Isdeleted=0 and RegionID !=@RegionID and RegionCode=@RegionCode)
	throw 51000,'Code already exists',1

	if @RegionID=0
		begin
			insert into Masters_Region(RegionID,CountryID, RegionCode,RegionName, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Masters_Region,@CountryID,@RegionCode, @RegionName, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Masters_Region'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Masters_Region set
			RegionName=@RegionName,RegionCode=@RegionCode,
			CountryID=@CountryID,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where RegionID=@RegionID

			set @RET_ID=@RegionID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetState]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[spu_SetState](
@StateID int,
@StateName varchar(500),
@StateCode varchar(2000),
@TIN varchar(50),
@RegionID int,
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select RegionID from Masters_State where Isdeleted=0 and StateID !=@StateID and StateCode=@StateCode)
	throw 51000,'Code already exists',1

	if @RegionID=0
		begin
			insert into Masters_State(StateID,StateCode,StateName,TIN,RegionID, Priority,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Masters_State,@StateCode, @StateName,@TIN,@RegionID, @Priority,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Masters_State'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Masters_State set
			StateName=@StateName,StateCode=@StateCode,TIN=@TIN,
			RegionID=@RegionID,Priority= @Priority,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where StateID=@StateID

			set @RET_ID=@RegionID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetUpdateColumn_Common]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[spu_SetUpdateColumn_Common](@ID int,@Value varchar(500),@Doctype varchar(500),@IsActive_Reason varchar(max),@createdby int,@IPAddress varchar(500))
as
begin
Declare @RET_ID int=0,@STATUS int=0, @MESSAGE  VARCHAR(MAX)=''
 BEGIN TRY 
	if @Doctype='ClientBilling_IsActive'
		begin
				Update Billing  Set IsActive=@Value,IsActive_Reason=@IsActive_Reason, IsActive_Date=GetDate(),IsActive_By=@createdby, IPAddress=@IPAddress where BillID=@ID
				set @RET_ID=@ID
				SET @STATUS =1
				SET @MESSAGE = 'IsActive Updated Successfully'
				
		end
	else if @Doctype='HelpdeskCategory_IsActive'
		begin
				Update HelpDesk_Category  Set IsActive=@Value,IsActive_Reason=@IsActive_Reason, IsActive_Date=GetDate(),IsActive_By=@createdby, IPAddress=@IPAddress where CategoryID=@ID
				set @RET_ID=@ID
				SET @STATUS =1
				SET @MESSAGE = 'IsActive Updated Successfully'
				
		end
	else if @Doctype='HelpdeskSubCategory_IsActive'
		begin
				Update HelpDesk_SubCategory  Set IsActive=@Value,IsActive_Reason=@IsActive_Reason, IsActive_Date=GetDate(),IsActive_By=@createdby, IPAddress=@IPAddress where SubCategoryID=@ID
				set @RET_ID=@ID
				SET @STATUS =1
				SET @MESSAGE = 'IsActive Updated Successfully'
				
		end
	else if @Doctype='HelpdeskStatus_IsActive'
		begin
				Update HelpDesk_Status  Set IsActive=@Value,IsActive_Reason=@IsActive_Reason, IsActive_Date=GetDate(),IsActive_By=@createdby, IPAddress=@IPAddress where StatusID=@ID
				set @RET_ID=@ID
				SET @STATUS =1
				SET @MESSAGE = 'IsActive Updated Successfully'
				
		end
	else
		begin
				SET @MESSAGE = 'error occured, please contact to administrator'
		end
	

 END TRY 
		BEGIN CATCH
			SET @STATUS =-1
			SET @MESSAGE = ERROR_MESSAGE()
		END CATCH 

select @RET_ID as RET_ID,@STATUS as [STATUS],@MESSAGE as [MESSAGE]
end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetUserOnboarding]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spu_SetUserOnboarding](
@AppID int,
@Description varchar(500),


@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select AppID from Onboard_Attachment where Isdeleted=0 and AppID!=@AppID)
	throw 51000,'Application already exists',1

	select @AppID=Isnull(Max(AppID),0) from Onboard_Attachment
	set @AppID+=1;
	--set @DocNo='DOC-'+format(@AppID,'000000')

	insert into Onboard_Attachment(AppID, Description, CreatedBy,ModifiedBy,IPAddress)
	values(@AppID,@Description, @createdby,@createdby,@IPAddress)
	set @Status=1
	set @Message='Inserted Successfully'
		
	
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetUserRoles]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spu_SetUserRoles](
@RoleID int,
@RoleName varchar(500),
@description varchar(2000),
@IsActive int,
@Priority int,
@createdby int,
@IPAddress varchar(50))
as
begin
declare @RET_ID int=0,@Status int,@Message varchar(500)

BEGIN TRY	

	if exists(select RoleID from Login_roles where Isdeleted=0 and RoleID!=@RoleID and RoleName=@RoleName)
	throw 51000,'Record already exists',1

	if @RoleID=0
		begin
			insert into Login_roles(RoleID, rolename, Priority,description,CreatedBy,ModifiedBy,IPAddress)
			values(Next value for dbo.seq_Login_Roles,@RoleName, @Priority,@description,@createdby,@createdby,@IPAddress)

			select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Login_Roles'
			set @Status=1
			set @Message='Inserted Successfully'
		end
	Else
		begin
			update Login_roles set
			RoleName=@RoleName,Priority= @Priority,
			description=@description,ModifiedBy= @createdby,ModifiedDate=GETDATE(),
			IPAddress=@IPAddress
			where RoleID=@RoleID

			set @RET_ID=@RoleID
			set @Status=1
			set @Message='Update Successfully'

		end
END TRY
BEGIN CATCH
			set @Status=-1
			set @Message= ERROR_MESSAGE()
END CATCH

select @RET_ID as RET_ID,@Status as [Status],@Message as [Message]

end
GO
/****** Object:  StoredProcedure [dbo].[spu_SetUsers]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spu_SetUsers]
	(
		@LoginID AS int,		
		@userID AS nvarchar(45),
		@password AS nvarchar(45),
		@Name AS nvarchar(45),
		@Phone AS nvarchar(45),
		@Email AS nvarchar(45),
		@Description as nvarchar(1000),
		@roleid as int,
		@createdby int,
		@IPAddress nvarchar(50)
	)
	AS 
	begin
declare @RET_ID int=0,@Status int,@Message varchar(500)
	BEGIN TRY 
		if exists(select LoginID from Login_Users where Isdeleted=0 and LoginID!=@LoginID and userID=@userID )
		throw 51000,'User ID already exists',1
		IF @LoginID=0
			BEGIN     
				
				INSERT INTO Login_Users (LoginID,UserID,password,Name,Phone,Email,roleid,createdby,modifiedby,IPAddress)
				Values (Next value for dbo.seq_Login_Users,@UserID,@password,@Name, @Phone,@Email,@roleid,@createdby,@createdby,@IPAddress)				
				select @RET_ID = isnull(cast(current_value as int),0) from sys.sequences  where name='seq_Login_Users'
				set @Status=1
				set @Message='Inserted Successfully'
			
			END        
		Else            
			BEGIN 
				UPDATE Login_Users SET UserID=@UserID,Name=@Name,password=@password,Phone=@Phone,Email=@Email,
				roleid=@roleid,modifiedby=@createdby,ModifiedDate=CURRENT_TIMESTAMP
				WHERE LoginID=@LoginID
				
				
				set @RET_ID=@LoginID
				set @Status=1
				set @Message='Update Successfully'
		
			END    	
	END TRY 
	BEGIN CATCH
		SET @Status =-1
		SET @Message = ERROR_MESSAGE()
	END CATCH 

	select @RET_ID as RET_ID,@Status as Status,@Message as Message
	END;
GO
/****** Object:  StoredProcedure [dbo].[spu_Update_Menu_Role_Tran]    Script Date: 14-09-2024 05:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spu_Update_Menu_Role_Tran]
as
begin
   declare @Role_ID int,@menuID int,@Permission bit=0;
   declare  author_cursor cursor for
   select a.RoleID ,b.MenuID from Login_Roles as a cross join login_menu as b
   open author_cursor
   fetch next from author_cursor into @Role_ID,@menuID
   WHILE @@FETCH_STATUS = 0
   begin
   if @Role_ID=1
					begin
						set @Permission=1;
					end
				else
					begin
						set @Permission=0;
					end
     if (select count(*) from Login_Menu_Role_Tran where RoleID=@Role_ID and MenuID=@menuID )=0
     begin
      insert into Login_Menu_Role_Tran(TranID,MenuID,RoleID,R,W,M)
	  values((isnull((select max(TranID)+1 from Login_Menu_Role_Tran),1)),@menuID,@Role_ID,@Permission,@Permission,@Permission)
     end
     fetch next from author_cursor into @Role_ID,@menuID
   end
 
  close author_cursor
  deallocate author_cursor
end
GO
