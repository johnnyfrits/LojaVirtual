using System.Linq;
using System.Threading.Tasks;
using LojaVirtual.Data;
using LojaVirtual.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace LojaVirtual.Controllers
{
	public class PedidosItensController : Controller
	{
		private readonly LojaVirtualContext _context;

		public PedidosItensController(LojaVirtualContext context)
		{
			_context = context;
		}

		// GET: PedidosItens
		public async Task<IActionResult> Index()
		{
			var lojaVirtualContext = _context.PedidosItens.Include(p => p.Pedido).Include(p => p.Produto);
			return View(await lojaVirtualContext.ToListAsync());
		}

		// GET: PedidosItens/Details/5
		public async Task<IActionResult> Details(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidosItens = await _context.PedidosItens
				.Include(p => p.Pedido)
				.Include(p => p.Produto)
				.FirstOrDefaultAsync(m => m.Id == id);
			if (pedidosItens == null)
			{
				return NotFound();
			}

			return View(pedidosItens);
		}

		// GET: PedidosItens/Create
		public IActionResult Create(int id)
		{
			var pedidosItens = new PedidosItens { PedidoId = id};

			ViewData["ProdutoId"] = new SelectList(_context.Produtos.OrderBy(o => o.Descricao), "Id", "Descricao");

			return View(pedidosItens);
		}

		// POST: PedidosItens/Create
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create([Bind("PedidoId,ProdutoId,NroItem,Preco,Quantidade,Total")] PedidosItens pedidosItens)
		{
			if (ModelState.IsValid)
			{
				_context.Add(pedidosItens);

				await _context.SaveChangesAsync();

				return RedirectToAction(nameof(Details), "Pedidos", new { id = pedidosItens.PedidoId });
			}

			ViewData["PedidoId"] = new SelectList(_context.Pedidos, "Id", "Id", pedidosItens.PedidoId);
			ViewData["ProdutoId"] = new SelectList(_context.Produtos, "Id", "Id", pedidosItens.ProdutoId);

			return View(pedidosItens);
		}

		// GET: PedidosItens/Edit/5
		public async Task<IActionResult> Edit(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidosItens = await _context.PedidosItens.FirstOrDefaultAsync(m => m.Id == id);

			if (pedidosItens == null)
			{
				return NotFound();
			}

			ViewData["ProdutoId"] = new SelectList(_context.Produtos.OrderBy(o => o.Descricao), "Id", "Descricao");

			return View(pedidosItens);
		}

		// POST: PedidosItens/Edit/5
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(int id, [Bind("Id,PedidoId,ProdutoId,NroItem,Preco,Quantidade,Total")] PedidosItens pedidosItens)
		{
			if (id != pedidosItens.Id)
			{
				return NotFound();
			}

			if (ModelState.IsValid)
			{
				try
				{
					_context.Update(pedidosItens);

					await _context.SaveChangesAsync();
				}
				catch (DbUpdateConcurrencyException)
				{
					if (!PedidosItensExists(pedidosItens.Id))
					{
						return NotFound();
					}
					else
					{
						throw;
					}
				}

				return RedirectToAction(nameof(Details), "Pedidos", new { id = pedidosItens.PedidoId });
			}

			ViewData["ProdutoId"] = new SelectList(_context.Produtos, "Id", "Nome", pedidosItens.ProdutoId);

			return View(pedidosItens);
		}

		// GET: PedidosItens/Delete/5
		public async Task<IActionResult> Delete(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidosItens = await _context.PedidosItens
				.Include(p => p.Pedido)
				.Include(p => p.Produto)
				.FirstOrDefaultAsync(m => m.Id == id);

			if (pedidosItens == null)
			{
				return NotFound();
			}

			return View(pedidosItens);
		}

		// POST: PedidosItens/Delete/5
		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> DeleteConfirmed(int id)
		{
			var pedidosItens = await _context.PedidosItens.FindAsync(id);

			_context.PedidosItens.Remove(pedidosItens);

			await _context.SaveChangesAsync();

			return RedirectToAction(nameof(Details), "Pedidos", new { id = pedidosItens.PedidoId });
		}

		private bool PedidosItensExists(int id)
		{
			return _context.PedidosItens.Any(e => e.Id == id);
		}

		public decimal GetPreco(int produtoId)
		{
			var produto = _context.Produtos.Find(produtoId);

			return produto != null ? produto.Preco : 0;
		}
	}
}
