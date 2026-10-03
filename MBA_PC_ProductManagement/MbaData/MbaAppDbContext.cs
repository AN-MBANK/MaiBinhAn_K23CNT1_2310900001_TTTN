using Microsoft.EntityFrameworkCore;
using MBA_PC_ProductManagement.MbaModels;

namespace MBA_PC_ProductManagement.MbaData
{
    public class MbaAppDbContext : DbContext
    {
        public MbaAppDbContext(DbContextOptions<MbaAppDbContext> options) : base(options) { }

        public DbSet<MbaProduct> MbaProducts => Set<MbaProduct>();
        public DbSet<MbaCategoryItem> MbaCategories => Set<MbaCategoryItem>();
        public DbSet<MbaReviewItem> MbaReviews => Set<MbaReviewItem>();
        public DbSet<MbaAccount> MbaAccounts => Set<MbaAccount>();
        public DbSet<MbaAdmin> MbaAdmins => Set<MbaAdmin>();
        public DbSet<MbaEmployee> MbaEmployees => Set<MbaEmployee>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<MbaProduct>(entity =>
            {
                entity.ToTable("Mba_Products");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaCategoryId).HasColumnName("Mba_CategoryId");
                entity.Property(x => x.MbaCode).HasColumnName("Mba_Code");
                entity.Property(x => x.MbaName).HasColumnName("Mba_Name");
                entity.Property(x => x.MbaCategory).HasColumnName("Mba_Category");
                entity.Property(x => x.MbaBrand).HasColumnName("Mba_Brand");
                entity.Property(x => x.MbaDescription).HasColumnName("Mba_Description");
                entity.Property(x => x.MbaImageUrl).HasColumnName("Mba_ImageUrl");
                entity.Property(x => x.MbaPrice).HasColumnName("Mba_Price");
                entity.Property(x => x.MbaQuantity).HasColumnName("Mba_Quantity");
                entity.Property(x => x.MbaTechnicalInfo).HasColumnName("Mba_TechnicalInfo");
                entity.Property(x => x.MbaDataStatus).HasColumnName("Mba_DataStatus");
                entity.HasKey(x => x.MbaId);
                entity.Property(x => x.MbaCode).HasMaxLength(50).IsRequired();
                entity.HasIndex(x => x.MbaCode).IsUnique();
                entity.Property(x => x.MbaName).HasMaxLength(200);
                entity.Property(x => x.MbaCategory).HasMaxLength(100);
                entity.HasOne<MbaCategoryItem>().WithMany().HasForeignKey(x => x.MbaCategoryId).OnDelete(DeleteBehavior.SetNull);
                entity.Property(x => x.MbaBrand).HasMaxLength(100);
                entity.Property(x => x.MbaDescription).HasMaxLength(1000);
                entity.Property(x => x.MbaImageUrl).HasMaxLength(500);
                entity.Property(x => x.MbaPrice).HasColumnType("decimal(18,2)");
                entity.Property(x => x.MbaTechnicalInfo).HasMaxLength(2000);
                entity.Property(x => x.MbaDataStatus).HasMaxLength(50);
            });

