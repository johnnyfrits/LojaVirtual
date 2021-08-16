using System.ComponentModel.DataAnnotations;


namespace LojaVirtual.Models
{
	public class Produtos
	{
		[Display(Name = "Código")]
		public int Id { get; set; }
		[Required]
		[Display(Name = "Descrição")]
		[MaxLength(100)]
		public string Descricao { get; set; }
		[DisplayFormat(DataFormatString = "{0:N2}", ApplyFormatInEditMode = true)]
		[Required]
		[Display(Name = "Preço")]
		public decimal Preco { get; set; }
	}
}
