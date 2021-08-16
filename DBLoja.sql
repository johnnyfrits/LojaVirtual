USE [master]
GO
/****** Object:  Database [LojaNew]    Script Date: 13/08/2021 19:00:51 ******/
CREATE DATABASE [LojaNew]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Vendas', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Vendas.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Vendas_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Vendas_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [LojaNew] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LojaNew].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LojaNew] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LojaNew] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LojaNew] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LojaNew] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LojaNew] SET ARITHABORT OFF 
GO
ALTER DATABASE [LojaNew] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LojaNew] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LojaNew] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LojaNew] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LojaNew] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LojaNew] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LojaNew] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LojaNew] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LojaNew] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LojaNew] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LojaNew] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LojaNew] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LojaNew] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LojaNew] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LojaNew] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LojaNew] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LojaNew] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LojaNew] SET RECOVERY FULL 
GO
ALTER DATABASE [LojaNew] SET  MULTI_USER 
GO
ALTER DATABASE [LojaNew] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LojaNew] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LojaNew] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LojaNew] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LojaNew] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LojaNew] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'LojaNew', N'ON'
GO
ALTER DATABASE [LojaNew] SET QUERY_STORE = OFF
GO
USE [LojaNew]
GO
/****** Object:  Table [dbo].[Pedidos]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pedidos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NOT NULL,
	[Data] [datetime] NOT NULL,
 CONSTRAINT [PK_Pedidos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[CPF] [bigint] NOT NULL,
	[Endereco] [varchar](50) NULL,
	[Numero] [varchar](10) NULL,
	[Bairro] [varchar](50) NULL,
	[Cidade] [varchar](50) NULL,
	[Estado] [varchar](2) NULL,
	[Cep] [varchar](8) NULL,
	[Telefone] [bigint] NULL,
	[Celular] [bigint] NULL,
	[Email] [varchar](100) NULL,
	[DataNasc] [date] NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Top3ClientesQtdeCompras2Trimestre]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Top3ClientesQtdeCompras2Trimestre]
AS
SELECT TOP (3) ClienteId,
                      (SELECT Nome
                       FROM      dbo.Clientes AS C
                       WHERE   (Id = P.ClienteId)) AS Nome, COUNT(*) AS QtdePedidos
FROM     dbo.Pedidos AS P
WHERE  (Data BETWEEN '01/04/' + LTRIM(STR(YEAR(GETDATE()))) AND '30/06/' + LTRIM(STR(YEAR(GETDATE()))))
GROUP BY ClienteId
ORDER BY QtdePedidos DESC
GO
/****** Object:  Table [dbo].[PedidosItens]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PedidosItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PedidoId] [int] NOT NULL,
	[ProdutoId] [int] NOT NULL,
	[NroItem] [int] NULL,
	[Preco] [decimal](18, 2) NULL,
	[Quantidade] [decimal](18, 3) NULL,
	[Total] [decimal](18, 2) NULL,
 CONSTRAINT [PK_PedidosItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Top2ClientesTotalGasto2Trimestre]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Top2ClientesTotalGasto2Trimestre]
AS
SELECT TOP (2) P.ClienteId,
                      (SELECT Nome
                       FROM      dbo.Clientes AS C
                       WHERE   (Id = P.ClienteId)) AS Nome, SUM(PI.Total) AS TotalGasto
FROM     dbo.Pedidos AS P INNER JOIN
                  dbo.PedidosItens AS PI ON PI.PedidoId = P.Id
WHERE  (P.Data BETWEEN '01/04/' + LTRIM(STR(YEAR(GETDATE()))) AND '30/06/' + LTRIM(STR(YEAR(GETDATE()))))
GROUP BY P.ClienteId
ORDER BY TotalGasto DESC
GO
/****** Object:  Table [dbo].[Produtos]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Produtos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Preco] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Produtos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ListagemProdutosMenosSaidasNoAno]    Script Date: 13/08/2021 19:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ListagemProdutosMenosSaidasNoAno]
AS
SELECT TOP (100) PERCENT Pro.Id, Pro.Descricao, ISNULL(SUM(PI_1.Quantidade), 0) AS QtdeVend
FROM     dbo.Produtos AS Pro LEFT OUTER JOIN
                      (SELECT PI.ProdutoId, PI.Quantidade
                       FROM      dbo.Pedidos AS P INNER JOIN
                                         dbo.PedidosItens AS PI ON PI.PedidoId = P.Id
                       WHERE   (YEAR(P.Data) = YEAR(GETDATE()))) AS PI_1 ON PI_1.ProdutoId = Pro.Id
GROUP BY Pro.Id, Pro.Descricao
ORDER BY QtdeVend
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Clientes] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Clientes] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Clientes]
GO
ALTER TABLE [dbo].[PedidosItens]  WITH CHECK ADD  CONSTRAINT [FK_PedidosItens_Pedidos] FOREIGN KEY([PedidoId])
REFERENCES [dbo].[Pedidos] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PedidosItens] CHECK CONSTRAINT [FK_PedidosItens_Pedidos]
GO
ALTER TABLE [dbo].[PedidosItens]  WITH CHECK ADD  CONSTRAINT [FK_PedidosItens_Produtos] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produtos] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PedidosItens] CHECK CONSTRAINT [FK_PedidosItens_Produtos]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Pro"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PI_1"
            Begin Extent = 
               Top = 7
               Left = 341
               Bottom = 126
               Right = 586
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListagemProdutosMenosSaidasNoAno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListagemProdutosMenosSaidasNoAno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "P"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PI"
            Begin Extent = 
               Top = 7
               Left = 341
               Bottom = 170
               Right = 586
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Top2ClientesTotalGasto2Trimestre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Top2ClientesTotalGasto2Trimestre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "P"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Top3ClientesQtdeCompras2Trimestre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Top3ClientesQtdeCompras2Trimestre'
GO
USE [master]
GO
ALTER DATABASE [LojaNew] SET  READ_WRITE 
GO
