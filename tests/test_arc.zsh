#!/usr/bin/env zsh

# Source the plugin
source ../arc-search.plugin.zsh

# Colors for output
typeset COLOR_RED='\033[0;31m'
typeset COLOR_GREEN='\033[0;32m'
typeset COLOR_YELLOW='\033[1;33m'
typeset COLOR_BLUE='\033[0;34m'
typeset COLOR_RESET='\033[0m'
typeset COLOR_BOLD='\033[1m'

# Test helper function with detailed output
run_test() {
    local test_name="$1"
    local input="$2"
    local expected="$3"
    local description="$4"

    print "\n${COLOR_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
    print "${COLOR_BLUE}Test Case: ${COLOR_BOLD}$test_name${COLOR_RESET}"
    print "${COLOR_YELLOW}Description: $description${COLOR_RESET}"
    print "Input: '$input'"
    print "Expected: '$expected'"

    local result=$(url_encode "$input")
    if [[ "$result" == "$expected" ]]; then
        print "${COLOR_GREEN}✓ PASS${COLOR_RESET}"
        return 0
    else
        print "${COLOR_RED}✗ FAIL${COLOR_RESET}"
        print "Got: '$result'"
        return 1
    fi
}

# Initialize counters
typeset -i total_tests=0
typeset -i passed_tests=0
typeset -i failed_tests=0

# Test Suite 1: Basic ASCII Characters
print "\n${COLOR_BOLD}Test Suite 1: Basic ASCII Characters${COLOR_RESET}"

run_test "Lowercase letters" \
    "abcdefghijklmnopqrstuvwxyz" \
    "abcdefghijklmnopqrstuvwxyz" \
    "Testing basic lowercase ASCII letters"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Uppercase letters" \
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
    "Testing basic uppercase ASCII letters"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Numbers" \
    "0123456789" \
    "0123456789" \
    "Testing numeric characters"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Test Suite 2: Special Characters
print "\n${COLOR_BOLD}Test Suite 2: Special Characters${COLOR_RESET}"

run_test "URL-safe special chars" \
    "-_.~" \
    "-_.~" \
    "Testing URL-safe special characters that should not be encoded"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Common special chars" \
    "!@#$%^&*()+=" \
    "%21%40%23%24%25%5e%26%2a%28%29%2b%3d" \
    "Testing common special characters that should be encoded"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Test Suite 3: Spaces and Quotes
print "\n${COLOR_BOLD}Test Suite 3: Spaces and Quotes${COLOR_RESET}"

run_test "Space handling" \
    "Hello World" \
    "Hello%20World" \
    "Testing space encoding"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Quote handling" \
    "Single 'Quote' Double \"Quote\"" \
    "Single%20%27Quote%27%20Double%20%22Quote%22" \
    "Testing quote encoding"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Test Suite 4: Extended Characters
print "\n${COLOR_BOLD}Test Suite 4: Extended Characters${COLOR_RESET}"

run_test "Extended ASCII" \
    "©®™€£¥" \
    "%c2%a9%c2%ae%e2%84%a2%e2%82%ac%c2%a3%c2%a5" \
    "Testing extended ASCII characters"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Emoji" \
    "😀🌟🎉" \
    "%f0%9f%98%80%f0%9f%8c%9f%f0%9f%8e%89" \
    "Testing emoji encoding"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Test Suite 5: Edge Cases
print "\n${COLOR_BOLD}Test Suite 5: Edge Cases${COLOR_RESET}"

run_test "Empty string" \
    "" \
    "" \
    "Testing empty string handling"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

run_test "Long string" \
    "$(printf 'a%.0s' {1..100})" \
    "$(printf 'a%.0s' {1..100})" \
    "Testing long string handling (100 characters)"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Test Suite 6: Arc Browser Command Tests
print "\n${COLOR_BOLD}Test Suite 6: Arc Browser Command Tests${COLOR_RESET}"

test_arc_command() {
    local test_name="$1"
    local command="$2"
    local expected="$3"
    local description="$4"

    print "\n${COLOR_BLUE}Arc Command Test: ${COLOR_BOLD}$test_name${COLOR_RESET}"
    print "${COLOR_YELLOW}Description: $description${COLOR_RESET}"
    print "Command: arc $command"
    print "Expected: $expected"

    local result=$(arc $command 2>&1)
    if [[ "$result" =~ "$expected" ]]; then
        print "${COLOR_GREEN}✓ PASS${COLOR_RESET}"
        return 0
    else
        print "${COLOR_RED}✗ FAIL${COLOR_RESET}"
        print "Got: $result"
        return 1
    fi
}

# Arc browser specific tests
test_arc_command "Basic search" \
    "test search" \
    "open -a Arc.*google.*test%20search" \
    "Testing basic search functionality"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

test_arc_command "Complex search" \
    "how to code in C++" \
    "open -a Arc.*google.*how%20to%20code%20in%20C%2b%2b" \
    "Testing search with special characters"
((total_tests++))
[[ $? -eq 0 ]] && ((passed_tests++)) || ((failed_tests++))

# Print detailed test summary
print "\n${COLOR_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
print "${COLOR_BOLD}Test Summary:${COLOR_RESET}"
print "Total tests run: ${COLOR_BOLD}$total_tests${COLOR_RESET}"
print "${COLOR_GREEN}Tests passed: $passed_tests${COLOR_RESET}"
print "${COLOR_RED}Tests failed: $failed_tests${COLOR_RESET}"
print "Success rate: ${COLOR_BOLD}$((passed_tests * 100 / total_tests))%${COLOR_RESET}"
print "${COLOR_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"

# Exit with failure if any tests failed
[[ $failed_tests -gt 0 ]] && exit 1 || exit 0
