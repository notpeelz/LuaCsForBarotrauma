using System;
using System.IO;
using System.Text;
using Xunit.Abstractions;

namespace TestProject.LuaCs
{
    internal class TestOutputTextWriterAdapter : TextWriter
    {
        private readonly ITestOutputHelper output;

        public TestOutputTextWriterAdapter(ITestOutputHelper output)
        {
            this.output = output;
        }

        public override Encoding Encoding => Encoding.UTF8;

        public override void WriteLine(string? message) => output.WriteLine(message);

        public override void WriteLine(string? format, params object?[] args) => output.WriteLine(format, args);

        public override void Write(char value) => throw new NotImplementedException();
    }
}
