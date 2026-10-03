namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaCategoryItem
    {
        public int MbaId { get; set; }
        public string MbaCode { get; set; } = "";
        public string MbaName { get; set; } = "";
        public string MbaDescription { get; set; } = "";
        public bool MbaIsActive { get; set; } = true;
    }
}
