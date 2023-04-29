local async = require("nio").tests

describe("surefire xml report helpers", function()
	assert:set_parameter("TableFormatLevel", 5)
	local surefire_parser = require("neotest-kotlin.result_parsers.surefire-parser")

	async.it("Should parse test result from basic xml report", function()
		-- Given a test input file with two test results
		local test_file = vim.fn.getcwd() .. "/tests/input_files/surefire_report_1.xml"

		-- When we parse the report
		local result = surefire_parser.parse_report(test_file)

		-- Then we expect the following outcome
		local expected = {
			{
				_attr = {
					classname = "io.genuit.mavendemo.MavenTestLocationTests",
					name = "contextLoads2",
					time = "0.022",
				},
			},
			{
				_attr = {
					classname = "io.genuit.mavendemo.MavenTestLocationTests",
					name = "contextLoads1",
					time = "0.022",
				},
			},
		}

		assert.same(result.testsuite.testcase, expected)
	end)
end)

describe("Surefire should be able to create intermediate results for", function()
	assert:set_parameter("TableFormatLevel", 5)
	local surefire_parser = require("neotest-kotlin.result_parsers.surefire-parser")

	async.it("Single test runs", function()
		-- Given a test input file with two test results
		local test_file = vim.fn.getcwd() .. "/tests/input_files/surefire_report_2.xml"

		-- When we parse the report to test results
		local result = surefire_parser.parse_report(test_file)

		local test_results = surefire_parser.create_intermediate_results(result.testsuite.testcase)

		-- Then we expect the following outcome
		local expected = {
			{
				test_name = "singleTest",
				status = "failed",
				error_info = "Assertion failed",
				raw_output = "stack",
			},
		}

		assert.same(test_results, expected)
	end)

	async.it("multi test runs", function()
		-- Given a test input file with two test results
		local test_file = vim.fn.getcwd() .. "/tests/input_files/surefire_report_3.xml"

		-- When we parse the report to test results
		local result = surefire_parser.parse_report(test_file)

		local test_results = surefire_parser.create_intermediate_results(result.testsuite.testcase)
		-- Then we expect the following outcome
		local expected = {
			{
				test_name = "multi-test1",
				status = "passed",
			},
			{
				test_name = "multi-test2",
				status = "skipped",
				error_info = "Test was skipped",
			},
			{
				test_name = "multi-test3",
				status = "failed",
				error_info = "java.lang.Exception",
				raw_output = "exception-stack",
			},
			{
				test_name = "multi-test4",
				status = "failed",
				error_info = "Assertion failed",
				raw_output = "failed-stack",
			},
		}

		assert.same(test_results, expected)
	end)
end)
