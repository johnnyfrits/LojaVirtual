using System.ComponentModel.DataAnnotations;

namespace LojaVirtual.Models
{
	public class PedidosItens
	{
		public int Id { get; set; }
		public int PedidoId { get; set; }
		public int ProdutoId { get; set; }
		public int NroItem { get; set; }

		[DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
		public decimal Preco { get; set; }

		[DisplayFormat(DataFormatString = "{0:N0}", ApplyFormatInEditMode = true)]
		public decimal Quantidade { get; set; }

		[DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
		public decimal Total { get; set; }
		public virtual Pedidos Pedido { get; set; }
		public virtual Produtos Produto { get; set; }
	}
}
