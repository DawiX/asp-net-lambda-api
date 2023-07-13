using Amazon.S3;
using Amazon.S3.Model;

namespace asp_lambda.Processors;

public class S3Processor
{
    IAmazonS3 S3Client { get; set; }

    /// <summary>
    /// Default constructor. When invoked in a Lambda environment
    /// the AWS credentials will come from the IAM role associated with the function and the AWS region will be set to the
    /// region the Lambda function is executed in.
    /// </summary>
    public S3Processor()
    {
        S3Client = new AmazonS3Client();
    }

    // <summary>
    /// Constructs an instance with a preconfigured S3 client. This can be used for testing the outside of the Lambda environment.
    /// </summary>
    /// <param name="s3Client"></param>
    public S3Processor(IAmazonS3 s3Client)
    {
        this.S3Client = s3Client;
    }

    /// <summary>
    /// This method lists all objects in S3 bucket.
    /// Takes bucket name as a parameter.
    /// </summary>
    /// <param name="bucketName">An instance of <see cref="string"/></param>
    /// <returns>
    /// List of all objects in specified bucket
    /// </returns>
    public async Task<List<string>> ListObjects(string bucketName)
    {
        var ListObjectV2Paginator = this.S3Client.Paginators.ListObjectsV2(
            new ListObjectsV2Request() { BucketName = bucketName }
        );
        var objectList = new List<string>();
        await foreach (var response in ListObjectV2Paginator.S3Objects)
        {
            objectList.Add(response.Key);
        }
        return objectList;
    }

    /// <summary>
    /// This method lists all objects in S3 bucket.
    /// Takes bucket name as a parameter.
    /// </summary>
    /// <param name="bucketName">An instance of <see cref="string"/></param>
    /// <param name="objectKey">An instance of <see cref="string"/></param>
    /// <returns>
    /// List of all objects in specified bucket
    /// </returns>
    public async Task<string> ReadObject(string bucketName, string objectKey)
    {
        var objectResponse = await this.S3Client.GetObjectAsync(
            new GetObjectRequest() { BucketName = bucketName, Key = objectKey }
        );
        using (StreamReader reader = new StreamReader(objectResponse.ResponseStream))
        {
          await Task.CompletedTask;
          string contents = reader.ReadToEnd();
          return contents;
        }
    }
}
