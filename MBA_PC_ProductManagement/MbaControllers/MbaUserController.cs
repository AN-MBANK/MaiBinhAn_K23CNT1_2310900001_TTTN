using MBA_PC_ProductManagement.MbaData;
using MBA_PC_ProductManagement.MbaModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaControllers
{
    public class MbaUserController : Controller
    {
        private readonly MbaAppDbContext _db;
        private readonly IWebHostEnvironment _environment;
        private bool IsEmployee => HttpContext.Session.GetString("IsEmployee") == "true";
        private int? CurrentEmployeeId => HttpContext.Session.GetInt32("MbaEmployeeId");

        public MbaUserController(MbaAppDbContext db, IWebHostEnvironment environment)
        {
            _db = db;
            _environment = environment;
        }

        public override void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context)
        {
            if (!IsEmployee && context.ActionDescriptor.RouteValues["action"] != "MbaIndex")
            {
                context.Result = RedirectToAction("MbaLogin", "MbaAccount", new { returnUrl = "/MbaUser/MbaIndex" });
                return;
            }
            base.OnActionExecuting(context);
        }

        public IActionResult MbaIndex()
        {
            var employeeId = CurrentEmployeeId;
            var query = _db.MbaReviews.AsNoTracking();
            if (employeeId.HasValue) query = query.Where(x => x.MbaEmployeeId == employeeId.Value);
            ViewBag.Pending = query.Count(x => x.MbaStatus == "Chờ rà soát");
            ViewBag.Working = query.Count(x => x.MbaStatus == "Đang xử lý");
            ViewBag.Completed = query.Count(x => x.MbaStatus == "Đã hoàn tất");
            return View();
        }

        public IActionResult MbaAssignments()
        {
            MbaReviewDeadlineService.MbaCloseExpiredReviewsAsync(_db).GetAwaiter().GetResult();
            var employeeId = CurrentEmployeeId;
            if (!employeeId.HasValue) return Forbid();
            var reviews = _db.MbaReviews.AsNoTracking().Where(x => x.MbaEmployeeId == employeeId.Value).OrderBy(x => x.MbaDeadline).ThenBy(x => x.MbaId).ToList();
            var productIds = reviews.Select(x => x.MbaProductId).ToList();
            var products = _db.MbaProducts.AsNoTracking().Where(x => productIds.Contains(x.MbaId)).ToDictionary(x => x.MbaId);
            var rows = reviews.Select((r, i) => new MbaEmployeeAssignmentRow
            {
                ReviewId = r.MbaId,
                MbaProductId = r.MbaProductId,
                Position = i + 1,
                ProductCode = products.TryGetValue(r.MbaProductId, out var p) ? p.MbaCode : "—",
                ProductName = products.TryGetValue(r.MbaProductId, out p) ? p.MbaName : "Sản phẩm không tồn tại",
                MbaCategory = products.TryGetValue(r.MbaProductId, out p) ? p.MbaCategory : "—",
                MbaStatus = r.MbaStatus,
                MbaCheckedItems = r.MbaCheckedItems,
                MbaTotalItems = r.MbaTotalItems,
                MbaDeadline = r.MbaDeadline,
                MbaIsLocked = r.MbaIsLocked,
                MbaClosedAt = r.MbaClosedAt
            }).ToList();
            ViewBag.Total = rows.Count;
            ViewBag.Completed = rows.Count(x => x.MbaStatus == "Đã hoàn tất");
            ViewBag.Open = rows.Count(x => !x.MbaIsLocked && x.MbaStatus != "Đã hoàn tất");
            ViewBag.Overdue = rows.Count(x => x.MbaIsLocked && x.MbaStatus == "Đã chốt quá hạn");
            ViewBag.NearestDeadline = rows.Where(x => !x.MbaIsLocked && x.MbaDeadline.HasValue).OrderBy(x => x.MbaDeadline).Select(x => x.MbaDeadline).FirstOrDefault();
            return View(rows);
        }

        public IActionResult MbaReview(string? status = null, string? keyword = null)
        {
            var query = from r in _db.MbaReviews.AsNoTracking()
                        join p in _db.MbaProducts.AsNoTracking() on r.MbaProductId equals p.MbaId
                        select new MbaReviewRow { MbaReview = r, MbaProduct = p };
            if (CurrentEmployeeId.HasValue) query = query.Where(x => x.MbaReview.MbaEmployeeId == CurrentEmployeeId.Value);

            if (!string.IsNullOrWhiteSpace(status) && status != "Tất cả") query = query.Where(x => x.MbaReview.MbaStatus == status);
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                keyword = keyword.Trim();
                query = query.Where(x => x.MbaProduct.MbaCode.Contains(keyword) || (x.MbaProduct.MbaName ?? "").Contains(keyword));
            }

            ViewBag.MbaStatus = status;
            ViewBag.Keyword = keyword;
            var employeeId = CurrentEmployeeId;
            var myReviews = employeeId.HasValue ? _db.MbaReviews.Where(x => x.MbaEmployeeId == employeeId.Value) : _db.MbaReviews.Where(x => false);
            ViewBag.Pending = myReviews.Count(x => x.MbaStatus == "Chờ rà soát");
            ViewBag.Working = myReviews.Count(x => x.MbaStatus == "Đang xử lý");
            ViewBag.Completed = myReviews.Count(x => x.MbaStatus == "Đã hoàn tất");
            ViewBag.Invalid = myReviews.Count(x => x.MbaStatus == "Cần báo lại" || x.MbaStatus == "Đã chốt quá hạn");
            return View(query.OrderBy(x => x.MbaReview.MbaDeadline).ThenBy(x => x.MbaReview.MbaId).ToList());
        }

        [HttpGet]
        public IActionResult MbaEditData(int id = 1)
        {
            var review = _db.MbaReviews.Include(x => x.MbaEmployee).FirstOrDefault(x => x.MbaId == id);
            if (review == null)
            {
                var product = _db.MbaProducts.FirstOrDefault(x => x.MbaId == id);
                if (product == null) return NotFound();
                review = new MbaReviewItem { MbaProductId = product.MbaId };
                _db.MbaReviews.Add(review);
                _db.SaveChanges();
            }

            var currentProduct = _db.MbaProducts.Find(review.MbaProductId);
            if (currentProduct == null) return NotFound();
            if (review.MbaEmployeeId.HasValue && CurrentEmployeeId.HasValue && review.MbaEmployeeId.Value != CurrentEmployeeId.Value)
                return Forbid();
            if (review.MbaDeadline.HasValue && review.MbaDeadline.Value <= DateTime.Now && !review.MbaIsLocked)
            {
                review.MbaIsLocked = true;
                review.MbaIsOverdue = review.MbaStatus != "Đã hoàn tất";
                review.MbaClosedAt = DateTime.Now;
                if (review.MbaStatus != "Đã hoàn tất") review.MbaStatus = "Đã chốt quá hạn";
                _db.SaveChanges();
            }
            if (review.MbaIsLocked)
            {
                TempData["ReviewMessage"] = review.MbaIsOverdue ? "Phiếu đã hết hạn và đã được hệ thống tự động chốt. Bạn không thể chỉnh sửa thêm." : "Phiếu đã được hệ thống chốt và không thể chỉnh sửa thêm.";
                return RedirectToAction(nameof(MbaAssignments));
            }
            if (review.MbaStatus == "Chờ rà soát") review.MbaStatus = "Đang xử lý";
            review.MbaEmployeeId ??= CurrentEmployeeId;
            _db.SaveChanges();

            return View(new MbaReviewEditViewModel { MbaReview = review, MbaProduct = currentProduct, CheckedCount = review.MbaCheckedItems });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaEditData(MbaReviewEditViewModel model, string actionType)
        {
            var product = _db.MbaProducts.Find(model.MbaProduct.MbaId);
            var review = _db.MbaReviews.Find(model.MbaReview.MbaId);
            if (product == null || review == null) return NotFound();
            if (review.MbaEmployeeId.HasValue && CurrentEmployeeId.HasValue && review.MbaEmployeeId.Value != CurrentEmployeeId.Value)
                return Forbid();
            if (review.MbaIsLocked || (review.MbaDeadline.HasValue && review.MbaDeadline.Value <= DateTime.Now))
            {
                review.MbaIsLocked = true;
                review.MbaIsOverdue = review.MbaStatus != "Đã hoàn tất";
                review.MbaClosedAt ??= DateTime.Now;
                if (review.MbaStatus != "Đã hoàn tất") review.MbaStatus = "Đã chốt quá hạn";
                _db.SaveChanges();
                TempData["ReviewMessage"] = "Phiếu đã hết hạn và được hệ thống tự động chốt. Không thể cập nhật sau thời hạn.";
                return RedirectToAction(nameof(MbaAssignments));
            }
            review.MbaEmployeeId ??= CurrentEmployeeId;

            product.MbaCode = model.MbaProduct.MbaCode;
            product.MbaName = model.MbaProduct.MbaName;
            product.MbaCategory = model.MbaProduct.MbaCategory;
            product.MbaCategoryId = _db.MbaCategories.Where(x => x.MbaName == model.MbaProduct.MbaCategory).Select(x => (int?)x.MbaId).FirstOrDefault();
            product.MbaBrand = model.MbaProduct.MbaBrand;
            product.MbaPrice = model.MbaProduct.MbaPrice;
            product.MbaQuantity = model.MbaProduct.MbaQuantity;
            product.MbaTechnicalInfo = model.MbaProduct.MbaTechnicalInfo;
            product.MbaDescription = model.MbaProduct.MbaDescription;
            product.MbaDataStatus = model.MbaProduct.MbaDataStatus;

            review.MbaReviewNote = model.MbaReview.MbaReviewNote;
            review.MbaCheckedItems = model.CheckedCount;
            if (review.MbaIsLocked)
            {
                TempData["ReviewMessage"] = "Phiếu đã bị khóa do hết thời hạn.";
                return RedirectToAction(nameof(MbaAssignments));
            }
            if (actionType == "complete")
            {
                review.MbaStatus = "Đã hoàn tất";
                review.MbaCheckedItems = review.MbaTotalItems;
                product.MbaDataStatus = "Đã chuẩn hóa";
                TempData["ReviewMessage"] = $"Đã hoàn tất phiếu {product.MbaCode}.";
            }
            else if (actionType == "invalid")
            {
                review.MbaStatus = "Cần báo lại";
                product.MbaDataStatus = "Cần báo lại";
                TempData["ReviewMessage"] = $"Đã đánh dấu phiếu {product.MbaCode} cần báo lại quản lý.";
            }
            else
            {
                review.MbaStatus = "Đang xử lý";
                product.MbaDataStatus = "Đang kiểm tra";
                TempData["ReviewMessage"] = $"Đã lưu dữ liệu đang xử lý của {product.MbaCode}.";
            }

            _db.SaveChanges();
            return RedirectToAction(nameof(MbaReview));
        }

        public IActionResult MbaProducts() => RedirectToAction(nameof(MbaReview));
        public IActionResult MbaCategories() => View(_db.MbaCategories.AsNoTracking().Where(x => x.MbaIsActive).OrderBy(x => x.MbaName).ToList());
        public IActionResult MbaAbout() => View();

        public IActionResult MbaDetails(int id = 1)
        {
            var product = _db.MbaProducts.AsNoTracking().FirstOrDefault(x => x.MbaId == id);
            return product == null ? NotFound() : View(product);
        }

        public IActionResult MbaProfile()
        {
            var employee = CurrentEmployeeId.HasValue
                ? _db.MbaEmployees.AsNoTracking().Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == CurrentEmployeeId.Value)
                : null;
            ViewBag.UserName = employee?.MbaAccount.MbaUsername ?? "employee";
            ViewBag.DisplayName = employee?.MbaFullName ?? "Nhân viên";
            ViewBag.UserRole = "Employee";
            ViewBag.MbaEmail = employee?.MbaEmail;
            ViewBag.MbaPhone = employee?.MbaPhone;
            ViewBag.MbaAvatarUrl = employee?.MbaAvatarUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MbaUploadAvatar(IFormFile? avatar)
        {
            if (!CurrentEmployeeId.HasValue) return Forbid();
            if (avatar == null || avatar.Length == 0)
            {
                TempData["ProfileMessage"] = "Vui lòng chọn một ảnh đại diện.";
                return RedirectToAction(nameof(MbaProfile));
            }

            const long maxBytes = 2 * 1024 * 1024;
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".webp" };
            var extension = Path.GetExtension(avatar.FileName).ToLowerInvariant();
            if (!allowedExtensions.Contains(extension) || avatar.Length > maxBytes)
            {
                TempData["ProfileMessage"] = "Ảnh phải có định dạng JPG, JPEG, PNG hoặc WEBP và dung lượng không quá 2 MB.";
                return RedirectToAction(nameof(MbaProfile));
            }

            var employee = await _db.MbaEmployees.FirstOrDefaultAsync(x => x.MbaId == CurrentEmployeeId.Value);
            if (employee == null) return NotFound();

            var avatarFolder = Path.Combine(_environment.WebRootPath ?? Path.Combine(_environment.ContentRootPath, "wwwroot"), "uploads", "avatars");
            Directory.CreateDirectory(avatarFolder);
            var fileName = $"employee_{employee.MbaId}_{Guid.NewGuid():N}{extension}";
            var filePath = Path.Combine(avatarFolder, fileName);
            await using (var stream = new FileStream(filePath, FileMode.CreateNew))
            {
                await avatar.CopyToAsync(stream);
            }

            var oldAvatar = employee.MbaAvatarUrl;
            employee.MbaAvatarUrl = $"/uploads/avatars/{fileName}";
            await _db.SaveChangesAsync();

            HttpContext.Session.SetString("MbaAvatarUrl", employee.MbaAvatarUrl);
            HttpContext.Session.SetString("DisplayName", employee.MbaFullName);

            if (!string.IsNullOrWhiteSpace(oldAvatar) && oldAvatar.StartsWith("/uploads/avatars/", StringComparison.OrdinalIgnoreCase))
            {
                var oldFileName = Path.GetFileName(oldAvatar);
                var oldPath = Path.Combine(avatarFolder, oldFileName);
                if (System.IO.File.Exists(oldPath))
                    System.IO.File.Delete(oldPath);
            }

            TempData["ProfileMessage"] = "Đã cập nhật ảnh đại diện.";
            return RedirectToAction(nameof(MbaProfile));
        }
    }

    public class MbaReviewRow
    {
        public MbaReviewItem MbaReview { get; set; } = new();
        public MbaProduct MbaProduct { get; set; } = new();
    }

    public class MbaReviewEditViewModel
    {
        public MbaProduct MbaProduct { get; set; } = new();
        public MbaReviewItem MbaReview { get; set; } = new();
        public int CheckedCount { get; set; }
    }
}
