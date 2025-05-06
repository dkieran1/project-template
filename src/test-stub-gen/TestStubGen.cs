using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using GitHub;
using GitHub.Octokit.Client;
using GitHub.Octokit.Client.Authentication;

namespace TestStubGen;

public class TestStubGen(ILogger<TestStubGen> logger)
{
    private static readonly TokenProvider tokenProvider = new TokenProvider(Environment.GetEnvironmentVariable("GITHUB_TOKEN") ?? "");
    private static readonly Microsoft.Kiota.Abstractions.IRequestAdapter adapter = RequestAdapter.Create(new TokenAuthProvider(tokenProvider));
    
    [Function(nameof(TestStubGen))]
    public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
    {
        logger.LogDebug("Entered test stub generator http trigger.");

        var client = new GitHubClient(adapter);

        var rv = "";

        try
        {
            var response = await client.User.Repos.GetAsync();
            response?.ForEach(repo => rv += repo.FullName);
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }
        
        return new OkObjectResult(rv);
    }
}
