using Microsoft.AspNetCore.Mvc;
using asp_lambda.Processors;

namespace asp_lambda.Controllers;

[ApiController]
[Route("[controller]")]
public class S3Controller : ControllerBase
{
    private readonly ILogger<CalculatorController> _logger;

    public S3Controller(ILogger<CalculatorController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Performs list objects operation on specified S3 bucket
    /// </summary>
    /// <param name="bucket"></param>
    /// <returns>List of objects in specified S3 bucket</returns>
    [HttpGet("list/{bucket}")]
    public async Task<List<string>> List(string bucket)
    {
        try
        {
            var s3 = new S3Processor();
            List<string> objects = await s3.ListObjects(bucket);
            return objects;
        }
        catch (Exception e)
        {
            _logger.LogInformation(
                $"Error listing objects from bucket {bucket}. Make sure that the bucket exists or you have privileges to access it."
            );
            _logger.LogInformation(e.Message);
            _logger.LogInformation(e.StackTrace);
            throw;
        }
    }

    /// <summary>
    /// Obtains content of specified object in specific bucket
    /// </summary>
    /// <param name="bucket"></param>
    /// <query name="key"></query>
    /// <returns>String content of the requested S3 object</returns>
    [HttpGet("get-object/{bucket}")]
    public async Task<string> GetObject(string bucket, [FromQuery(Name = "key")] string key)
    {
        try
        {
            var s3 = new S3Processor();
            var content = await s3.ReadObject(bucket, key);
            return content;
        }
        catch (Exception e)
        {
            _logger.LogInformation(
                $"Something went wrong while getting object {key} from bucket {bucket}."
            );
            _logger.LogInformation(e.Message);
            _logger.LogInformation(e.StackTrace);
            throw;
        }
    }
}
