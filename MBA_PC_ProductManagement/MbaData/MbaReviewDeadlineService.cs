using MBA_PC_ProductManagement.MbaModels;
using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaData
{
    public sealed class MbaReviewDeadlineService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<MbaReviewDeadlineService> _logger;

        public MbaReviewDeadlineService(IServiceScopeFactory scopeFactory, ILogger<MbaReviewDeadlineService> logger)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();
                    var db = scope.ServiceProvider.GetRequiredService<MbaAppDbContext>();
                    await MbaCloseExpiredReviewsAsync(db, stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Không thể tự động chốt phiếu rà soát quá hạn.");
                }

                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
            }
        }

        public static async Task<int> MbaCloseExpiredReviewsAsync(MbaAppDbContext db, CancellationToken cancellationToken = default)
        {
            var now = DateTime.Now;
            var expired = await db.MbaReviews
                .Include(x => x.MbaEmployee)
                .Where(x => x.MbaDeadline.HasValue && x.MbaDeadline.Value <= now && !x.MbaIsLocked)
                .ToListAsync(cancellationToken);

            foreach (var review in expired)
            {
                review.MbaIsLocked = true;
                review.MbaIsOverdue = review.MbaStatus != "Đã hoàn tất";
                review.MbaClosedAt = now;
                if (review.MbaStatus != "Đã hoàn tất")
                {
                    review.MbaStatus = "Đã chốt quá hạn";
                }
            }

            if (expired.Count > 0)
                await db.SaveChangesAsync(cancellationToken);

            return expired.Count;
        }
    }
}
