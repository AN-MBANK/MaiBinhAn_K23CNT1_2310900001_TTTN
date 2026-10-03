namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaAdmin
    {
        public int MbaId { get; set; }
        public int MbaAccountId { get; set; }
        public string MbaFullName { get; set; } = "";
        public string? MbaEmail { get; set; }
        public string? MbaPhone { get; set; }
        public string? MbaAvatarUrl { get; set; }

        public MbaAccount MbaAccount { get; set; } = null!;
    }
}
