namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaEmployeeEditViewModel
    {
        public int MbaId { get; set; }
        public int MbaAccountId { get; set; }
        public string MbaUsername { get; set; } = "";
        public string MbaFullName { get; set; } = "";
        public string? MbaEmail { get; set; }
        public string? MbaPhone { get; set; }
        public string? MbaAvatarUrl { get; set; }
    }
}
