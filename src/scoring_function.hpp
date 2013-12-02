#pragma once
#ifndef RF_SCORE_SCORING_FUNCTION_HPP
#define RF_SCORE_SCORING_FUNCTION_HPP

#include <array>
#include <vector>
using namespace std;

class scoring_function
{
public:
	/// Return the scoring function evaluated at (t1, t2, r).
	void score(float* const v, const size_t t1, const size_t t2, const float r2) const;

	/// Weight the terms
	void weight(float* const v) const;
private:
	static const array<float, 15> vdw;
	static const array<float, 5> weights;
};

#endif
