using System;
using System.ComponentModel.DataAnnotations;

namespace LojaVirtual.Models
{
	public class Clientes
	{
		[Display(Name = "Código")]
		public int Id { get; set; }
		[MaxLength(100)]
		[Required]
		public string Nome { get; set; }
		[DisplayFormat(DataFormatString = "{0:000\\.000\\.000-00}")]
		[Required]
		public long CPF { get; set; }
		[MaxLength(50)]
		[Display(Name = "Endereço")]
		public string Endereco { get; set; }
		[MaxLength(10)]
		[Display(Name = "Número")]
		public string Numero { get; set; }
		[MaxLength(50)]
		public string Bairro { get; set; }
		[MaxLength(50)]
		public string Cidade { get; set; }
		[MaxLength(2)]
		[Display(Name = "Estado")]
		public string Estado { get; set; }
		[DisplayFormat(DataFormatString = "{0:00000-000}")]
		[Display(Name = "CEP")]
		[MaxLength(8)]
		public string Cep { get; set; }
		[DisplayFormat(DataFormatString = "{0:(00) 0000-0000}")]
		public long? Telefone { get; set; }
		[DisplayFormat(DataFormatString = "{0:(00) 00000-0000}")]
		public long? Celular { get; set; }
		[MaxLength(100)]
		public string Email { get; set; }
		[Display(Name = "Data de Nascimento")]
		[DisplayFormat(DataFormatString = "{0:d}")]
		public DateTime? DataNasc { get; set; }
	}
}
