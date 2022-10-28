int main() {
	constexpr char c = -2;

#ifdef EXPECT_CHAR_SIGNED
	static_assert(c < 0, "Expected char to be signed");
#endif
#ifdef EXPECT_CHAR_UNSIGNED
	static_assert(c > 0, "Expected char to be unsigned");
#endif

}
