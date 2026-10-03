using MBA_PC_ProductManagement.MbaData;
using MBA_PC_ProductManagement.MbaModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaControllers
{
    public class MbaProductsController : Controller
    {
        private readonly MbaAppDbContext _db;
        private bool MbaIsAdmin => HttpContext.Session.GetString("IsAdmin") == "true";

        public MbaProductsController(MbaAppDbContext db) => _db = db;

        public override void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context)
        {
            if (!MbaIsAdmin)
            {
                context.Result = RedirectToAction("MbaLogin", "MbaAccount", new { returnUrl = "/MbaProducts/MbaIndex" });
                return;
            }
            base.OnActionExecuting(context);
        }

        public IActionResult MbaIndex(string? keyword = null, string? category = null, string? status = null)
        {
            var query = _db.MbaProducts.AsNoTracking();
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                keyword = keyword.Trim();
                query = query.Where(x => x.MbaCode.Contains(keyword) || (x.MbaName ?? "").Contains(keyword));
            }
            if (!string.IsNullOrWhiteSpace(category) && category != "Tất cả") query = query.Where(x => x.MbaCategory == category);
            if (!string.IsNullOrWhiteSpace(status) && status != "Tất cả") query = query.Where(x => x.MbaDataStatus == status);

            ViewBag.Keyword = keyword;
            ViewBag.MbaCategory = category;
            ViewBag.MbaStatus = status;
            ViewBag.MbaCategories = _db.MbaCategories.AsNoTracking().OrderBy(x => x.MbaName).ToList();
            return View(query.OrderBy(x => x.MbaId).ToList());
        }

        [HttpGet] public IActionResult MbaCreate() => View(new MbaProduct());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaCreate(MbaProduct model)
        {
            if (!ModelState.IsValid) return View(model);
            model.MbaCode = string.IsNullOrWhiteSpace(model.MbaCode) ? $"SP{(_db.MbaProducts.Any() ? _db.MbaProducts.Max(x => x.MbaId) + 1 : 1):000}" : model.MbaCode.Trim();
            model.MbaDataStatus = string.IsNullOrWhiteSpace(model.MbaDataStatus) ? "Chờ rà soát" : model.MbaDataStatus;
            model.MbaCategoryId = _db.MbaCategories.Where(x => x.MbaName == model.MbaCategory).Select(x => (int?)x.MbaId).FirstOrDefault();
            _db.MbaProducts.Add(model);
            _db.SaveChanges();
            _db.MbaReviews.Add(new MbaReviewItem { MbaProductId = model.MbaId });
            _db.SaveChanges();
            TempData["ProductMessage"] = $"Đã thêm sản phẩm {model.MbaCode}.";
            return RedirectToAction(nameof(MbaIndex));
        }

        public IActionResult MbaDetails(int id)
        {
            var product = _db.MbaProducts.AsNoTracking().FirstOrDefault(x => x.MbaId == id);
            if (product == null) return NotFound();
            ViewBag.MbaReview = _db.MbaReviews.AsNoTracking().FirstOrDefault(x => x.MbaProductId == id);
            return View(product);
        }

        [HttpGet]
        public IActionResult MbaEdit(int id)
        {
            var product = _db.MbaProducts.Find(id);
            return product == null ? NotFound() : View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaEdit(MbaProduct model)
        {
            var product = _db.MbaProducts.Find(model.MbaId);
            if (product == null) return NotFound();
            if (!ModelState.IsValid) return View(model);

            product.MbaCode = model.MbaCode;
            product.MbaName = model.MbaName;
            product.MbaCategory = model.MbaCategory;
            product.MbaCategoryId = _db.MbaCategories.Where(x => x.MbaName == model.MbaCategory).Select(x => (int?)x.MbaId).FirstOrDefault();
            product.MbaBrand = model.MbaBrand;
            product.MbaPrice = model.MbaPrice;
            product.MbaQuantity = model.MbaQuantity;
            product.MbaTechnicalInfo = model.MbaTechnicalInfo;
            product.MbaDescription = model.MbaDescription;
            product.MbaImageUrl = model.MbaImageUrl;
            product.MbaDataStatus = model.MbaDataStatus;
            _db.SaveChanges();
            TempData["ProductMessage"] = $"Đã cập nhật dữ liệu {product.MbaCode}.";
            return RedirectToAction(nameof(MbaIndex));
        }

        [HttpGet]
        public IActionResult MbaDelete(int id)
        {
            var product = _db.MbaProducts.AsNoTracking().FirstOrDefault(x => x.MbaId == id);
            return product == null ? NotFound() : View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaDeleteConfirmed(int id)
        {
            var product = _db.MbaProducts.Find(id);
            if (product == null) return NotFound();
            _db.MbaProducts.Remove(product);
            _db.SaveChanges();
            TempData["ProductMessage"] = $"Đã xóa sản phẩm {product.MbaCode}.";
            return RedirectToAction(nameof(MbaIndex));
        }
    }
}
