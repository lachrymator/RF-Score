#pragma once
#ifndef RF_SCORE_SCORING_FUNCTION_HPP
#define RF_SCORE_SCORING_FUNCTION_HPP

#include <array>
#include <vector>
using namespace std;

class scoring_function
{
public:
	static const size_t n = 15;
	static const size_t np = n*(n+1)>>1;
	static const size_t ns = 1024;
	static const size_t cutoff = 8;
	static const size_t nr = ns*cutoff*cutoff+1;
	static const size_t ne = nr*np;
	static const float cutoff_sqr;

	/// Construct an empty scoring function.
	scoring_function();

	/// Precalculate the scoring function values of sample points for the type combination of t1 and t2.
	void precalculate(const size_t t1, const size_t t2);

	/// Clear e and rs.
	void clear();

	/// Return the scoring function evaluated at (t1, t2, r).
	float score(const size_t t1, const size_t t2, const float r) const;

	vector<float> e;
private:
	static const array<float, n> vdw;
	vector<float> rs;
};

#endif
