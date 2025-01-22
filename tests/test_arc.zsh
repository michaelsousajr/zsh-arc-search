# ~/.oh-my-zsh/custom/plugins/arc-search/tests/test_arc.zsh

#!/usr/bin/env zsh

# Source the plugin
source ../arc-search.plugin.zsh

# Helper function to run tests
run_test() {
   local test_name="$1"
   local test_command="$2"
   local expected="$3"
   
   echo "\nRunning test: $test_name"
   echo "Command: $test_command"
   echo "Expected: $expected"
   
   eval "result=\$($test_command)"
   if [[ "$result" == "$expected" ]]; then
       echo "✅ Test passed"
       return 0
   else
       echo "❌ Test failed"
       echo "Got: $result"
       return 1
   fi
}

# Test cases
echo "Running Arc Search Plugin Tests..."

# Test 1: Basic search
run_test "Basic search" \
   'arc test' \
   'open -a Arc "https://www.google.com/search?q=test"'

# Test 2: Empty command
run_test "Empty command" \
   'arc' \
   'open -a Arc'

# Test 3: Incognito mode
run_test "Incognito mode" \
   'arc -i test' \
   'open -a Arc --new-window --incognito "https://www.google.com/search?q=test"'

# Test 4: Multi-word search
run_test "Multi-word search" \
   'arc how to code' \
   'open -a Arc "https://www.google.com/search?q=how%20to%20code"'

# Test 5: Special characters
run_test "Special characters" \
   'arc "test & test"' \
   'open -a Arc "https://www.google.com/search?q=test%20%26%20test"'

# Test 6: Empty incognito
run_test "Empty incognito" \
   'arc -i' \
   'open -a Arc --new-window --incognito'

# Run tests
echo "\nTest Summary:"
echo "Total tests: 6"
echo "Passed: $((6 - $?))"
echo "Failed: $?"
