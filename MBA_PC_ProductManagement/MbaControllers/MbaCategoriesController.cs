using MBA_PC_ProductManagement.MbaData;
using MBA_PC_ProductManagement.MbaModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaControllers
{
    public class MbaCategoriesController : Controller
    {
        private readonly MbaAppDbContext _db;
        private bool MbaIsAdmin => HttpContext.Session.GetString("IsAdmin") == "true";

        public MbaCategoriesController(MbaAppDbContext db) => _db = db;

        public override void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context)
        {
            if (!MbaIsAdmin)
            {
                context.Result = RedirectToAction("MbaLogin", "MbaAccount", new { returnUrl = "/MbaCategories/MbaIndex" });
                return;
            }
            base.OnActionExecuting(context);
        }

        public IActionResult MbaIndex()
        {
            var categories = _db.MbaCategories.AsNoTracking().OrderBy(x => x.MbaId).ToList();
            ViewBag.TotalProducts = _db.MbaProducts.Count();
            ViewBag.UsedCategories = categories.Count(c => _db.MbaProducts.Any(p => p.MbaCategory == c.MbaName));
            ViewBag.ProductCounts = categories.ToDictionary(c => c.MbaId, c => _db.MbaProducts.Count(p => p.MbaCategory == c.MbaName));
            return View(categories);
        }

        [HttpGet] public IActionResult MbaCreate() => View(new MbaCategoryItem());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaCreate(MbaCategoryItem model)
        {
            if (!ModelState.IsValid) return View(model);
            if (string.IsNullOrWhiteSpace(model.MbaCode)) model.MbaCode = $"DM{(_db.MbaCategories.Any() ? _db.MbaCategories.Max(x => x.MbaId) + 1 : 1):000}";
            _db.MbaCategories.Add(model);
            _db.SaveChanges();
            TempData["CategoryMessage"] = $"Đã thêm danh mục {model.MbaName}.";
            return RedirectToAction(nameof(MbaIndex));
        }

        public IActionResult MbaDetails(int id)
        {
            var category = _db.MbaCategories.AsNoTracking().FirstOrDefault(x => x.MbaId == id);
            if (category == null) return NotFound();
            ViewBag.ProductCount = _db.MbaProducts.Count(x => x.MbaCategory == category.MbaName);
            return View(category);
        }

        [HttpGet]
        public IActionResult MbaEdit(int id)
        {
            var category = _db.MbaCategories.Find(id);
            return category == null ? NotFound() : View(category);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaEdit(MbaCategoryItem model)
        {
            var category = _db.MbaCategories.Find(model.MbaId);
            if (category == null) return NotFound();
            if (!ModelState.IsValid) return View(model);

            var oldName = category.MbaName;
            category.MbaCode = model.MbaCode;
            category.MbaName = model.MbaName;
            category.MbaDescription = model.MbaDescription;
            category.MbaIsActive = model.MbaIsActive;

            if (!string.Equals(oldName, category.MbaName, StringComparison.Ordinal))
            {
                var products = _db.MbaProducts.Where(x => x.MbaCategory == oldName).ToList();
                foreach (var product in products)
                {
                    product.MbaCategory = category.MbaName;
                    product.MbaCategoryId = category.MbaId;
                }
            }

            _db.SaveChanges();
            TempData["CategoryMessage"] = $"Đã cập nhật danh mục {category.MbaName}.";
            return RedirectToAction(nameof(MbaIndex));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaDelete(int id)
        {
            var category = _db.MbaCategories.Find(id);
            if (category == null) return NotFound();

            if (_db.MbaProducts.Any(x => x.MbaCategory == category.MbaName))
            {
                TempData["CategoryMessage"] = $"Không thể xóa {category.MbaName} vì vẫn còn sản phẩm thuộc danh mục.";
                return RedirectToAction(nameof(MbaIndex));
            }

            _db.MbaCategories.Remove(category);
            _db.SaveChanges();
            TempData["CategoryMessage"] = $"Đã xóa danh mục {category.MbaName}.";
            return RedirectToAction(nameof(MbaIndex));
        }
    }
}
