USE [master]
GO
/****** Object:  Database [Loja]    Script Date: 13/08/2021 19:00:51 ******/
CREATE DATABASE [Loja]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Loja].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Loja] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Loja] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Loja] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Loja] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Loja] SET ARITHABORT OFF 
GO
ALTER DATABASE [Loja] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Loja] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Loja] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Loja] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Loja] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Loja] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Loja] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Loja] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Loja] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Loja] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Loja] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Loja] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Loja] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Loja] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Loja] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Loja] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Loja] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Loja] SET RECOVERY FULL 
GO
ALTER DATABASE [Loja] SET  MULTI_USER 
GO
ALTER DATABASE [Loja] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Loja] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Loja] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Loja] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Loja] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Loja] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Loja', N'ON'
GO
ALTER DATABASE [Loja] SET QUERY_STORE = OFF
GO
USE [Loja]
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
ALTER DATABASE [Loja] SET  READ_WRITE 
GO

USE [Loja]
GO

INSERT INTO [Produtos] VALUES ('Impressora', 1350.99);
INSERT INTO [Produtos] VALUES ('Notebook', 4500.00);
INSERT INTO [Produtos] VALUES ('Monitor Dell', 500.00);
INSERT INTO [Produtos] VALUES ('Mouse gamer', 99.90);
INSERT INTO [Produtos] VALUES ('Teclado Gamer Redragon', 388.00);
INSERT INTO [Produtos] VALUES ('Smartphone Galaxy S20+', 3599.00);
INSERT INTO [Produtos] VALUES ('Ar condicionado 9.000 BTUs', 1250.00);
INSERT INTO [Produtos] VALUES ('TV Samsung 50 polegadas', 2990.00);
INSERT INTO [Produtos] VALUES ('Mesa de escritório', 450.00);
INSERT INTO [Produtos] VALUES ('Cadeira gamer', 1350.00);
INSERT INTO [Produtos] VALUES ('Mouser Pad', 459.00);


