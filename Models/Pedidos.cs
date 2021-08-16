using System;
using System.Collections.Generic;

namespace LojaVirtual.Models
{
	public class Pedidos
	{
		public Pedidos()
		{
			Itens = new List<PedidosItens>();
		}

		public int Id { get; set; }
		public int ClienteId { get; set; }
		public DateTime Data { get; set; }
		public Clientes Cliente { get; set; }
		public ICollection<PedidosItens> Itens { get; set; }
	}
}
