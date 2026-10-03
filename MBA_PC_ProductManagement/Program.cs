using MBA_PC_ProductManagement.MbaData;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews()
    .AddRazorOptions(options =>
    {
        options.ViewLocationFormats.Clear();
        options.ViewLocationFormats.Add("/MbaViews/{1}/{0}.cshtml");
        options.ViewLocationFormats.Add("/MbaViews/Shared/{0}.cshtml");
    });
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();
builder.Services.AddDbContext<MbaAppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddHostedService<MbaReviewDeadlineService>();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<MbaAppDbContext>();
    // Migrate database identifiers before EF seeding so an existing DB using
    // the legacy names can be upgraded without breaking the first query.
    MbaDatabaseSetup.MbaEnsureWorkflowColumns(db);
    MbaDbSeeder.MbaInitialize(db);
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/MbaAdmin/MbaError");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();
app.UseSession();
app.UseAuthorization();
app.MapStaticAssets();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=MbaUser}/{action=MbaIndex}/{id?}")
    .WithStaticAssets();

app.Run();
