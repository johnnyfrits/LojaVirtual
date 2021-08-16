using LojaVirtual.Models;
using Microsoft.EntityFrameworkCore;

namespace LojaVirtual.Data
{
	public class LojaVirtualContext : DbContext
	{
		public LojaVirtualContext(DbContextOptions<LojaVirtualContext> options) : base(options)
		{
		}

		public DbSet<Clientes> Clientes { get; set; }
		public DbSet<Produtos> Produtos { get; set; }
		public DbSet<Pedidos> Pedidos { get; set; }
		public DbSet<PedidosItens> PedidosItens { get; set; }
	}
}
