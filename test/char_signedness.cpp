#include <climits>

#ifdef EXPECT_CHAR_SIGNED
#if CHAR_MAX != SCHAR_MAX
#error "Expected char to be signed"
#endif
#endif

#ifdef EXPECT_CHAR_UNSIGNED
#if CHAR_MAX != UCHAR_MAX
#error "Expected char to be unsigned"
#endif
#endif

int main() {
}
