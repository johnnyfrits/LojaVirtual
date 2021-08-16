using System.Linq;
using System.Threading.Tasks;
using LojaVirtual.Data;
using LojaVirtual.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LojaVirtual.Controllers
{
	public class ClientesController : Controller
	{
		private readonly LojaVirtualContext _context;

		public ClientesController(LojaVirtualContext context)
		{
			_context = context;
		}

		// GET: Clientes
		public async Task<IActionResult> Index()
		{
			return View(await _context.Clientes.ToListAsync());
		}

		// GET: Clientes/Details/5
		public async Task<IActionResult> Details(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var clientes = await _context.Clientes
				.FirstOrDefaultAsync(m => m.Id == id);
			if (clientes == null)
			{
				return NotFound();
			}

			return View(clientes);
		}

		// GET: Clientes/Create
		public IActionResult Create()
		{
			return View();
		}

		// POST: Clientes/Create
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create([Bind("Id,Nome,CPF,Endereco,Numero,Bairro,Cidade,Estado,Cep,Telefone,Celular,Email,DataNasc")] Clientes clientes)
		{
			if (ModelState.IsValid)
			{
				_context.Add(clientes);
				await _context.SaveChangesAsync();
				return RedirectToAction(nameof(Index));
			}
			return View(clientes);
		}

		// GET: Clientes/Edit/5
		public async Task<IActionResult> Edit(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var clientes = await _context.Clientes.FindAsync(id);
			
			if (clientes == null)
			{
				return NotFound();
			}
			return View(clientes);
		}

		// POST: Clientes/Edit/5
		// To protect from overposting attacks, enable the specific properties you want to bind to.
		// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(int id, [Bind("Id,Nome,CPF,Endereco,Numero,Bairro,Cidade,Estado,Cep,Telefone,Celular,Email,DataNasc")] Clientes clientes)
		{
			if (id != clientes.Id)
			{
				return NotFound();
			}

			if (ModelState.IsValid)
			{
				try
				{
					_context.Update(clientes);
					await _context.SaveChangesAsync();
				}
				catch (DbUpdateConcurrencyException)
				{
					if (!ClientesExists(clientes.Id))
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
			return View(clientes);
		}

		// GET: Clientes/Delete/5
		public async Task<IActionResult> Delete(int? id)
		{
			if (id == null)
			{
				return NotFound();
			}

			var clientes = await _context.Clientes
				.FirstOrDefaultAsync(m => m.Id == id);
			if (clientes == null)
			{
				return NotFound();
			}

			return View(clientes);
		}

		// POST: Clientes/Delete/5
		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> DeleteConfirmed(int id)
		{
			var clientes = await _context.Clientes.FindAsync(id);
			_context.Clientes.Remove(clientes);
			await _context.SaveChangesAsync();
			return RedirectToAction(nameof(Index));
		}

		private bool ClientesExists(int id)
		{
			return _context.Clientes.Any(e => e.Id == id);
		}
	}
}
