namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaEmployee
    {
        public int MbaId { get; set; }
        public int MbaAccountId { get; set; }
        public string MbaFullName { get; set; } = "";
        public string? MbaEmail { get; set; }
        public string? MbaPhone { get; set; }
        public string? MbaAvatarUrl { get; set; }
        public bool MbaIsActive { get; set; } = true;

        public MbaAccount MbaAccount { get; set; } = null!;
        public ICollection<MbaReviewItem> MbaReviews { get; set; } = new List<MbaReviewItem>();
    }
}
