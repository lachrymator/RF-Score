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
	float score(vector<float>& t, const size_t t1, const size_t t2, const float r) const;

	/// Weight the terms
	void weight(vector<float>& t) const;
private:
	static const array<float, 15> vdw;
	static const array<float, 5> weights;
};

#endif