            modelBuilder.Entity<MbaCategoryItem>(entity =>
            {
                entity.ToTable("Mba_Categories");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaCode).HasColumnName("Mba_Code");
                entity.Property(x => x.MbaName).HasColumnName("Mba_Name");
                entity.Property(x => x.MbaDescription).HasColumnName("Mba_Description");
                entity.Property(x => x.MbaIsActive).HasColumnName("Mba_IsActive");
                entity.HasKey(x => x.MbaId);
                entity.Property(x => x.MbaCode).HasMaxLength(50).IsRequired();
                entity.HasIndex(x => x.MbaCode).IsUnique();
                entity.Property(x => x.MbaName).HasMaxLength(100).IsRequired();
                entity.Property(x => x.MbaDescription).HasMaxLength(500);
            });

            modelBuilder.Entity<MbaReviewItem>(entity =>
            {
                entity.ToTable("Mba_Reviews");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaProductId).HasColumnName("Mba_ProductId");
                entity.Property(x => x.MbaStatus).HasColumnName("Mba_Status");
                entity.Property(x => x.MbaCheckedItems).HasColumnName("Mba_CheckedItems");
                entity.Property(x => x.MbaTotalItems).HasColumnName("Mba_TotalItems");
                entity.Property(x => x.MbaSourceNote).HasColumnName("Mba_SourceNote");
                entity.Property(x => x.MbaReviewNote).HasColumnName("Mba_ReviewNote");
                entity.Property(x => x.MbaEmployeeId).HasColumnName("Mba_EmployeeId");
                entity.Property(x => x.MbaAssignedAt).HasColumnName("Mba_AssignedAt");
                entity.Property(x => x.MbaDeadline).HasColumnName("Mba_Deadline");
                entity.Property(x => x.MbaClosedAt).HasColumnName("Mba_ClosedAt");
                entity.Property(x => x.MbaIsLocked).HasColumnName("Mba_IsLocked");
                entity.Property(x => x.MbaIsOverdue).HasColumnName("Mba_IsOverdue");
                entity.HasKey(x => x.MbaId);
                entity.HasIndex(x => x.MbaProductId).IsUnique();
                entity.Property(x => x.MbaStatus).HasMaxLength(50).IsRequired();
                entity.Property(x => x.MbaSourceNote).HasMaxLength(500);
                entity.Property(x => x.MbaReviewNote).HasMaxLength(1000);
                entity.Property(x => x.MbaAssignedAt).HasColumnType("datetime2");
                entity.Property(x => x.MbaDeadline).HasColumnType("datetime2");
                entity.Property(x => x.MbaClosedAt).HasColumnType("datetime2");
                entity.HasOne(x => x.MbaEmployee).WithMany(x => x.MbaReviews).HasForeignKey(x => x.MbaEmployeeId).OnDelete(DeleteBehavior.SetNull);
                entity.HasOne<MbaProduct>()
                    .WithMany()
                    .HasForeignKey(x => x.MbaProductId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<MbaAccount>(entity =>
            {
                entity.ToTable("Mba_Accounts");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaUsername).HasColumnName("Mba_Username");
                entity.Property(x => x.MbaPasswordHash).HasColumnName("Mba_PasswordHash");
                entity.Property(x => x.MbaRole).HasColumnName("Mba_Role");
                entity.Property(x => x.MbaIsActive).HasColumnName("Mba_IsActive");
                entity.Property(x => x.MbaCreatedAt).HasColumnName("Mba_CreatedAt");
                entity.HasKey(x => x.MbaId);
                entity.Property(x => x.MbaUsername).HasMaxLength(100).IsRequired();
                entity.HasIndex(x => x.MbaUsername).IsUnique();
                entity.Property(x => x.MbaPasswordHash).HasMaxLength(500).IsRequired();
                entity.Property(x => x.MbaRole).HasMaxLength(30).IsRequired();
            });

            modelBuilder.Entity<MbaAdmin>(entity =>
            {
                entity.ToTable("Mba_Admins");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaAccountId).HasColumnName("Mba_AccountId");
                entity.Property(x => x.MbaFullName).HasColumnName("Mba_FullName");
                entity.Property(x => x.MbaEmail).HasColumnName("Mba_Email");
                entity.Property(x => x.MbaPhone).HasColumnName("Mba_Phone");
                entity.Property(x => x.MbaAvatarUrl).HasColumnName("Mba_AvatarUrl");
                entity.HasKey(x => x.MbaId);
                entity.HasIndex(x => x.MbaAccountId).IsUnique();
                entity.HasOne(x => x.MbaAccount).WithOne(x => x.MbaAdmin).HasForeignKey<MbaAdmin>(x => x.MbaAccountId).OnDelete(DeleteBehavior.Cascade);
                entity.Property(x => x.MbaFullName).HasMaxLength(150).IsRequired();
                entity.Property(x => x.MbaEmail).HasMaxLength(150);
                entity.Property(x => x.MbaPhone).HasMaxLength(30);
                entity.Property(x => x.MbaAvatarUrl).HasMaxLength(500);
            });

            modelBuilder.Entity<MbaEmployee>(entity =>
            {
                entity.ToTable("Mba_Employees");
                entity.Property(x => x.MbaId).HasColumnName("Mba_Id");
                entity.Property(x => x.MbaAccountId).HasColumnName("Mba_AccountId");
                entity.Property(x => x.MbaFullName).HasColumnName("Mba_FullName");
                entity.Property(x => x.MbaEmail).HasColumnName("Mba_Email");
                entity.Property(x => x.MbaPhone).HasColumnName("Mba_Phone");
                entity.Property(x => x.MbaAvatarUrl).HasColumnName("Mba_AvatarUrl");
                entity.Property(x => x.MbaIsActive).HasColumnName("Mba_IsActive");
                entity.HasKey(x => x.MbaId);
                entity.HasIndex(x => x.MbaAccountId).IsUnique();
                entity.HasOne(x => x.MbaAccount).WithOne(x => x.MbaEmployee).HasForeignKey<MbaEmployee>(x => x.MbaAccountId).OnDelete(DeleteBehavior.Cascade);
                entity.Property(x => x.MbaFullName).HasMaxLength(150).IsRequired();
                entity.Property(x => x.MbaEmail).HasMaxLength(150);
                entity.Property(x => x.MbaPhone).HasMaxLength(30);
                entity.Property(x => x.MbaAvatarUrl).HasMaxLength(500);
            });
        }
    }
}
