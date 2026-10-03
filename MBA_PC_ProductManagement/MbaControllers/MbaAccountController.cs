using MBA_PC_ProductManagement.MbaData;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaControllers
{
    public class MbaAccountController : Controller
    {
        private readonly MbaAppDbContext _db;
        public MbaAccountController(MbaAppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult MbaLogin(string? returnUrl = null)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaLogin(string username, string password, string? returnUrl = null)
        {
            username = (username ?? string.Empty).Trim();
            var account = _db.MbaAccounts
                .Include(x => x.MbaAdmin)
                .Include(x => x.MbaEmployee)
                .FirstOrDefault(x => x.MbaUsername == username);

            if (account != null && account.MbaIsActive && MbaPasswordService.MbaVerify(password ?? string.Empty, account.MbaPasswordHash))
            {
                HttpContext.Session.Clear();
                HttpContext.Session.SetInt32("MbaAccountId", account.MbaId);
                HttpContext.Session.SetString("UserRole", account.MbaRole);
                HttpContext.Session.SetString("UserName", account.MbaUsername);

                if (account.MbaRole == "Admin" && account.MbaAdmin != null)
                {
                    HttpContext.Session.SetString("IsAdmin", "true");
                    HttpContext.Session.SetInt32("AdminId", account.MbaAdmin.MbaId);
                    HttpContext.Session.SetString("DisplayName", account.MbaAdmin.MbaFullName);
                    HttpContext.Session.SetString("MbaAvatarUrl", account.MbaAdmin.MbaAvatarUrl ?? string.Empty);
                    return MbaRedirectToLocalOrDefault(returnUrl, "/MbaAdmin/MbaIndex");
                }

                if (account.MbaRole == "Employee" && account.MbaEmployee != null)
                {
                    HttpContext.Session.SetString("IsEmployee", "true");
                    HttpContext.Session.SetInt32("MbaEmployeeId", account.MbaEmployee.MbaId);
                    HttpContext.Session.SetString("DisplayName", account.MbaEmployee.MbaFullName);
                    HttpContext.Session.SetString("MbaAvatarUrl", account.MbaEmployee.MbaAvatarUrl ?? string.Empty);
                    return MbaRedirectToLocalOrDefault(returnUrl, "/MbaUser/MbaIndex");
                }
            }

            ViewBag.MbaError = "Tên đăng nhập hoặc mật khẩu không đúng, hoặc tài khoản đã bị khóa.";
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult MbaLogout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction(nameof(MbaLogin));
        }

        private IActionResult MbaRedirectToLocalOrDefault(string? returnUrl, string fallback)
        {
            return !string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl)
                ? Redirect(returnUrl)
                : Redirect(fallback);
        }
    }
}
