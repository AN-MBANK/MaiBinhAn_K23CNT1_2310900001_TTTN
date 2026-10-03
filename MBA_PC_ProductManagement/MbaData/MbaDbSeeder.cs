using Microsoft.EntityFrameworkCore;
using MBA_PC_ProductManagement.MbaModels;

namespace MBA_PC_ProductManagement.MbaData
{
    public static class MbaDbSeeder
    {
        public static void MbaInitialize(MbaAppDbContext db)
        {
            db.Database.EnsureCreated();

            // Seed tài khoản quản trị thật của hệ thống.
            const string defaultHash = "PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=";
            const string adminUsername = "Maibinhan";
            const string adminPasswordHash = "PBKDF2$100000$pQ81Q0fEuy49LBCX8/iDTg==$adxH/JsUnBGaoefBvJRjGNqO3nnTxQvTrW+i+NwiFTM=";

            var adminAccount = db.MbaAccounts.FirstOrDefault(a => a.MbaUsername == adminUsername);
            var legacyAdmin = db.MbaAccounts.FirstOrDefault(a => a.MbaUsername == "admin" && a.MbaRole == "Admin");

            // Database cũ có tài khoản "admin" thì chuyển sang tài khoản quản trị mới.
            if (adminAccount == null && legacyAdmin != null)
            {
                legacyAdmin.MbaUsername = adminUsername;
                adminAccount = legacyAdmin;
            }
            else if (adminAccount == null)
            {
                adminAccount = new MbaAccount
                {
                    MbaUsername = adminUsername,
                    MbaPasswordHash = adminPasswordHash,
                    MbaRole = "Admin",
                    MbaIsActive = true
                };
                db.MbaAccounts.Add(adminAccount);
            }

            adminAccount.MbaUsername = adminUsername;
            adminAccount.MbaPasswordHash = adminPasswordHash;
            adminAccount.MbaRole = "Admin";
            adminAccount.MbaIsActive = true;
            db.SaveChanges();

            var adminProfile = db.MbaAdmins.FirstOrDefault(a => a.MbaAccountId == adminAccount.MbaId);
            if (adminProfile == null)
            {
                adminProfile = new MbaAdmin { MbaAccountId = adminAccount.MbaId };
                db.MbaAdmins.Add(adminProfile);
            }
            adminProfile.MbaFullName = "Mai Binh An";
            adminProfile.MbaEmail = "Mastershining000@gmail.com";
            adminProfile.MbaPhone = "+84 394772786";
            db.SaveChanges();

            // Nếu database cũ có tài khoản mẫu "employee", chuyển nó thành tài khoản có tên thật.
            var legacyEmployee = db.MbaAccounts.FirstOrDefault(a => a.MbaUsername == "employee" && a.MbaRole == "Employee");
            if (legacyEmployee != null)
            {
                legacyEmployee.MbaUsername = "nguyenminhanh";
                legacyEmployee.MbaPasswordHash = defaultHash;
                db.SaveChanges();

                var legacyProfile = db.MbaEmployees.FirstOrDefault(e => e.MbaAccountId == legacyEmployee.MbaId);
                if (legacyProfile != null)
                {
                    legacyProfile.MbaFullName = "Nguyễn Minh Anh";
                    legacyProfile.MbaEmail = "nguyenminhanh@mba-pc.local";
                    legacyProfile.MbaPhone = "0901000001";
                    db.SaveChanges();
                }
            }

            var employeeSeed = new[]
            {
                new { MbaUsername = "nguyenminhanh", MbaFullName = "Nguyễn Minh Anh", MbaEmail = "nguyenminhanh@mba-pc.local", MbaPhone = "0901000001" },
                new { MbaUsername = "tranquochuy", MbaFullName = "Trần Quốc Huy", MbaEmail = "tranquochuy@mba-pc.local", MbaPhone = "0901000002" },
                new { MbaUsername = "lehoangnam", MbaFullName = "Lê Hoàng Nam", MbaEmail = "lehoangnam@mba-pc.local", MbaPhone = "0901000003" }
            };

            foreach (var item in employeeSeed)
            {
                var account = db.MbaAccounts.FirstOrDefault(a => a.MbaUsername == item.MbaUsername);
                if (account == null)
                {
                    account = new MbaAccount
                    {
                        MbaUsername = item.MbaUsername,
                        MbaPasswordHash = defaultHash,
                        MbaRole = "Employee",
                        MbaIsActive = true
                    };
                    db.MbaAccounts.Add(account);
                    db.SaveChanges();
                }

                if (!db.MbaEmployees.Any(e => e.MbaAccountId == account.MbaId))
                {
                    db.MbaEmployees.Add(new MbaEmployee
                    {
                        MbaAccountId = account.MbaId,
                        MbaFullName = item.MbaFullName,
                        MbaEmail = item.MbaEmail,
                        MbaPhone = item.MbaPhone,
                        MbaIsActive = true
                    });
                    db.SaveChanges();
                }
            }

            if (!db.MbaCategories.Any())
            {
                db.MbaCategories.AddRange(
                    new MbaCategoryItem { MbaCode="DM001", MbaName="Máy tính bộ", MbaDescription="PC Gaming, PC văn phòng" },
                    new MbaCategoryItem { MbaCode="DM002", MbaName="Laptop", MbaDescription="Laptop học tập, làm việc" },
                    new MbaCategoryItem { MbaCode="DM003", MbaName="CPU", MbaDescription="Bộ vi xử lý máy tính" },
                    new MbaCategoryItem { MbaCode="DM004", MbaName="RAM", MbaDescription="Bộ nhớ trong" },
                    new MbaCategoryItem { MbaCode="DM005", MbaName="Card đồ họa", MbaDescription="GPU NVIDIA, AMD" },
                    new MbaCategoryItem { MbaCode="DM006", MbaName="SSD", MbaDescription="SSD SATA và NVMe" },
                    new MbaCategoryItem { MbaCode="DM007", MbaName="HDD", MbaDescription="Ổ cứng HDD" },
                    new MbaCategoryItem { MbaCode="DM008", MbaName="Mainboard", MbaDescription="Bo mạch chủ" },
                    new MbaCategoryItem { MbaCode="DM009", MbaName="Bộ nguồn (PSU)", MbaDescription="Nguồn máy tính" },
                    new MbaCategoryItem { MbaCode="DM010", MbaName="Vỏ máy (Case)", MbaDescription="Vỏ PC" },
                    new MbaCategoryItem { MbaCode="DM011", MbaName="Tản nhiệt", MbaDescription="Tản nhiệt khí và nước" },
                    new MbaCategoryItem { MbaCode="DM012", MbaName="Màn hình (Monitor)", MbaDescription="Màn hình máy tính" }
                );
                db.SaveChanges();
            }

            if (!db.MbaProducts.Any())
            {
                db.MbaProducts.AddRange(
                    new MbaProduct { MbaCode="PC001", MbaName="PC Gaming MBA 01", MbaCategory="Máy tính bộ", MbaCategoryId=1, MbaBrand="MBA", MbaPrice=25000000, MbaQuantity=12, MbaTechnicalInfo="i5-14400F / 16GB DDR5 / SSD NVMe 1TB / RTX 4060 8GB", MbaDataStatus="Chờ rà soát", MbaDescription="PC Gaming phục vụ học tập, lập trình và giải trí." },
                    new MbaProduct { MbaCode="CPU001", MbaName="Intel Core i5-14400F", MbaCategory="CPU", MbaCategoryId=3, MbaBrand="Intel", MbaQuantity=30, MbaTechnicalInfo="10 nhân / 16 luồng / LGA1700", MbaDataStatus="Đang xử lý", MbaDescription="Bộ vi xử lý desktop." },
                    new MbaProduct { MbaCode="VGA001", MbaName="NVIDIA RTX 4060", MbaCategory="Card đồ họa", MbaCategoryId=5, MbaBrand="NVIDIA", MbaPrice=8490000, MbaQuantity=8, MbaTechnicalInfo="8GB GDDR6", MbaDataStatus="Đã hoàn tất", MbaDescription="Card đồ họa cho gaming và đồ họa." },
                    new MbaProduct { MbaCode="RAM001", MbaName="Kingston Fury 16GB", MbaCategory="RAM", MbaCategoryId=4, MbaBrand="Kingston", MbaPrice=1290000, MbaQuantity=20, MbaTechnicalInfo="DDR5 / 5200MHz / 16GB", MbaDataStatus="Cần báo lại", MbaDescription="Bộ nhớ RAM." },
                    new MbaProduct { MbaCode="SSD001", MbaName="Samsung 980 1TB", MbaCategory="SSD", MbaCategoryId=6, MbaBrand="Samsung", MbaPrice=2190000, MbaQuantity=14, MbaTechnicalInfo="NVMe / 1TB", MbaDataStatus="Chờ rà soát", MbaDescription="SSD NVMe." }
                );
                db.SaveChanges();
            }

            if (!db.MbaReviews.Any())
            {
                var employee = db.MbaEmployees.FirstOrDefault();
                db.MbaReviews.AddRange(
                    new MbaReviewItem { MbaProductId=1, MbaStatus="Chờ rà soát", MbaCheckedItems=1 },
                    new MbaReviewItem { MbaProductId=2, MbaStatus="Đang xử lý", MbaCheckedItems=3, MbaEmployeeId=employee?.MbaId },
                    new MbaReviewItem { MbaProductId=3, MbaStatus="Đã hoàn tất", MbaCheckedItems=5, MbaEmployeeId=employee?.MbaId },
                    new MbaReviewItem { MbaProductId=4, MbaStatus="Cần báo lại", MbaCheckedItems=2, MbaReviewNote="Cần đối chiếu lại thông tin trên phiếu giấy." },
                    new MbaReviewItem { MbaProductId=5, MbaStatus="Chờ rà soát", MbaCheckedItems=0 }
                );
                db.SaveChanges();
            }
        }
    }
}
