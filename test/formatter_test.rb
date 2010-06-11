require "test_helper"

class FormatterTest < Test::Unit::TestCase
  context "formatting report" do
    setup do
      @report = <<-REPORT
.FE
Total 3 tests (Passed: 1; Fails: 1; Errors: 1) (2.00 ms)
  Mozilla 1.9.1.2: Run 3 tests (Passed: 1; Fails: 1; Errors 1) (2.00 ms)
    GreeterTest.testSomethingElse failed (1.00 ms): expected "1" but was "2"
    ()@http://localhost:4224/test/test/greeter_test.js:10
      [LOG] UH!
    GreeterTest.testSomethingElseFails error (1.00 ms): assertEqual is not defined
    ()@http://localhost:4224/test/test/greeter_test.js:14
      REPORT
    end

    should "add pretty colors for both RedGreen and ColorfulHtml" do
      verify_pretty_colors(Jstdutil::RedGreen)
      verify_pretty_colors(Jstdutil::ColorfulHtml)
    end

  end

  def verify_pretty_colors(type)
    report = Jstdutil::Formatter.format(@report, type)

    lines = @report.split("\n")

    expected = type::Color.green(".") +
      type::Color.red("F") +
      type::Color.yellow("E") + "\n"
    expected << type::Color.red(lines[1]) + "\n"
    expected << type::Color.red(lines[2]) + "\n"
    expected << type::Color.red(lines[3]) + "\n"
    expected << lines[4] + "\n"
    expected << lines[5] + "\n"
    expected << type::Color.yellow(lines[6]) + "\n"
    expected << lines[7]

    assert_equal expected.split("\n")[0], report.split("\n")[0]
    assert_equal expected.split("\n")[1], report.split("\n")[1]
    assert_equal expected.split("\n")[2], report.split("\n")[2]
    assert_equal expected.split("\n")[3], report.split("\n")[3]
    assert_equal expected.split("\n")[4], report.split("\n")[4]
    assert_equal expected.split("\n")[5], report.split("\n")[5]
    assert_equal expected.split("\n")[6], report.split("\n")[6]
    assert_equal expected.split("\n")[7], report.split("\n")[7]
    assert_equal expected, report
  end
end
