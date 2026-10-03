namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaReviewItem
    {
        public int MbaId { get; set; }
        public int MbaProductId { get; set; }
        public string MbaStatus { get; set; } = "Chờ rà soát";
        public int MbaCheckedItems { get; set; }
        public int MbaTotalItems { get; set; } = 5;
        public string MbaSourceNote { get; set; } = "Phiếu giấy do quản lý bàn giao";
        public string MbaReviewNote { get; set; } = "";
        public int? MbaEmployeeId { get; set; }
        public MbaEmployee? MbaEmployee { get; set; }
        public DateTime? MbaAssignedAt { get; set; }
        public DateTime? MbaDeadline { get; set; }
        public DateTime? MbaClosedAt { get; set; }
        public bool MbaIsLocked { get; set; }
        public bool MbaIsOverdue { get; set; }
    }
}
