namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaEmployeeAssignmentViewModel
    {
        public int MbaEmployeeId { get; set; }
        public string EmployeeName { get; set; } = "";
        public int TotalAssigned { get; set; }
        public int Completed { get; set; }
        public int InProgress { get; set; }
        public int Overdue { get; set; }
        public string AssignedSections { get; set; } = "—";
        public DateTime? NearestDeadline { get; set; }
        public bool AllCompleted => TotalAssigned > 0 && Completed == TotalAssigned;
    }

    public class MbaEmployeeAssignmentRow
    {
        public int ReviewId { get; set; }
        public int MbaProductId { get; set; }
        public int Position { get; set; }
        public string ProductCode { get; set; } = "";
        public string ProductName { get; set; } = "";
        public string MbaCategory { get; set; } = "";
        public string MbaStatus { get; set; } = "";
        public int MbaCheckedItems { get; set; }
        public int MbaTotalItems { get; set; }
        public DateTime? MbaDeadline { get; set; }
        public bool MbaIsLocked { get; set; }
        public DateTime? MbaClosedAt { get; set; }
        public string MbaReviewNote { get; set; } = "";
        public string MbaSourceNote { get; set; } = "";
    }
}
