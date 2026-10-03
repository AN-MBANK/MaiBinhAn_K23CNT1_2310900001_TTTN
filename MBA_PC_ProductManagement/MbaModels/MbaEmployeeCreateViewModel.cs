namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaEmployeeCreateViewModel
    {
        public string MbaUsername { get; set; } = "";
        public string Password { get; set; } = "";
        public string MbaFullName { get; set; } = "";
        public string? MbaEmail { get; set; }
        public string? MbaPhone { get; set; }
    }
}
