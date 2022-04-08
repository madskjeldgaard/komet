/*
Run test suite. Exit code 0 = all tests passed, exit code 1 = there were failures.
*/
(
var result = Komet.test();

if(result, {
    0.exit;
}, {
    1.exit;
})
)
