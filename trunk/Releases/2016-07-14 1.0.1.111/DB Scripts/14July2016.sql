USE [master]
GO
/****** Object:  Database [TLASPre]    Script Date: 7/14/2016 12:42:27 PM ******/
CREATE DATABASE [TLASPre]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TLASPre', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\TLASPre.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TLASPre_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\TLASPre_log.ldf' , SIZE = 6912KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TLASPre] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TLASPre].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TLASPre] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [TLASPre] SET ANSI_NULLS ON 
GO
ALTER DATABASE [TLASPre] SET ANSI_PADDING ON 
GO
ALTER DATABASE [TLASPre] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [TLASPre] SET ARITHABORT ON 
GO
ALTER DATABASE [TLASPre] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TLASPre] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [TLASPre] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TLASPre] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TLASPre] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TLASPre] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [TLASPre] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [TLASPre] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TLASPre] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [TLASPre] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TLASPre] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TLASPre] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TLASPre] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TLASPre] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TLASPre] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TLASPre] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TLASPre] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TLASPre] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TLASPre] SET RECOVERY FULL 
GO
ALTER DATABASE [TLASPre] SET  MULTI_USER 
GO
ALTER DATABASE [TLASPre] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [TLASPre] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TLASPre] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TLASPre] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [TLASPre]
GO
/****** Object:  User [IIS APPPOOL\DefaultAppPool]    Script Date: 7/14/2016 12:42:27 PM ******/
CREATE USER [IIS APPPOOL\DefaultAppPool] FOR LOGIN [IIS APPPOOL\DefaultAppPool] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IIS APPPOOL\DefaultAppPool]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [IIS APPPOOL\DefaultAppPool]
GO
/****** Object:  StoredProcedure [dbo].[GetLoadedReport]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:           <Author,,Name>
-- Create date: <Create Date,,>
-- Description:      <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLoadedReport]
       -- Add the parameters for the stored procedure here
       @Startdatetime datetime,
       @Enddatetime datetime,
       @Prodtype int

AS
BEGIN

IF(@Prodtype=0) --LPG
            BEGIN
               select *,ROW_NUMBER() 
        OVER (ORDER BY ModifiedDate) AS RowNo from dbo.ShipLoadedRpt where ActQty IS NOT NULL AND ProductName='LPG' AND ModifiedDate between @Startdatetime and @Enddatetime
                        
                                    END
      ELSE
            BEGIN
          IF(@Prodtype=1)  --Condensate
                BEGIN
                select *,ROW_NUMBER() 
        OVER (ORDER BY ModifiedDate) AS RowNo from dbo.ShipLoadedRpt where ActQty IS NOT NULL AND ProductName='Condensate' AND ModifiedDate between @Startdatetime and @Enddatetime
                       
                END
  END
END


GO
/****** Object:  Table [dbo].[AccessCard]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessCard](
	[CardID] [int] NOT NULL,
	[BayID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[IsAssigned] [bit] NOT NULL,
	[LastActive] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Remarks] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CardKey] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_AccessCard] PRIMARY KEY CLUSTERED 
(
	[CardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bay]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bay](
	[BayID] [int] IDENTITY(1,1) NOT NULL,
	[Frequency] [int] NOT NULL,
	[CurrQueue] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastActive] [datetime] NULL,
	[Remarks] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ProductID] [int] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_Bay] PRIMARY KEY CLUSTERED 
(
	[BayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Carrier]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carrier](
	[CarrierID] [int] IDENTITY(1,1) NOT NULL,
	[CarrierName] [nvarchar](50) NULL,
	[CarrierAddress] [nvarchar](200) NULL,
	[ContactName] [nvarchar](50) NULL,
	[CarrierPhone] [nvarchar](50) NULL,
	[CarrierMobile] [nvarchar](50) NULL,
	[CarrierEmail] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[LastActive] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[CarrierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Carrier] UNIQUE NONCLUSTERED 
(
	[CarrierName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Compartment]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compartment](
	[CompartmentID] [int] IDENTITY(1,1) NOT NULL,
	[CompartmentCode] [int] NOT NULL,
	[Capactiy] [int] NOT NULL,
	[TrailerID] [int] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_Compartment] PRIMARY KEY CLUSTERED 
(
	[CompartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[CustomerAddress] [nvarchar](200) NULL,
	[ContactName] [nvarchar](50) NULL,
	[CustomerPhone] [nvarchar](50) NULL,
	[CustomerMobile] [nvarchar](50) NULL,
	[CustomerEmail] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[ModifiedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK__Customer__A4AE64B8DB28F8DD] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Customer] UNIQUE NONCLUSTERED 
(
	[CustomerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Driver]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver](
	[DriverID] [int] IDENTITY(1,1) NOT NULL,
	[DriverName] [nvarchar](50) NOT NULL,
	[LicenseNo] [nvarchar](50) NOT NULL,
	[LicenseIDate] [date] NOT NULL,
	[LicenseEDate] [date] NOT NULL,
	[CNIC] [nvarchar](13) NOT NULL,
	[Mobile] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[LastActive] [datetime] NULL,
	[Remarks] [nvarchar](200) NULL,
	[CarrierID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK__Driver__F1B1CD2465ACB262] PRIMARY KEY CLUSTERED 
(
	[DriverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Driver] UNIQUE NONCLUSTERED 
(
	[CNIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Order]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NULL,
	[OrderQty] [float] NOT NULL,
	[RemainQty] [float] NULL,
	[CustomerID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[OrderCode] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DeletedFlag] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CarrierID] [int] NULL,
	[VehicleID] [int] NULL,
	[OrderStatusID] [int] NOT NULL,
	[OrderDeliveryDT] [datetime] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK__Order__C3905BAF765EA6F6] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Order] UNIQUE NONCLUSTERED 
(
	[OrderCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatus](
	[ID] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[WeighOut] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastActive] [datetime] NULL,
	[Remarks] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Shifts]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shifts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShiftName] [nvarchar](50) NOT NULL,
	[StartTime] [nvarchar](10) NOT NULL,
	[EndTime] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Shifts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Shipment]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IsManual] [bit] NOT NULL,
	[AccessCardID] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DeletedFlag] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ShipmentStatusID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[BayID] [int] NULL,
	[BayName] [nvarchar](10) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[VehicleCode] [nvarchar](10) NULL,
	[DriverName] [nvarchar](50) NULL,
	[DriverCNIC] [nvarchar](13) NULL,
	[CarrierName] [nvarchar](50) NULL,
	[ShipmentDate] [datetime] NULL,
	[ProductID] [int] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShipmentCompartment]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentCompartment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderedQuantity] [int] NULL,
	[PlannedQuantity] [int] NULL,
	[ActualBCUQuantity] [int] NULL,
	[AccessCardKey] [nvarchar](10) NULL,
	[BayID] [int] NOT NULL,
	[Product] [nvarchar](10) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CompartmentID] [int] NULL,
	[ShipmentID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[BayName] [nvarchar](50) NULL,
	[CompartmentCode] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_ShipmentCompartment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShipmentStatus]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_ShipmentStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Trailer]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trailer](
	[TrailerID] [int] IDENTITY(1,1) NOT NULL,
	[TrailerCode] [nvarchar](20) NOT NULL,
	[LoadingType] [bit] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK__Trailer__1B041CC3A2DF0FF4] PRIMARY KEY CLUSTERED 
(
	[TrailerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vehicle]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle](
	[VehicleID] [int] IDENTITY(1,1) NOT NULL,
	[VehicleCode] [nvarchar](10) NOT NULL,
	[LicenseNo] [nvarchar](20) NULL,
	[LicenseIDate] [date] NULL,
	[LicenseEDate] [date] NULL,
	[Active] [bit] NOT NULL,
	[LastActive] [datetime] NULL,
	[Remarks] [nvarchar](200) NULL,
	[CarrierID] [int] NOT NULL,
	[DriverID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK__Vehicle__476B54B2040ADAF8] PRIMARY KEY CLUSTERED 
(
	[VehicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_VehicleCode] UNIQUE NONCLUSTERED 
(
	[VehicleCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WeighBridge]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeighBridge](
	[TareWeight] [int] NULL,
	[LoadedWeight] [int] NULL,
	[Status] [nchar](10) NULL,
	[ActualWeight] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ShipmentID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[VehicleCode] [nvarchar](50) NULL,
	[Ismanual] [bit] NOT NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[ModifiedBy] [nvarchar](250) NULL,
 CONSTRAINT [PK_WeighBridge] PRIMARY KEY CLUSTERED 
(
	[ShipmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[ShipLoadedRpt]    Script Date: 7/14/2016 12:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ShipLoadedRpt]
AS
SELECT        SUM(dbo.ShipmentCompartment.PlannedQuantity) AS PlanQty, SUM(dbo.ShipmentCompartment.ActualBCUQuantity) AS ActQty, dbo.Shipment.ID AS ShipID, dbo.Shipment.ModifiedDate, 
                         dbo.Shipment.ShipmentStatusID, dbo.Shipment.VehicleCode, dbo.Product.ProductName, dbo.[Order].OrderQty, dbo.[Order].OrderID, dbo.[Order].OrderCode
FROM            dbo.ShipmentCompartment INNER JOIN
                         dbo.Shipment ON dbo.ShipmentCompartment.ShipmentID = dbo.Shipment.ID INNER JOIN
                         dbo.[Order] ON dbo.Shipment.OrderID = dbo.[Order].OrderID INNER JOIN
                         dbo.Product ON dbo.[Order].ProductID = dbo.Product.ProductID
GROUP BY dbo.Shipment.ID, dbo.Shipment.ModifiedDate, dbo.Shipment.ShipmentStatusID, dbo.Shipment.VehicleCode, dbo.Product.ProductName, dbo.[Order].OrderQty, dbo.[Order].OrderID, dbo.[Order].OrderCode



GO
/****** Object:  Index [IX_Shipment]    Script Date: 7/14/2016 12:42:27 PM ******/
CREATE NONCLUSTERED INDEX [IX_Shipment] ON [dbo].[Shipment]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccessCard] ADD  CONSTRAINT [DF_AccessCard_ModifiedDatetime]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[AccessCard] ADD  CONSTRAINT [DF_AccessCard_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Bay] ADD  CONSTRAINT [DF_Bay_Frequency]  DEFAULT ((0)) FOR [Frequency]
GO
ALTER TABLE [dbo].[Bay] ADD  CONSTRAINT [DF_Bay_CurrQueue]  DEFAULT ((0)) FOR [CurrQueue]
GO
ALTER TABLE [dbo].[Bay] ADD  CONSTRAINT [DF_Bay_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Bay] ADD  CONSTRAINT [DF_Bay_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Carrier] ADD  CONSTRAINT [DF_Carrier_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Carrier] ADD  CONSTRAINT [DF_Carrier_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Compartment] ADD  CONSTRAINT [DF_Compartment_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Compartment] ADD  CONSTRAINT [DF_Compartment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Driver] ADD  CONSTRAINT [DF_Driver_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Driver] ADD  CONSTRAINT [DF_Driver_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_DeletedFlag]  DEFAULT ((0)) FOR [DeletedFlag]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Shipment] ADD  CONSTRAINT [DF_Shipment_IsManual]  DEFAULT ((0)) FOR [IsManual]
GO
ALTER TABLE [dbo].[Shipment] ADD  CONSTRAINT [DF_Shipment_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Shipment] ADD  CONSTRAINT [DF_Shipment_DeletedFlad]  DEFAULT ((0)) FOR [DeletedFlag]
GO
ALTER TABLE [dbo].[Shipment] ADD  CONSTRAINT [DF_Shipment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ShipmentCompartment] ADD  CONSTRAINT [DF_ShipmentCompartment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ShipmentCompartment] ADD  CONSTRAINT [DF_ShipmentCompartment_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Trailer] ADD  CONSTRAINT [DF_Trailer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Trailer] ADD  CONSTRAINT [DF_Trailer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Vehicle] ADD  CONSTRAINT [DF_Vehicle_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Vehicle] ADD  CONSTRAINT [DF_Vehicle_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[WeighBridge] ADD  CONSTRAINT [DF_WeighBridge_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[WeighBridge] ADD  CONSTRAINT [DF_WeighBridge_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[WeighBridge] ADD  CONSTRAINT [DF_WeighBridge_Ismanual]  DEFAULT ((0)) FOR [Ismanual]
GO
ALTER TABLE [dbo].[AccessCard]  WITH CHECK ADD  CONSTRAINT [FK_AccessCard_Bay] FOREIGN KEY([BayID])
REFERENCES [dbo].[Bay] ([BayID])
GO
ALTER TABLE [dbo].[AccessCard] CHECK CONSTRAINT [FK_AccessCard_Bay]
GO
ALTER TABLE [dbo].[Bay]  WITH CHECK ADD  CONSTRAINT [FK_Bay_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Bay] CHECK CONSTRAINT [FK_Bay_Product]
GO
ALTER TABLE [dbo].[Compartment]  WITH CHECK ADD  CONSTRAINT [FK_Compartment_Trailer] FOREIGN KEY([TrailerID])
REFERENCES [dbo].[Trailer] ([TrailerID])
GO
ALTER TABLE [dbo].[Compartment] CHECK CONSTRAINT [FK_Compartment_Trailer]
GO
ALTER TABLE [dbo].[Driver]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Driver_dbo.Carrier_CarrierID] FOREIGN KEY([CarrierID])
REFERENCES [dbo].[Carrier] ([CarrierID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Driver] CHECK CONSTRAINT [FK_dbo.Driver_dbo.Carrier_CarrierID]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Order_dbo.Customer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_dbo.Order_dbo.Customer_CustomerID]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Order_dbo.Product_ProductID] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_dbo.Order_dbo.Product_ProductID]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Carrier] FOREIGN KEY([CarrierID])
REFERENCES [dbo].[Carrier] ([CarrierID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Carrier]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_OrderStatus] FOREIGN KEY([OrderStatusID])
REFERENCES [dbo].[OrderStatus] ([ID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_OrderStatus]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Vehicle] FOREIGN KEY([VehicleID])
REFERENCES [dbo].[Vehicle] ([VehicleID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Vehicle]
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD  CONSTRAINT [FK_Shipment_AccessCard] FOREIGN KEY([AccessCardID])
REFERENCES [dbo].[AccessCard] ([CardID])
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [FK_Shipment_AccessCard]
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD  CONSTRAINT [FK_Shipment_Bay] FOREIGN KEY([BayID])
REFERENCES [dbo].[Bay] ([BayID])
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [FK_Shipment_Bay]
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD  CONSTRAINT [FK_Shipment_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [FK_Shipment_Order]
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD  CONSTRAINT [FK_Shipment_ShipmentStatus] FOREIGN KEY([ShipmentStatusID])
REFERENCES [dbo].[ShipmentStatus] ([ID])
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [FK_Shipment_ShipmentStatus]
GO
ALTER TABLE [dbo].[ShipmentCompartment]  WITH CHECK ADD  CONSTRAINT [FK_ShipmentCompartment_Bay] FOREIGN KEY([BayID])
REFERENCES [dbo].[Bay] ([BayID])
GO
ALTER TABLE [dbo].[ShipmentCompartment] CHECK CONSTRAINT [FK_ShipmentCompartment_Bay]
GO
ALTER TABLE [dbo].[ShipmentCompartment]  WITH CHECK ADD  CONSTRAINT [FK_ShipmentCompartment_Compartment] FOREIGN KEY([CompartmentID])
REFERENCES [dbo].[Compartment] ([CompartmentID])
GO
ALTER TABLE [dbo].[ShipmentCompartment] CHECK CONSTRAINT [FK_ShipmentCompartment_Compartment]
GO
ALTER TABLE [dbo].[ShipmentCompartment]  WITH CHECK ADD  CONSTRAINT [FK_ShipmentCompartment_Shipment] FOREIGN KEY([ShipmentID])
REFERENCES [dbo].[Shipment] ([ID])
GO
ALTER TABLE [dbo].[ShipmentCompartment] CHECK CONSTRAINT [FK_ShipmentCompartment_Shipment]
GO
ALTER TABLE [dbo].[Trailer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Trailer_dbo.Vehicle_VehicleID] FOREIGN KEY([VehicleID])
REFERENCES [dbo].[Vehicle] ([VehicleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Trailer] CHECK CONSTRAINT [FK_dbo.Trailer_dbo.Vehicle_VehicleID]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Vehicle_dbo.Carrier_CarrierID] FOREIGN KEY([CarrierID])
REFERENCES [dbo].[Carrier] ([CarrierID])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_dbo.Vehicle_dbo.Carrier_CarrierID]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Vehicle_dbo.Driver_DriverID] FOREIGN KEY([DriverID])
REFERENCES [dbo].[Driver] ([DriverID])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_dbo.Vehicle_dbo.Driver_DriverID]
GO
ALTER TABLE [dbo].[WeighBridge]  WITH CHECK ADD  CONSTRAINT [FK_WeighBridge_Shipment] FOREIGN KEY([ShipmentID])
REFERENCES [dbo].[Shipment] ([ID])
GO
ALTER TABLE [dbo].[WeighBridge] CHECK CONSTRAINT [FK_WeighBridge_Shipment]
GO
USE [master]
GO
ALTER DATABASE [TLASPre] SET  READ_WRITE 
GO
