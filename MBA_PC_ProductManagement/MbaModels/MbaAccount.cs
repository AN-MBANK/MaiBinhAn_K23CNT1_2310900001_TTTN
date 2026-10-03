namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaAccount
    {
        public int MbaId { get; set; }
        public string MbaUsername { get; set; } = "";
        public string MbaPasswordHash { get; set; } = "";
        public string MbaRole { get; set; } = "Employee";
        public bool MbaIsActive { get; set; } = true;
        public DateTime MbaCreatedAt { get; set; } = DateTime.Now;

        public MbaAdmin? MbaAdmin { get; set; }
        public MbaEmployee? MbaEmployee { get; set; }
    }
}
