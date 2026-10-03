namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaProduct
    {
        public int MbaId { get; set; }
        public string MbaCode { get; set; } = "";
        public string? MbaName { get; set; }
        public string? MbaCategory { get; set; }
        public int? MbaCategoryId { get; set; }
        public string? MbaBrand { get; set; }
        public string? MbaDescription { get; set; }
        public string? MbaImageUrl { get; set; }
        public decimal MbaPrice { get; set; }
        public int MbaQuantity { get; set; }
        public string? MbaTechnicalInfo { get; set; }
        public string? MbaDataStatus { get; set; }
    }
}
