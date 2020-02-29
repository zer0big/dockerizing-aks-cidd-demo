using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace AksCalculator.Controllers
{
    [Route("AksCalculator")]
    public class AksCalculatorController : ControllerBase
    {
        private readonly ILogger<AksCalculatorController> _logger;

        public AksCalculatorController(ILogger<AksCalculatorController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        [Route("Add/{input1}/{input2}")]
        public async Task<ResponseObject> AddNumbers(string input1, string input2)
        {
            var responseObject = new ResponseObject();
            try
            {
                var number1 = double.Parse(input1);
                var number2 = double.Parse(input2);

                await Task.Run(() => responseObject.Result = (number1 + number2).ToString());

                _logger.LogInformation("{0} + {1} = {2}", input1, input2, responseObject.Result);
            }
            catch (Exception exception)
            {
                await Task.Run(() => responseObject.Result = exception.Message);
                _logger.LogError(exception.StackTrace);
                _logger.LogError("Wrong info sent through => {0} and {1}", input1, input2);
            }
            return responseObject;
        }

        [HttpGet]
        [Route("Subtract/{input1}/{input2}")]
        public async Task<ResponseObject> SubtractNumbers(string input1, string input2)
        {
            var responseObject = new ResponseObject();
            try
            {
                var number1 = double.Parse(input1);
                var number2 = double.Parse(input2);

                await Task.Run(() => responseObject.Result = (number1 - number2).ToString());
                _logger.LogInformation("{0} - {1} = {2}", input1, input2, responseObject.Result);
            }
            catch (Exception exception)
            {
                await Task.Run(() => responseObject.Result = exception.Message);
                _logger.LogError(exception.StackTrace);
                _logger.LogError("Crap info sent through {0} and {1}", input1, input2);
            }
            return responseObject;
        }
    
    }
}