INSERT INTO [Clientes] VALUES ('Benedito Theo Barbosa', 32228496251, 'Rua Bulgária', '778', 'Nova Cidade', 'Manaus', 'AM', '69097465', 9235455238, 92993160201, 'beneditotheobarbosa..beneditotheobarbosa@gruporeis.net', '1991-08-09');
INSERT INTO [Clientes] VALUES ('Eloá Marina Mariah Ramos', 20751454230, 'Travessa Igaraçu', '157', 'Novo Aleixo', 'Manaus', 'AM', '69099066', 9225829566, 92993135503, 'eloamarinamariahramos_@ctfmgacc.org.br', '1991-02-25');
INSERT INTO [Clientes] VALUES ('Vitória Flávia Ferreira', 72494850240, 'Rua Reino Unido', '158', 'Ponta Negra', 'Manaus', 'AM', '69037135', 9226355823, 92994825786, 'vitoriaflaviaferreira..vitoriaflaviaferreira@gasparalmeida.com', '1991-04-07');
INSERT INTO [Clientes] VALUES ('Daiane Priscila Carolina da Luz', 18256414200, 'Rua Comendador Vicente Cruz', '821', 'Santo Antônio', 'Manaus', 'AM', '69029075', 9239555706, 92983676073, 'daianepriscilacarolinadaluz..daianepriscilacarolinadaluz@tasaut.com.br', '1991-10-05');
INSERT INTO [Clientes] VALUES ('Leonardo Hugo da Costa', 5031792213, 'Beco Júlio de Lima', '691', 'Flores', 'Manaus', 'AM', '69058814', 9227611369, 92995401943, 'lleonardohugodacosta@bool.com.br', '1991-07-10');
INSERT INTO [Clientes] VALUES ('Sebastiana Beatriz Manuela Silveira', 60714723266, 'Rua Joaquim Nunes', '644', 'Japiim', 'Manaus', 'AM', '69076760', 9237528622, 92998950759, 'sebastianabeatrizmanuelasilveira__sebastianabeatrizmanuelasilveira@bodyfast.com.br', '1991-12-14');
INSERT INTO [Clientes] VALUES ('Vinicius Sérgio de Paula', 56451527270, 'Rua Paraíso do Tocantins', '618', 'Monte das Oliveiras', 'Manaus', 'AM', '69093701', 9229570245, 92987478881, 'viniciussergiodepaula-88@technocut.com.br', '1991-03-03');
INSERT INTO [Clientes] VALUES ('Gustavo Noah Rocha', 90675453259, 'Rua dos Bronzes', '790', 'Jorge Teixeira', 'Manaus', 'AM', '69088324', 9235971255, 92987875517, 'gustavonoahrocha..gustavonoahrocha@dominiozeladoria.com.br', '1991-08-18');
INSERT INTO [Clientes] VALUES ('Diogo Pedro Monteiro', 80767229266, 'Rua São Geraldo', '380', 'São Geraldo', 'Manaus', 'AM', '69053370', 9226226663, 92987473507, 'diogopedromonteiro-98@ne.com', '1991-08-13');
INSERT INTO [Clientes] VALUES ('Rodrigo Isaac Martins', 44218953260, 'Travessa Palmeira das Missões', '759', 'São José Operário', 'Manaus', 'AM', '69086113', 9239432998, 92986856398, 'rrodrigoisaacmartins@lojabichopapao.com.br', '1991-01-20');
INSERT INTO [Clientes] VALUES ('Benedita Patrícia da Rocha', 70549002278, 'Beco Sertão', '186', 'Aleixo', 'Manaus', 'AM', '69060631', 9235567969, 92997464855, 'beneditapatriciadarocha_@powerblade.com.br', '1991-04-27');
INSERT INTO [Clientes] VALUES ('Bernardo Calebe José da Paz', 70544283236, 'Avenida Frederico Baird', '528', 'Ponta Negra', 'Manaus', 'AM', '69037144', 9226230958, 92998532971, 'bbernardocalebejosedapaz@sabereler.com.br', '1991-08-21');
INSERT INTO [Clientes] VALUES ('Marcela Clarice Jesus', 38113442260, 'Rua Urânio', '114', 'Cidade de Deus', 'Manaus', 'AM', '69099219', 9239920319, 92987277670, 'marcelaclaricejesus__marcelaclaricejesus@htomail.com', '1991-12-05');
INSERT INTO [Clientes] VALUES ('Henry Noah Martin Almada', 92464241237, 'Rua Francisca Mendes', '687', 'Cidade Nova', 'Manaus', 'AM', '69097280', 9236113096, 92989669298, 'henrynoahmartinalmada__henrynoahmartinalmada@bol.br', '1991-10-05');
INSERT INTO [Clientes] VALUES ('Thales Cláudio Manuel da Conceição', 19675504250, 'Avenida Nathan Xavier de Albuquerque', '552', 'Novo Aleixo', 'Manaus', 'AM', '69098145', 9225001923, 92991116273, 'thalesclaudiomanueldaconceicao-90@torrez.com.br', '1991-07-09');
INSERT INTO [Clientes] VALUES ('Enrico Henrique da Rosa', 27638891236, 'Rua Ronaldo Carvalho', '921', 'São Raimundo', 'Manaus', 'AM', '69029570', 9228281007, 92985445366, 'enricohenriquedarosa_@fojsc.unesp.br', '1991-09-25');
INSERT INTO [Clientes] VALUES ('César Raul Severino Pires', 32386740218, 'Rua Hermes da Fonseca', '460', 'Dom Pedro I', 'Manaus', 'AM', '69040050', 9225120082, 92995602951, 'ccesarraulseverinopires@alphagraphics.com.br', '1991-03-01');
INSERT INTO [Clientes] VALUES ('Antonio Elias Raul da Cruz', 55501631288, 'Rua 1º de Março', '113', 'Gilberto Mestrinho', 'Manaus', 'AM', '69006292', 9238422098, 92982227745, 'aantonioeliasrauldacruz@alstom.com', '1991-11-15');
INSERT INTO [Clientes] VALUES ('Antonella Bruna Ferreira', 97419787239, 'Rua Dorabela', '309', 'Santa Etelvina', 'Manaus', 'AM', '69059461', 9235633222, 92981074058, 'antonellabrunaferreira..antonellabrunaferreira@gasparalmeida.com', '1991-03-04');
INSERT INTO [Clientes] VALUES ('Leandro Bernardo Assunção', 68579219205, 'Beco Jesus Salvador', '271', 'Coroado', 'Manaus', 'AM', '69082631', 9226443478, 92991284216, 'leandrobernardoassuncao__leandrobernardoassuncao@globomail.com', '1991-08-17');
INSERT INTO [Clientes] VALUES ('Amanda Rita Moraes', 2404356216, 'Rua Doutor Mendonça', '108', 'Parque 10 de Novembro', 'Manaus', 'AM', '69055140', 9239622296, 92997391629, 'aamandaritamoraes@ouplook.com', '1991-05-01');
INSERT INTO [Clientes] VALUES ('Márcia Olivia da Luz', 15399206234, 'Beco Bom Jesus', '898', 'São José Operário', 'Manaus', 'AM', '69086563', 9226416450, 92989900193, 'marciaoliviadaluz__marciaoliviadaluz@casaarte.com.br', '1991-06-12');
INSERT INTO [Clientes] VALUES ('Carolina Regina Priscila Lima', 24624625200, 'Rua Barbosa Machado', '251', 'Cidade Nova', 'Manaus', 'AM', '69097163', 9225634876, 92982175743, 'carolinareginapriscilalima__carolinareginapriscilalima@vemter.com.br', '1991-07-09');
INSERT INTO [Clientes] VALUES ('Samuel Marcelo Souza', 23445192200, 'Rua Manaus', '583', 'Colônia Terra Nova', 'Manaus', 'AM', '69093493', 9236821503, 92996112246, 'samuelmarcelosouza_@tpltransportes.com.br', '1991-01-09');
INSERT INTO [Clientes] VALUES ('Yago Cláudio Freitas', 97959081204, 'Rua Bérgano', '727', 'Nova Cidade', 'Manaus', 'AM', '69097335', 9229243377, 92998463097, 'yagoclaudiofreitas_@caocarinho.com.br', '1991-03-08');
INSERT INTO [Clientes] VALUES ('Sebastião Pedro Monteiro', 2286826226, 'Rua das Andorinhas', '521', 'Cidade de Deus', 'Manaus', 'AM', '69099418', 9229509826, 92982422767, 'sebastiaopedromonteiro..sebastiaopedromonteiro@hotmail.fr', '1991-01-23');
INSERT INTO [Clientes] VALUES ('Kaique Heitor Nogueira', 46951288291, 'Rua 10', '401', 'Cidade Nova', 'Manaus', 'AM', '69090865', 9226522329, 92997967176, 'kkaiqueheitornogueira@patrezao.com.br', '1991-07-02');
INSERT INTO [Clientes] VALUES ('Isabela Débora Vieira', 9479150280, 'Rua Pérola', '848', 'Cidade de Deus', 'Manaus', 'AM', '69099218', 9238241292, 92998843751, 'iisabeladeboravieira@pmm.am.gov.br', '1991-12-04');
INSERT INTO [Clientes] VALUES ('Gustavo Marcos Vinicius Rezende', 38927454200, 'Rua Cambuci', '475', 'Cidade Nova', 'Manaus', 'AM', '69097420', 9229809363, 92987424374, 'gustavomarcosviniciusrezende__gustavomarcosviniciusrezende@proshock.com.br', '1991-02-12');
INSERT INTO [Clientes] VALUES ('Mirella Rayssa Ribeiro', 81034561286, 'Beco Flor Azul', '550', 'Educandos', 'Manaus', 'AM', '69070562', 9238641788, 92986453927, 'mirellarayssaribeiro-82@paulistadovale.org.br', '1991-02-15');

