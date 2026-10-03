namespace MBA_PC_ProductManagement.MbaModels
{
    public class MbaErrorViewModel
    {
        public string? RequestId { get; set; }

        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
    }
}
