using Newtonsoft.Json;

namespace AksCalculator.Controllers
{
    public class ResponseObject
    {
        [JsonProperty("result")]
        public string Result { get; set; }
    }
}
