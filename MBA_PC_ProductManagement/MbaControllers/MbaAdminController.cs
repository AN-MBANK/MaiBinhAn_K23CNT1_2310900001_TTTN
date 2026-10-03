using MBA_PC_ProductManagement.MbaData;
using MBA_PC_ProductManagement.MbaModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace MBA_PC_ProductManagement.MbaControllers
{
    public class MbaAdminController : Controller
    {
        private readonly MbaAppDbContext _db;
        private readonly IWebHostEnvironment _environment;
        private bool MbaIsAdmin => HttpContext.Session.GetString("IsAdmin") == "true";

        public MbaAdminController(MbaAppDbContext db, IWebHostEnvironment environment)
        {
            _db = db;
            _environment = environment;
        }

        public override void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context)
        {
            if (!MbaIsAdmin && context.ActionDescriptor.RouteValues["action"] != "MbaError")
            {
                context.Result = RedirectToAction("MbaLogin", "MbaAccount", new { returnUrl = "/MbaAdmin/MbaIndex" });
                return;
            }
            base.OnActionExecuting(context);
        }

        public IActionResult MbaIndex()
        {
            var products = _db.MbaProducts.AsNoTracking().ToList();
            var reviews = _db.MbaReviews.AsNoTracking().ToList();

            ViewBag.ProductCount = products.Count;
            ViewBag.CategoryCount = _db.MbaCategories.Count();
            ViewBag.PendingCount = reviews.Count(x => x.MbaStatus == "Chờ rà soát");
            ViewBag.ReviewingCount = reviews.Count(x => x.MbaStatus == "Đang xử lý");
            ViewBag.CompletedCount = reviews.Count(x => x.MbaStatus == "Đã hoàn tất");
            ViewBag.InvalidCount = reviews.Count(x => x.MbaStatus == "Cần báo lại");
            ViewBag.TotalReviews = reviews.Count;
            ViewBag.CompletedPercent = reviews.Count == 0 ? 0 : (int)Math.Round(reviews.Count(x => x.MbaStatus == "Đã hoàn tất") * 100.0 / reviews.Count);

            var productMap = products.ToDictionary(x => x.MbaId);
            ViewBag.AttentionRows = reviews
                .Where(x => x.MbaStatus != "Đã hoàn tất")
                .Select(r => new MbaAdminCheckRow
                {
                    MbaReview = r,
                    MbaProduct = productMap.TryGetValue(r.MbaProductId, out var p) ? p : new MbaProduct()
                })
                .Take(5)
                .ToList();

            return View(products);
        }

        public IActionResult MbaPrivacy() => View();

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult MbaError() => View(new MbaErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });

        public IActionResult MbaProfile()
        {
            var adminId = HttpContext.Session.GetInt32("AdminId");
            var admin = adminId.HasValue ? _db.MbaAdmins.AsNoTracking().Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == adminId.Value) : null;
            ViewBag.UserName = admin?.MbaAccount.MbaUsername ?? "admin";
            ViewBag.DisplayName = admin?.MbaFullName ?? "Quản trị viên";
            ViewBag.UserRole = "Admin";
            ViewBag.MbaEmail = admin?.MbaEmail;
            ViewBag.MbaPhone = admin?.MbaPhone;
            ViewBag.MbaAvatarUrl = admin?.MbaAvatarUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MbaUploadAvatar(IFormFile? avatar)
        {
            var adminId = HttpContext.Session.GetInt32("AdminId");
            if (!adminId.HasValue) return Forbid();
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

            var admin = await _db.MbaAdmins.FirstOrDefaultAsync(x => x.MbaId == adminId.Value);
            if (admin == null) return NotFound();

            var avatarFolder = Path.Combine(
                _environment.WebRootPath ?? Path.Combine(_environment.ContentRootPath, "wwwroot"),
                "uploads", "avatars");
            Directory.CreateDirectory(avatarFolder);
            var fileName = $"admin_{admin.MbaId}_{Guid.NewGuid():N}{extension}";
            var filePath = Path.Combine(avatarFolder, fileName);
            await using (var stream = new FileStream(filePath, FileMode.CreateNew))
            {
                await avatar.CopyToAsync(stream);
            }

            var oldAvatar = admin.MbaAvatarUrl;
            admin.MbaAvatarUrl = $"/uploads/avatars/{fileName}";
            await _db.SaveChangesAsync();
            HttpContext.Session.SetString("MbaAvatarUrl", admin.MbaAvatarUrl);
            HttpContext.Session.SetString("DisplayName", admin.MbaFullName);

            if (!string.IsNullOrWhiteSpace(oldAvatar) && oldAvatar.StartsWith("/uploads/avatars/", StringComparison.OrdinalIgnoreCase))
            {
                var oldFileName = Path.GetFileName(oldAvatar);
                var oldPath = Path.Combine(avatarFolder, oldFileName);
                if (System.IO.File.Exists(oldPath)) System.IO.File.Delete(oldPath);
            }

            TempData["ProfileMessage"] = "Đã cập nhật ảnh đại diện quản trị viên.";
            return RedirectToAction(nameof(MbaProfile));
        }

        public IActionResult MbaEmployees()
        {
            var employees = _db.MbaEmployees.AsNoTracking().Include(x => x.MbaAccount).OrderBy(x => x.MbaId).ToList();
            return View(employees);
        }

        [HttpGet]
        public IActionResult MbaCreateEmployee() => View(new MbaEmployeeCreateViewModel());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaCreateEmployee(MbaEmployeeCreateViewModel model)
        {
            if (string.IsNullOrWhiteSpace(model.MbaUsername) || string.IsNullOrWhiteSpace(model.Password) || string.IsNullOrWhiteSpace(model.MbaFullName))
            {
                ModelState.AddModelError(string.Empty, "Vui lòng nhập đầy đủ tài khoản, mật khẩu và họ tên.");
            }
            if (_db.MbaAccounts.Any(x => x.MbaUsername == model.MbaUsername.Trim()))
                ModelState.AddModelError(nameof(model.MbaUsername), "Tên tài khoản đã tồn tại.");
            if (!ModelState.IsValid) return View(model);

            var account = new MbaAccount
            {
                MbaUsername = model.MbaUsername.Trim(),
                MbaPasswordHash = MbaPasswordService.MbaHash(model.Password),
                MbaRole = "Employee",
                MbaIsActive = true
            };
            _db.MbaAccounts.Add(account);
            _db.SaveChanges();
            _db.MbaEmployees.Add(new MbaEmployee
            {
                MbaAccountId = account.MbaId,
                MbaFullName = model.MbaFullName.Trim(),
                MbaEmail = model.MbaEmail?.Trim(),
                MbaPhone = model.MbaPhone?.Trim(),
                MbaIsActive = true
            });
            _db.SaveChanges();
            TempData["EmployeeMessage"] = $"Đã tạo tài khoản nhân viên {account.MbaUsername}.";
            return RedirectToAction(nameof(MbaEmployees));
        }

        [HttpGet]
        public IActionResult MbaEditEmployee(int id)
        {
            var employee = _db.MbaEmployees.AsNoTracking().Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == id);
            if (employee == null) return NotFound();

            return View(new MbaEmployeeEditViewModel
            {
                MbaId = employee.MbaId,
                MbaAccountId = employee.MbaAccountId,
                MbaUsername = employee.MbaAccount.MbaUsername,
                MbaFullName = employee.MbaFullName,
                MbaEmail = employee.MbaEmail,
                MbaPhone = employee.MbaPhone,
                MbaAvatarUrl = employee.MbaAvatarUrl
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaEditEmployee(MbaEmployeeEditViewModel model)
        {
            var employee = _db.MbaEmployees.Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == model.MbaId);
            if (employee == null) return NotFound();

            model.MbaUsername = (model.MbaUsername ?? string.Empty).Trim();
            model.MbaFullName = (model.MbaFullName ?? string.Empty).Trim();
            model.MbaEmail = model.MbaEmail?.Trim();
            model.MbaPhone = model.MbaPhone?.Trim();

            if (string.IsNullOrWhiteSpace(model.MbaUsername))
                ModelState.AddModelError(nameof(model.MbaUsername), "Tên tài khoản không được để trống.");
            if (string.IsNullOrWhiteSpace(model.MbaFullName))
                ModelState.AddModelError(nameof(model.MbaFullName), "Họ tên không được để trống.");
            if (_db.MbaAccounts.Any(x => x.MbaId != employee.MbaAccountId && x.MbaUsername == model.MbaUsername))
                ModelState.AddModelError(nameof(model.MbaUsername), "Tên tài khoản đã được sử dụng.");

            if (!ModelState.IsValid)
            {
                model.MbaAvatarUrl = employee.MbaAvatarUrl;
                return View(model);
            }

            employee.MbaAccount.MbaUsername = model.MbaUsername;
            employee.MbaFullName = model.MbaFullName;
            employee.MbaEmail = model.MbaEmail;
            employee.MbaPhone = model.MbaPhone;
            _db.SaveChanges();

            if (HttpContext.Session.GetInt32("MbaEmployeeId") == employee.MbaId)
            {
                HttpContext.Session.SetString("UserName", employee.MbaAccount.MbaUsername);
                HttpContext.Session.SetString("DisplayName", employee.MbaFullName);
            }

            TempData["EmployeeMessage"] = $"Đã cập nhật thông tin nhân viên {employee.MbaFullName}.";
            return RedirectToAction(nameof(MbaEmployees));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaToggleEmployee(int id)
        {
            var employee = _db.MbaEmployees.Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == id);
            if (employee == null) return NotFound();
            employee.MbaIsActive = !employee.MbaIsActive;
            employee.MbaAccount.MbaIsActive = employee.MbaIsActive;
            _db.SaveChanges();
            return RedirectToAction(nameof(MbaEmployees));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaAssignReview(int reviewId, int employeeId, DateTime? deadline = null)
        {
            MbaReviewDeadlineService.MbaCloseExpiredReviewsAsync(_db).GetAwaiter().GetResult();
            var review = _db.MbaReviews.Find(reviewId);
            var employee = _db.MbaEmployees.Include(x => x.MbaAccount).FirstOrDefault(x => x.MbaId == employeeId && x.MbaIsActive && x.MbaAccount.MbaIsActive);
            if (review == null || employee == null) return NotFound();
            if (review.MbaIsLocked) {
                TempData["ReviewAssignmentMessage"] = "Phiếu đã bị khóa do hết thời hạn, không thể phân công lại.";
                return RedirectToAction(nameof(MbaReviewData));
            }
            review.MbaEmployeeId = employee.MbaId;
            review.MbaAssignedAt ??= DateTime.Now;
            review.MbaDeadline = deadline ?? review.MbaDeadline ?? DateTime.Now.AddDays(1);
            if (review.MbaStatus == "Chờ rà soát" || review.MbaStatus == "Cần báo lại" || review.MbaStatus == "Đã chốt quá hạn") review.MbaStatus = "Đang xử lý";
            review.MbaIsOverdue = false;
            review.MbaIsLocked = false;
            review.MbaClosedAt = null;
            _db.SaveChanges();
            return RedirectToAction(nameof(MbaReviewData));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaBulkAssignReviews(int? categoryId, int employeeId, int fromPosition = 0, int toPosition = 0, bool onlyUnassigned = true, DateTime? deadline = null)
        {
            MbaReviewDeadlineService.MbaCloseExpiredReviewsAsync(_db).GetAwaiter().GetResult();
            var employee = _db.MbaEmployees.Include(x => x.MbaAccount)
                .FirstOrDefault(x => x.MbaId == employeeId && x.MbaIsActive && x.MbaAccount.MbaIsActive);
            if (employee == null) return NotFound();
            var assignmentDeadline = deadline ?? DateTime.Now.AddDays(1);
            if (assignmentDeadline <= DateTime.Now)
            {
                TempData["ReviewAssignmentMessage"] = "Thời hạn phải lớn hơn thời điểm hiện tại.";
                return RedirectToAction(nameof(MbaReviewData));
            }

            var productsQuery = _db.MbaProducts.AsQueryable().OrderBy(x => x.MbaId);
            if (categoryId.HasValue)
                productsQuery = productsQuery.Where(x => x.MbaCategoryId == categoryId.Value).OrderBy(x => x.MbaId);

            List<MbaProduct> products;
            if (fromPosition > 0 || toPosition > 0)
            {
                if (fromPosition < 1 || toPosition < fromPosition)
                {
                    TempData["ReviewAssignmentMessage"] = "Khoảng sản phẩm không hợp lệ. Hãy nhập vị trí bắt đầu và kết thúc đúng thứ tự.";
                    return RedirectToAction(nameof(MbaReviewData));
                }
                var take = toPosition - fromPosition + 1;
                products = productsQuery.Skip(fromPosition - 1).Take(take).ToList();
            }
            else
            {
                products = productsQuery.ToList();
            }

            if (products.Count == 0)
            {
                TempData["ReviewAssignmentMessage"] = "Không tìm thấy sản phẩm phù hợp với phạm vi phân công.";
                return RedirectToAction(nameof(MbaReviewData));
            }

            var productIds = products.Select(x => x.MbaId).ToList();
            var reviews = _db.MbaReviews.Where(x => productIds.Contains(x.MbaProductId)).ToList();
            var reviewMap = reviews.ToDictionary(x => x.MbaProductId);
            var assigned = 0;
            var created = 0;
            var skipped = 0;

            foreach (var product in products)
            {
                if (!reviewMap.TryGetValue(product.MbaId, out var review))
                {
                    review = new MbaReviewItem
                    {
                        MbaProductId = product.MbaId,
                        MbaStatus = "Đang xử lý",
                        MbaCheckedItems = 0,
                        MbaTotalItems = 5,
                        MbaSourceNote = "Phiếu giấy do quản lý bàn giao",
                        MbaEmployeeId = employee.MbaId,
                        MbaAssignedAt = DateTime.Now,
                        MbaDeadline = assignmentDeadline
                    };
                    _db.MbaReviews.Add(review);
                    created++;
                    assigned++;
                    continue;
                }

                if (review.MbaStatus == "Đã hoàn tất")
                {
                    skipped++;
                    continue;
                }
                if (review.MbaIsLocked)
                {
                    skipped++;
                    continue;
                }

                if (onlyUnassigned && review.MbaEmployeeId.HasValue)
                {
                    skipped++;
                    continue;
                }

                review.MbaEmployeeId = employee.MbaId;
                review.MbaAssignedAt ??= DateTime.Now;
                review.MbaDeadline = assignmentDeadline;
                review.MbaIsLocked = false;
                review.MbaIsOverdue = false;
                review.MbaClosedAt = null;
                review.MbaStatus = "Đang xử lý";
                assigned++;
            }

            _db.SaveChanges();
            TempData["ReviewAssignmentMessage"] = $"Đã phân công {assigned} sản phẩm cho {employee.MbaFullName}." +
                (created > 0 ? $" Tạo mới {created} phiếu rà soát." : "") +
                (skipped > 0 ? $" Bỏ qua {skipped} bản ghi đã có người xử lý hoặc đã hoàn tất." : "");
            return RedirectToAction(nameof(MbaReviewData));
        }

        public IActionResult MbaAssignmentMonitor()
        {
            MbaReviewDeadlineService.MbaCloseExpiredReviewsAsync(_db).GetAwaiter().GetResult();
            var now = DateTime.Now;
            var employees = _db.MbaEmployees.AsNoTracking().Where(x => x.MbaIsActive).OrderBy(x => x.MbaFullName).ToList();
            var reviews = _db.MbaReviews.AsNoTracking().ToList();
            var products = _db.MbaProducts.AsNoTracking().ToList();
            var rows = employees.Select(e =>
            {
                var assigned = reviews.Where(r => r.MbaEmployeeId == e.MbaId).ToList();
                var open = assigned.Where(r => !r.MbaIsLocked && r.MbaStatus != "Đã hoàn tất").ToList();
                return new MBA_PC_ProductManagement.MbaModels.MbaEmployeeAssignmentViewModel
                {
                    MbaEmployeeId = e.MbaId,
                    EmployeeName = e.MbaFullName,
                    TotalAssigned = assigned.Count,
                    Completed = assigned.Count(r => r.MbaStatus == "Đã hoàn tất"),
                    InProgress = open.Count,
                    Overdue = assigned.Count(r => r.MbaIsOverdue || (r.MbaDeadline.HasValue && r.MbaDeadline.Value < now && r.MbaStatus != "Đã hoàn tất")),
                    AssignedSections = string.Join(", ", assigned.Select(r => products.FirstOrDefault(p => p.MbaId == r.MbaProductId)?.MbaCategory).Where(x => !string.IsNullOrWhiteSpace(x)).Distinct().OrderBy(x => x).Take(4)),
                    NearestDeadline = open.Where(r => r.MbaDeadline.HasValue).OrderBy(r => r.MbaDeadline).Select(r => r.MbaDeadline).FirstOrDefault()
                };
            }).ToList();
            ViewBag.TotalAssigned = reviews.Count(r => r.MbaEmployeeId.HasValue);
            ViewBag.TotalCompleted = reviews.Count(r => r.MbaEmployeeId.HasValue && r.MbaStatus == "Đã hoàn tất");
            ViewBag.TotalOverdue = reviews.Count(r => r.MbaEmployeeId.HasValue && r.MbaIsOverdue);
            return View(rows);
        }

        public IActionResult MbaAssignmentDetail(int employeeId)
        {
            MbaReviewDeadlineService.MbaCloseExpiredReviewsAsync(_db).GetAwaiter().GetResult();

            var employee = _db.MbaEmployees.AsNoTracking()
                .Include(x => x.MbaAccount)
                .FirstOrDefault(x => x.MbaId == employeeId && x.MbaIsActive);

            if (employee == null) return NotFound();

            var reviews = _db.MbaReviews.AsNoTracking()
                .Where(x => x.MbaEmployeeId == employeeId)
                .OrderBy(x => x.MbaId)
                .ToList();

            var productIds = reviews.Select(x => x.MbaProductId).Distinct().ToList();
            var productMap = _db.MbaProducts.AsNoTracking()
                .Where(x => productIds.Contains(x.MbaId))
                .ToDictionary(x => x.MbaId);

            var rows = reviews.Select((review, index) =>
            {
                productMap.TryGetValue(review.MbaProductId, out var product);
                return new MbaEmployeeAssignmentRow
                {
                    ReviewId = review.MbaId,
                    MbaProductId = review.MbaProductId,
                    Position = index + 1,
                    ProductCode = product?.MbaCode ?? "—",
                    ProductName = product?.MbaName ?? "Sản phẩm không còn tồn tại",
                    MbaCategory = product?.MbaCategory ?? "—",
                    MbaStatus = review.MbaStatus,
                    MbaCheckedItems = review.MbaCheckedItems,
                    MbaTotalItems = review.MbaTotalItems,
                    MbaDeadline = review.MbaDeadline,
                    MbaIsLocked = review.MbaIsLocked,
                    MbaClosedAt = review.MbaClosedAt,
                    MbaReviewNote = review.MbaReviewNote ?? "",
                    MbaSourceNote = review.MbaSourceNote ?? ""
                };
            }).ToList();

            ViewBag.MbaEmployeeId = employee.MbaId;
            ViewBag.EmployeeName = employee.MbaFullName;
            ViewBag.EmployeeUsername = employee.MbaAccount?.MbaUsername;
            ViewBag.TotalAssigned = rows.Count;
            ViewBag.Completed = rows.Count(x => x.MbaStatus == "Đã hoàn tất");
            ViewBag.InProgress = rows.Count(x => x.MbaStatus == "Đang xử lý");
            ViewBag.NotStarted = rows.Count(x => x.MbaStatus == "Chờ rà soát");
            ViewBag.Overdue = rows.Count(x => x.MbaStatus == "Đã chốt quá hạn" || x.MbaIsLocked && x.MbaStatus != "Đã hoàn tất");
            ViewBag.Invalid = rows.Count(x => x.MbaStatus == "Cần báo lại");
            ViewBag.CompletedAtLatest = rows.Where(x => x.MbaStatus == "Đã hoàn tất" && x.MbaClosedAt.HasValue)
                .OrderByDescending(x => x.MbaClosedAt).Select(x => x.MbaClosedAt).FirstOrDefault();

            return View(rows);
        }

        public IActionResult MbaSettings() => View();

        public IActionResult MbaSearch(string? keyword)
        {
            var query = _db.MbaProducts.AsNoTracking();
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                keyword = keyword.Trim();
                query = query.Where(x => x.MbaCode.Contains(keyword) || (x.MbaName ?? "").Contains(keyword) || (x.MbaBrand ?? "").Contains(keyword));
            }
            ViewBag.Keyword = keyword;
            return View(query.ToList());
        }

        public IActionResult MbaReviewData(string? keyword) => MbaDataCheckPage("Rà soát dữ liệu", "Kiểm tra các phiếu đang chờ xử lý hoặc đang được nhân viên rà soát.", new[] { "Chờ rà soát", "Đang xử lý" }, "MbaReviewData", keyword);
        public IActionResult MbaStandardizeData(string? keyword) => MbaDataCheckPage("Chuẩn hóa dữ liệu", "Kiểm tra các bản ghi đã được đối chiếu và chuẩn hóa, đồng thời theo dõi chất lượng dữ liệu.", new[] { "Đã hoàn tất" }, "MbaStandardizeData", keyword);
        public IActionResult MbaInvalidData(string? keyword) => MbaDataCheckPage("Dữ liệu không hợp lệ", "Tập trung các bản ghi có vấn đề để quản lý kiểm tra và yêu cầu xử lý lại.", new[] { "Cần báo lại" }, "MbaInvalidData", keyword);

        private IActionResult MbaDataCheckPage(string title, string description, string[] statuses, string pageKey, string? keyword)
        {
            var reviewsQuery = _db.MbaReviews.AsNoTracking().Include(x => x.MbaEmployee).Where(x => statuses.Contains(x.MbaStatus));
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                keyword = keyword.Trim();
                reviewsQuery = reviewsQuery.Where(r => _db.MbaProducts.Any(p => p.MbaId == r.MbaProductId &&
                    (p.MbaCode.Contains(keyword) || (p.MbaName ?? "").Contains(keyword) || (p.MbaBrand ?? "").Contains(keyword))));
            }

            var reviews = reviewsQuery.ToList();
            var productIds = reviews.Select(x => x.MbaProductId).ToList();
            var productMap = _db.MbaProducts.AsNoTracking().Where(x => productIds.Contains(x.MbaId)).ToDictionary(x => x.MbaId);
            var rows = reviews.Select(r => new MbaAdminCheckRow
            {
                MbaReview = r,
                MbaProduct = productMap.TryGetValue(r.MbaProductId, out var p) ? p : new MbaProduct()
            }).ToList();

            ViewBag.PageTitle = title;
            ViewBag.PageDescription = description;
            ViewBag.PageKey = pageKey;
            ViewBag.Keyword = keyword;
            ViewBag.Pending = _db.MbaReviews.Count(x => x.MbaStatus == "Chờ rà soát");
            ViewBag.Reviewing = _db.MbaReviews.Count(x => x.MbaStatus == "Đang xử lý");
            ViewBag.Completed = _db.MbaReviews.Count(x => x.MbaStatus == "Đã hoàn tất");
            ViewBag.Invalid = _db.MbaReviews.Count(x => x.MbaStatus == "Cần báo lại");
            ViewBag.MbaEmployees = _db.MbaEmployees.AsNoTracking().Include(x => x.MbaAccount).Where(x => x.MbaIsActive && x.MbaAccount.MbaIsActive).OrderBy(x => x.MbaFullName).ToList();
            ViewBag.MbaCategories = _db.MbaCategories.AsNoTracking().OrderBy(x => x.MbaName).ToList();

            return View("MbaDataCheck", rows);
        }

        public IActionResult MbaDelete(int id) => RedirectToAction("MbaDelete", "MbaProducts", new { id });
    }

    public class MbaAdminCheckRow
    {
        public MbaReviewItem MbaReview { get; set; } = new();
        public MbaProduct MbaProduct { get; set; } = new();
    }
}
