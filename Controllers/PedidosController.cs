using System;
using System.Linq;
using System.Threading.Tasks;
using LojaVirtual.Data;
using LojaVirtual.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace LojaVirtual.Controllers
{
	public class PedidosController : Controller
	{
		private readonly LojaVirtualContext _context;

		public PedidosController(LojaVirtualContext context)
		{
			_context = context;
		}

		// GET: Pedidos
		public async Task<IActionResult> Index()
		{
			var lojaVirtualContext = _context.Pedidos.Include(p => p.Cliente)
													 .Include(p => p.Itens).OrderBy( p=> p.Data)
																		   .OrderBy( p => p.Cliente.Nome);
			return View(await lojaVirtualContext.ToListAsync());
		}

		// GET: Pedidos/Details/5
		public async Task<IActionResult> Details(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidos = await _context.Pedidos
				.Include(p => p.Cliente)
				.Include(p => p.Itens)
				.ThenInclude( i => i.Produto)
				.AsNoTracking()
				.FirstOrDefaultAsync(m => m.Id == id);


			if (pedidos == null)
			{
				return NotFound();
			}

			return View(pedidos);
		}

		public IActionResult IncluirItem(Pedidos pedido, int produtoId, int quantidade)
		{
			var produto = _context.Produtos.FirstOrDefault(p => p.Id == produtoId);

			if (produto != null)
			{
				pedido.Itens.Add(new PedidosItens
				{
					ProdutoId = produtoId,
					Quantidade = quantidade,
					Preco = produto.Preco,
					Total = produto.Preco * quantidade,
					Produto = produto
				});
			}

			return View(pedido);
		}

		// GET: Pedidos/Create
		public IActionResult Create()
		{
			ViewData["Clientes"] = new SelectList(_context.Clientes.OrderBy(c => c.Nome), "Id", "Nome");
			ViewData["Produtos"] = new SelectList(_context.Produtos.OrderBy(c => c.Descricao), "Id", "Descricao");
			return View();
		}

		// POST: Pedidos/Create
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create([Bind("Id,ClienteId,Data")] Pedidos pedido)
		{
			if (ModelState.IsValid)
			{
				pedido.Data = DateTime.Now;

				_context.Add(pedido);

				await _context.SaveChangesAsync();

				return RedirectToAction(nameof(Details), "Pedidos", new { id = pedido.Id });
			}

			ViewData["ClienteId"] = new SelectList(_context.Clientes, "Id", "Nome", pedido.ClienteId);

			return View(pedido);
		}

		// GET: Pedidos/Edit/5
		public async Task<IActionResult> Edit(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidos = await _context.Pedidos.FindAsync(id);
			if (pedidos == null)
			{
				return NotFound();
			}
			ViewData["ClienteId"] = new SelectList(_context.Clientes.OrderBy(c => c.Nome), "Id", "Nome", pedidos.ClienteId);
			return View(pedidos);
		}

		// POST: Pedidos/Edit/5
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(int id, [Bind("Id,ClienteId,Data")] Pedidos pedidos)
		{
			if (id != pedidos.Id)
			{
				return NotFound();
			}

			if (ModelState.IsValid)
			{
				try
				{
					_context.Update(pedidos);
					await _context.SaveChangesAsync();
				}
				catch (DbUpdateConcurrencyException)
				{
					if (!PedidosExists(pedidos.Id))
					{
						return NotFound();
					}
					else
					{
						throw;
					}
				}
				return RedirectToAction(nameof(Index));
			}
			ViewData["ClienteId"] = new SelectList(_context.Clientes, "Id", "Id", pedidos.ClienteId);
			return View(pedidos);
		}

		// GET: Pedidos/Delete/5
		public async Task<IActionResult> Delete(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var pedidos = await _context.Pedidos
				.Include(p => p.Cliente)
				.FirstOrDefaultAsync(m => m.Id == id);
			if (pedidos == null)
			{
				return NotFound();
			}

			return View(pedidos);
		}

		// POST: Pedidos/Delete/5
		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> DeleteConfirmed(int id)
		{
			var pedidos = await _context.Pedidos.FindAsync(id);
			_context.Pedidos.Remove(pedidos);
			await _context.SaveChangesAsync();
			return RedirectToAction(nameof(Index));
		}

		private bool PedidosExists(int id)
		{
			return _context.Pedidos.Any(e => e.Id == id);
		}
	}
}
