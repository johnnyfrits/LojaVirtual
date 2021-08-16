using System.Linq;
using System.Threading.Tasks;
using LojaVirtual.Data;
using LojaVirtual.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LojaVirtual.Controllers
{
	public class ProdutosController : Controller
	{
		private readonly LojaVirtualContext _context;

		public ProdutosController(LojaVirtualContext context)
		{
			_context = context;
		}

		// GET: Produtos
		public async Task<IActionResult> Index()
		{
			return View(await _context.Produtos.OrderBy(o => o.Descricao).ToListAsync());
		}

		// GET: Produtos/Details/5
		public async Task<IActionResult> Details(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var produtos = await _context.Produtos
				.FirstOrDefaultAsync(m => m.Id == id);
			if (produtos == null)
			{
				return NotFound();
			}

			return View(produtos);
		}

		// GET: Produtos/Create
		public IActionResult Create()
		{
			return View();
		}

		// POST: Produtos/Create
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create([Bind("Id,Descricao,Preco")] Produtos produtos)
		{
			if (ModelState.IsValid)
			{
				_context.Add(produtos);
				await _context.SaveChangesAsync();
				return RedirectToAction(nameof(Index));
			}
			return View(produtos);
		}

		// GET: Produtos/Edit/5
		public async Task<IActionResult> Edit(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var produtos = await _context.Produtos.FindAsync(id);

			if (produtos == null)
			{
				return NotFound();
			}

			return View(produtos);
		}

		// POST: Produtos/Edit/5
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(int id, [Bind("Id,Descricao,Preco")] Produtos produtos)
		{
			if (id != produtos.Id)
			{
				return NotFound();
			}

			if (ModelState.IsValid)
			{
				try
				{
					_context.Update(produtos);
					await _context.SaveChangesAsync();
				}
				catch (DbUpdateConcurrencyException)
				{
					if (!ProdutosExists(produtos.Id))
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
			return View(produtos);
		}

		// GET: Produtos/Delete/5
		public async Task<IActionResult> Delete(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var produtos = await _context.Produtos
				.FirstOrDefaultAsync(m => m.Id == id);
			if (produtos == null)
			{
				return NotFound();
			}

			return View(produtos);
		}

		// POST: Produtos/Delete/5
		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> DeleteConfirmed(int id)
		{
			var produtos = await _context.Produtos.FindAsync(id);
			_context.Produtos.Remove(produtos);
			await _context.SaveChangesAsync();
			return RedirectToAction(nameof(Index));
		}

		private bool ProdutosExists(int id)
		{
			return _context.Produtos.Any(e => e.Id == id);
		}
	}
}
