using System;
using System.Diagnostics;
using Xunit.Abstractions;

namespace TestProject.LuaCs
{
    internal class TestOutputTraceListenerAdapter : TraceListener
    {
        private readonly ITestOutputHelper output;

        public TestOutputTraceListenerAdapter(ITestOutputHelper output)
        {
            this.output = output;
        }

        public override void Write(string? message) => throw new NotImplementedException();

        public override void WriteLine(string? message) => output.WriteLine(message);
    }
}
